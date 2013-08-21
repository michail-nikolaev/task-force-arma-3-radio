/*
 * TeamSpeak 3 demo plugin
 *
 * Copyright (c) 2008-2013 TeamSpeak Systems GmbH
 */

#ifdef _WIN32
#pragma warning (disable : 4100)  /* Disable Unreferenced parameter warning */
#include <Windows.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <assert.h>
#include <iostream>
#include <sstream>
#include <map>
#include <vector>
#include <algorithm>
#include "public_errors.h"
#include "public_errors_rare.h"
#include "public_definitions.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"
#include "plugin.h"
#include "DspFilters\Butterworth.h"

#define M_PI       3.14159265358979323846
#define RADIO_GAIN_SW 20
#define RADIO_GAIN_LR 10

#define MAX_CHANNELS  8
static float* floatsSample[MAX_CHANNELS];

#define SERIOUS_MOD_CHANNEL_NAME "TaskForceRadio"
#define SERIOUS_CHANNEL_PASSWORD "123"

#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe"
//#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe_debug"
#define PLUGIN_NAME "task_force_radio"
#define PLUGIN_NAME_x64 "task_force_radio_x64"
#define MILLIS_TO_EXPIRE 2000  // 2 secondS without updates of client position to expire

#define LR_DISTANCE 20000
#define SW_DISTANCE 3000

inline float sq(float x) {return x * x;}

float distance(TS3_VECTOR from, TS3_VECTOR to)
{
	return sqrt(sq(from.x - to.x) + sq(from.y - to.y) + sq(from.z - to.z));
}

#define PLUGIN_VERSION "0.5.3 pre beta"

struct CLIENT_DATA
{	
	anyID clientId;
	bool tangentPressed;
	bool longRangeTangent;
	TS3_VECTOR clientPosition;
	uint64 positionTime;
	std::string frequency;	
	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS> filterSW;
	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS> filterLR;
	void resetSWFilter() 
	{
		filterSW.reset();
	}
	void resetLRFilter()
	{
		filterLR.reset();
	}
	CLIENT_DATA() 
	{
		positionTime = 0;
		tangentPressed = false;
		longRangeTangent = false;
		clientPosition.x = clientPosition.y = clientPosition.z = 0;
		clientId = -1;
		filterSW.setup(2, 48000, 2000, 800);
		filterLR.setup(4, 48000, 1800);
	}
};

typedef std::map<std::string, CLIENT_DATA*> STRING_TO_CLIENT_DATA_MAP;
struct SERVER_RADIO_DATA 
{	
	std::string myNickname;
	bool tangentPressed;
	TS3_VECTOR myPosition;
	STRING_TO_CLIENT_DATA_MAP nicknameToClientData;
	std::string mySwFrequency;
	std::string myLrFrequency;
	bool alive;

	SERVER_RADIO_DATA()
	{
		tangentPressed = false;
	}
};
typedef std::map<uint64, SERVER_RADIO_DATA> SERVER_ID_TO_SERVER_DATA;

#define PATH_BUFSIZE 512
char pluginPath[PATH_BUFSIZE];

HANDLE thread = INVALID_HANDLE_VALUE;
bool exitThread = FALSE;
bool pipeConnected = false;
bool inGame = false;
uint64 notSeriousChannelId = uint64(-1);
bool vadEnabled = false;
static char* pluginID = NULL;

CRITICAL_SECTION serverDataCriticalSection;
SERVER_ID_TO_SERVER_DATA serverIdToData;

static struct TS3Functions ts3Functions;

void log(const char* message, LogLevel level = LogLevel_DEVEL)
{
#ifndef _DEBUG
	if (level != LogLevel_DEVEL)
#endif
	ts3Functions.logMessage(message, level, "task_force_radio", 141);
}

void log_string(std::string message, LogLevel level = LogLevel_DEVEL) 
{
	log(message.c_str(), level);
}

void log(char* message, DWORD errorCode, LogLevel level = LogLevel_ERROR)
{
	char* errorBuffer;	
	ts3Functions.getErrorMessage(errorCode, &errorBuffer);
	std::string output = std::string(message) + std::string(" : ") + std::string(errorBuffer);
#ifndef _DEBUG
	if (level != LogLevel_DEVEL)
#endif _DEBUG	
	ts3Functions.logMessage(output.c_str(), level, "task_force_radio", 141);
	ts3Functions.freeMemory(errorBuffer);
}

HANDLE openPipe() 
{
	HANDLE pipe = CreateFile(
			PIPE_NAME,
			GENERIC_READ, // only need read access
			FILE_SHARE_READ | FILE_SHARE_WRITE,
			NULL,
			OPEN_EXISTING,
			FILE_ATTRIBUTE_NORMAL,
			NULL
		);
	return pipe;
}

void playWavFile(const char* fileName)
{	
	std::string path = std::string(pluginPath);	
	DWORD error;	
	if ((error = ts3Functions.playWaveFile(ts3Functions.getCurrentServerConnectionHandlerID(), (path + std::string(fileName)).c_str())) != ERROR_ok) 
	{
		log("can't play sound", error, LogLevel_ERROR);
	}
}

std::vector<std::string> &split(const std::string &s, char delim, std::vector<std::string> &elems) 
{
	std::stringstream ss(s);
	std::string item;
	while (std::getline(ss, item, delim)) 
	{
		elems.push_back(item);
	}
	return elems;
}

// taken from https://github.com/MadStyleCow/A2TS_Rebuild/blob/master/src/ts3plugin.cpp#L1367
bool hlp_checkVad()
{
	char* vad; // Is "true" or "false"
	DWORD error;
	if((error = ts3Functions.getPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", &vad)) == ERROR_ok)
	{
		if(strcmp(vad,"true") == 0)
		{
			ts3Functions.freeMemory(vad);
			return true;
		}
		else
		{
			ts3Functions.freeMemory(vad);
			return false;
		}
	}
	else
	{
		log("Failed to get VAD value", error);
		return false;
	}
}

void hlp_enableVad()
{
	DWORD error;
	if((error = ts3Functions.setPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", "true")) != ERROR_ok)
	{
		log("VAD successfully enabled", error);
	}	
}

void hlp_disableVad()
{
	DWORD error;
	if((error = ts3Functions.setPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", "false")) != ERROR_ok)
	{
		log("Failure disabling VAD", error);
	}	
}


std::string getConnectionStatusInfo(bool pipeConnected, bool inGame, bool includeVersion)
{
	std::string result = std::string("[I]Connected to Arma 3:[/I][B] ") 
		+ (pipeConnected ? "true" : "false") + "[/B]  [I]Playing: [/I][B]" 
		+ (inGame ? "true" : "false") 
		+ (includeVersion ? std::string("[/B]  [I]Version: [/I][B]") + PLUGIN_VERSION + "[/B]" : "");
	return result;
}

void updateUserStatusInfo(bool pluginEnabled) {		
	DWORD error;
	std::string result;
	if (pluginEnabled) 	
		result = getConnectionStatusInfo(pipeConnected, inGame, true);	
	else 
		result = "[B]Task Force Radio Plugin Disabled[/B]";
	if((error = ts3Functions.setClientSelfVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_META_DATA, result.c_str())) != ERROR_ok) {
		log("Can't set own META_DATA", error);
	}	
		
	ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
}

std::vector<std::string> split(const std::string &s, char delim) 
{
	std::vector<std::string> elems;
	split(s, delim, elems);
	return elems;
}

bool hasClientData(uint64 serverConnectionHandlerID, anyID clientID)
{
	bool result = false;
	DWORD time = GetTickCount();
	EnterCriticalSection(&serverDataCriticalSection);
	for (STRING_TO_CLIENT_DATA_MAP::iterator it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin(); 
		it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++)
	{
		if (it->second->clientId == clientID && (time - it->second->positionTime < MILLIS_TO_EXPIRE))
		{
			result = true;
			break;
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return result;
}

CLIENT_DATA* getClientData(uint64 serverConnectionHandlerID, anyID clientID)
{
	CLIENT_DATA* data = NULL;
	EnterCriticalSection(&serverDataCriticalSection);
	for (STRING_TO_CLIENT_DATA_MAP::iterator it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin(); 
		it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++)
	{
		if (it->second->clientId == clientID)
		{
			data = it->second;
			break;
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return data;
}

std::vector<anyID> getChannelClients(uint64 serverConnectionHandlerID, uint64 channelId)
{
	std::vector<anyID> result;
	anyID* clients = NULL;
	int i = 0;		
	anyID* clientsCopy = clients;
	if (ts3Functions.getChannelClientList(serverConnectionHandlerID, channelId, &clients) == ERROR_ok) 
	{
		int i = 0;		
		anyID* clientsCopy = clients;		
		while (clients[i]) 		
		{			
			result.push_back(clients[i]);			
			i++;
		}		
		ts3Functions.freeMemory(clients);
	}
	return result;
}

anyID getMyId(uint64 serverConnectionHandlerID)
{
	anyID myID;
	DWORD error;
	if((error = ts3Functions.getClientID(serverConnectionHandlerID, &myID)) != ERROR_ok)
	{
		log("Failure getting client ID", error);
	}
	return myID;
}

uint64 getCurrentChannel(uint64 serverConnectionHandlerID)
{
	uint64 channelId;
	DWORD error;
	if ((error = ts3Functions.getChannelOfClient(serverConnectionHandlerID, getMyId(serverConnectionHandlerID), &channelId)) != ERROR_ok) 
	{
		log("Can't get current channel", error);		
	}
	return channelId;
}

void centerAll(uint64 serverConnectionId) 
{
	std::vector<anyID> clientsIds = getChannelClients(serverConnectionId, getCurrentChannel(serverConnectionId));
	anyID myId = getMyId(serverConnectionId);
	DWORD error;
	for (auto it = clientsIds.begin(); it != clientsIds.end(); it++)
	{
		TS3_VECTOR zero;
		zero.x = zero.y = zero.z = 0.0f;
		if (*it == getMyId(serverConnectionId))
		{			
			if ((error = ts3Functions.systemset3DListenerAttributes(serverConnectionId, &zero, NULL, NULL)) != ERROR_ok)
			{
				log("can't center listener", error);
			}
		}
		else 
		{
			if ((error = ts3Functions.channelset3DAttributes(serverConnectionId, *it, &zero)) != ERROR_ok)
			{
				log("can't center client", error);
			}
		}
	}
}

std::string getMyNickname(uint64 serverConnectionHandlerID)
{
	char* bufferForNickname;
	DWORD error;
	if((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, getMyId(serverConnectionHandlerID), CLIENT_NICKNAME, &bufferForNickname)) != ERROR_ok) {
		log("Error getting client nickname", error);
		return "";
	}
	std::string result = std::string(bufferForNickname);
	ts3Functions.freeMemory(bufferForNickname);
	return result;
}

void onGameEnd(uint64 serverConnectionHandlerID, anyID clientId) 
{
	DWORD error;
	if (notSeriousChannelId != uint64(-1))
	{
		if ((error = ts3Functions.requestClientMove(serverConnectionHandlerID, clientId, notSeriousChannelId, "", NULL)) != ERROR_ok) {
			log("Can't join back channel", error);
		}
		notSeriousChannelId = uint64(-1);
	}
}

void onRespawn(uint64 serverConnectionHandlerID, anyID clientId)
{
	notSeriousChannelId = getCurrentChannel(serverConnectionHandlerID);
	uint64* result;
	DWORD error;
	if ((error = ts3Functions.getChannelList(serverConnectionHandlerID, &result)) != ERROR_ok)
	{
		log("Can't get channel list", error);		
	} 
	else 
	{
		bool joined = false;
		uint64* iter = result;
		while (*iter && !joined)
		{
			uint64 channelId = *iter;
			iter++;
			char* channelName;
			if ((error = ts3Functions.getChannelVariableAsString(serverConnectionHandlerID, channelId, CHANNEL_NAME, &channelName)) != ERROR_ok) {
				log("Can't get channel name", error);
			} 
			else 
			{
				if (!strcmp(SERIOUS_MOD_CHANNEL_NAME, channelName))
				{			
					if (getCurrentChannel(serverConnectionHandlerID) != channelId)
					{					
						if ((error = ts3Functions.requestClientMove(serverConnectionHandlerID, clientId, channelId, SERIOUS_CHANNEL_PASSWORD, NULL)) != ERROR_ok) {
							log("Can't join channel", error);
						} 
						else 
						{
							joined = true;
						}
					}
				}
				ts3Functions.freeMemory(channelName);
			}
		}
		ts3Functions.freeMemory(result);
	}
}

void processGameCommand(std::string command)
{
	static int counter = 0; // TODO: remove, only to debug
	uint64 currentServerConnectionHandlerID = ts3Functions.getCurrentServerConnectionHandlerID();
	if (command == "PING") 
	{
		EnterCriticalSection(&serverDataCriticalSection);	
		serverIdToData[currentServerConnectionHandlerID].alive = false;
		LeaveCriticalSection(&serverDataCriticalSection);
		return;
	};
	std::vector<std::string> tokens = split(command, '@'); // may not be used in nickname
	DWORD error;
	if (tokens.size() == 6 && tokens[0] == "POS") 
	{
		counter++; // TODO: remove, only to debug
		std::string nickname = tokens[1];
		float x = std::stof(tokens[2]);
		float y = std::stof(tokens[3]);
		float z = std::stof(tokens[4]);
		float viewAngle = std::stof(tokens[5]);

		TS3_VECTOR position;
		position.x = x;
		position.y = z; // yes, it is correct
		position.z = y; // yes, it is correct				
		DWORD time = GetTickCount();
		anyID myId = getMyId(currentServerConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection); 
		if (nickname == serverIdToData[currentServerConnectionHandlerID].myNickname) 
		{

			float radians = viewAngle * ((float) M_PI / 180.0f);
			TS3_VECTOR look;
			look.x = sin(radians);
			look.z = cos(radians);
			look.y = 0;
			CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];
			if (clientData)
			{
				clientData->clientId = myId;
				clientData->clientPosition = position;
				clientData->positionTime = time;				
			}
			serverIdToData[currentServerConnectionHandlerID].myPosition = position;

			LeaveCriticalSection(&serverDataCriticalSection);
			DWORD error = ts3Functions.systemset3DListenerAttributes(currentServerConnectionHandlerID, &position, &look, NULL);
			EnterCriticalSection(&serverDataCriticalSection); 
			if(error != ERROR_ok)
			{
				log("Failed to set own 3d position", error);
			}				
		} 
		else 
		{
			if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(nickname))
			{
				CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];
				if (clientData)
				{				
					clientData->clientPosition = position;				
					clientData->positionTime = time;
					LeaveCriticalSection(&serverDataCriticalSection);				
					if ((error = ts3Functions.channelset3DAttributes(currentServerConnectionHandlerID, clientData->clientId, &position)) != ERROR_ok)
					{
						log("Can't set client 3D position", error);
					}
					EnterCriticalSection(&serverDataCriticalSection);
				}
				
			}			
		}				
		LeaveCriticalSection(&serverDataCriticalSection);
	} 
	else if (tokens.size() == 3 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR"))
	{
		bool pressed = (tokens[1] == "PRESSED");
		bool longRange = (tokens[0] == "TANGENT_LR");
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();

		bool changed = false;
		EnterCriticalSection(&serverDataCriticalSection);		
		changed = (serverIdToData[serverId].tangentPressed != pressed);
		serverIdToData[serverId].tangentPressed = pressed;
		LeaveCriticalSection(&serverDataCriticalSection);		
		if (changed)
		{			
			if (pressed)
			{
				if (!longRange) playWavFile("radio-sounds/local_on.wav"); else playWavFile("radio-sounds/local_on_lr.wav");
				vadEnabled = hlp_checkVad();
				hlp_disableVad();
			} 
			else
			{
				if (vadEnabled)	hlp_enableVad();	
				if (!longRange) playWavFile("radio-sounds/local_off.wav"); else playWavFile("radio-sounds/local_off_lr.wav");
			}
			// broadcast info about tangent pressed over all client			
			std::string commandToBroadcast = command + "@" + serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].myNickname;
			log_string(commandToBroadcast, LogLevel_DEVEL);
			ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, commandToBroadcast.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);

			if((error = ts3Functions.setClientSelfVariableAsInt(serverId, CLIENT_INPUT_DEACTIVATED, pressed ? INPUT_ACTIVE : INPUT_DEACTIVATED)) != ERROR_ok) {
				log("Can't active talking by tangent", error);
			}
			DWORD error = ts3Functions.flushClientSelfUpdates(serverId, NULL); 
			if(error != ERROR_ok && error != ERROR_ok_no_update) {
				log("Can't flush self updates", error);
			}
		}		
	} 
	else if (tokens.size() == 5 && tokens[0] == "FREQ")
	{
		counter = 0; // TODO: remove, only to debug
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
		EnterCriticalSection(&serverDataCriticalSection);	
		serverIdToData[serverId].mySwFrequency = tokens[1];
		serverIdToData[serverId].myLrFrequency = tokens[2];
		serverIdToData[serverId].alive = tokens[3] == "true";		
		LeaveCriticalSection(&serverDataCriticalSection);		
		if (getMyNickname(serverId) != tokens[4])
		{
			DWORD error;
			if((error = ts3Functions.setClientSelfVariableAsString(serverId,  CLIENT_NICKNAME, tokens[4].c_str())) != ERROR_ok) {
				log("Error setting client nickname", error);				
			}
		}
	}
}

void removeExpiredPositions(uint64 serverConnectionHandlerID)
{
	DWORD time = GetTickCount();
	std::vector<std::string> toRemove;

	EnterCriticalSection(&serverDataCriticalSection);
	for (auto it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin(); it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++)
	{
		if (time - it->second->positionTime > MILLIS_TO_EXPIRE)
		{			
			toRemove.push_back(it->first);
		}
	}
	for (auto it = toRemove.begin(); it != toRemove.end(); it++)
	{
		CLIENT_DATA* data = serverIdToData[serverConnectionHandlerID].nicknameToClientData[*it];
		serverIdToData[serverConnectionHandlerID].nicknameToClientData.erase(*it);		
		delete data;
		log_string(std::string("Expire position of ") + *it, LogLevel_DEBUG);
	}
	LeaveCriticalSection(&serverDataCriticalSection);

}

void updateNicknamesList(uint64 serverConnectionHandlerID) {	

	std::vector<anyID> clients = getChannelClients(serverConnectionHandlerID, getCurrentChannel(serverConnectionHandlerID));
	DWORD error;
	for (auto clientIdIterator = clients.begin(); clientIdIterator != clients.end(); clientIdIterator++)
	{
		anyID clientId = *clientIdIterator;		
		char* name;
		if((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, clientId, CLIENT_NICKNAME, &name)) != ERROR_ok) {
			log("Error getting client nickname", error);
			continue;
		} 
		else 
		{
			EnterCriticalSection(&serverDataCriticalSection);			
			std::string clientNickname(name);
			if (!serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(clientNickname))
			{
				serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname] = new CLIENT_DATA();
			}
			serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname]->clientId = clientId;
			LeaveCriticalSection(&serverDataCriticalSection);

			ts3Functions.freeMemory(name);
		}					
	}
	std::string myNickname = getMyNickname(serverConnectionHandlerID);
	EnterCriticalSection(&serverDataCriticalSection);			
	serverIdToData[serverConnectionHandlerID].myNickname = myNickname;
	LeaveCriticalSection(&serverDataCriticalSection);

}

DWORD WINAPI PipeThread( LPVOID lpParam )
{
	HANDLE pipe = INVALID_HANDLE_VALUE;	
	DWORD lastUpdate = GetTickCount();
	DWORD lastInGame = GetTickCount();
	DWORD lastCheckForExpire = GetTickCount();		
	DWORD lastInfoUpdate = GetTickCount();

	while (!exitThread)
	{
		if (pipe == INVALID_HANDLE_VALUE) pipe = openPipe();		

		DWORD numBytesRead = 0;
		DWORD numBytesAvail = 0;
		bool sleep = true;
		if (PeekNamedPipe(pipe, NULL, 0, &numBytesRead, &numBytesAvail, NULL)) 
		{
			if (numBytesAvail > 0) 
			{					
				char buffer[4096];
				memset(buffer, 0, 4096);
		
				BOOL result = ReadFile(
							pipe,
							buffer, // the data from the pipe will be put here
							4096, // number of bytes allocated
							&numBytesRead, // this will store number of bytes actually read
							NULL // not using overlapped IO
						);
				if (result) {
					lastUpdate = GetTickCount();
					sleep = false;
					std::string command = std::string(buffer);
					if (command != "PING")
					{
						lastInGame = GetTickCount();
						if (!inGame)
						{
							playWavFile("radio-sounds/on.wav");
							inGame = true;							
							onRespawn(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
						}	
					}				
					if (!pipeConnected)
					{
						pipeConnected = true;						
					}
					processGameCommand(command);
				} else {
					if (pipeConnected) 
					{
						pipeConnected = false;						
					}					
					Sleep(1000);
					pipe = openPipe();					
				}		
			}
		} 
		else 
		{			
			if (pipeConnected) 
			{
				pipeConnected = false;				
				updateUserStatusInfo(true);
			}			
			Sleep(1000);
			pipe = openPipe();			
		}
		if (sleep) 
		{
			Sleep(1);
		}
		if (GetTickCount() - lastCheckForExpire > MILLIS_TO_EXPIRE)
		{			
			removeExpiredPositions(ts3Functions.getCurrentServerConnectionHandlerID());
			updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());
			lastCheckForExpire = GetTickCount();
		}
		if (GetTickCount() - lastInGame > MILLIS_TO_EXPIRE)
		{
			centerAll(ts3Functions.getCurrentServerConnectionHandlerID());			
			lastInGame = GetTickCount();
			if (inGame) 
			{
				playWavFile("radio-sounds/off.wav");			
				EnterCriticalSection(&serverDataCriticalSection);				
				serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].alive = false;
				LeaveCriticalSection(&serverDataCriticalSection);
				onGameEnd(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
			}
			inGame = false;
			
		}
		if (GetTickCount() - lastInfoUpdate > MILLIS_TO_EXPIRE)
		{
			updateUserStatusInfo(true);
			lastInfoUpdate = GetTickCount();
		}
	}	
	CloseHandle(pipe);
	pipe = INVALID_HANDLE_VALUE;
	return NULL;
}

#ifdef _WIN32
#define _strcpy(dest, destSize, src) strcpy_s(dest, destSize, src)
#define snprintf sprintf_s
#else
#define _strcpy(dest, destSize, src) { strncpy(dest, src, destSize-1); (dest)[destSize-1] = '\0'; }
#endif

#define PLUGIN_API_VERSION 19

#define INFODATA_BUFSIZE 128


/*********************************** Required functions ************************************/
/*
 * If any of these required functions is not implemented, TS3 will refuse to load the plugin
 */

/* Unique name identifying this plugin */
const char* ts3plugin_name() {	
	return "Task Force Arma 3 Radio";
}

/* Plugin version */
const char* ts3plugin_version() {
    return PLUGIN_VERSION;
}

/* Plugin API version. Must be the same as the clients API major version, else the plugin fails to load. */
int ts3plugin_apiVersion() {
	return PLUGIN_API_VERSION;
}

/* Plugin author */
const char* ts3plugin_author() {
	/* If you want to use wchar_t, see ts3plugin_name() on how to use */
    return "[TF]Nkey";
}

/* Plugin description */
const char* ts3plugin_description() {
	/* If you want to use wchar_t, see ts3plugin_name() on how to use */
    return "Radio Addon for Arma 3";
}

/* Set TeamSpeak 3 callback functions */
void ts3plugin_setFunctionPointers(const struct TS3Functions funcs) {
    ts3Functions = funcs;
}

/*
 * Custom code called right after loading the plugin. Returns 0 on success, 1 on failure.
 * If the function returns 1 on failure, the plugin will be unloaded again.
 */
int ts3plugin_init() {    
	ts3Functions.getPluginPath(pluginPath, PATH_BUFSIZE);

	InitializeCriticalSection(&serverDataCriticalSection);

	exitThread = FALSE;
	thread = CreateThread(NULL, 0, PipeThread, NULL, 0, NULL);		

	centerAll(ts3Functions.getCurrentServerConnectionHandlerID());
	updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());
	ts3Functions.requestSendChannelTextMsg(ts3Functions.getCurrentServerConnectionHandlerID(), "[B]Task Force Radio: [/B][I]Loading Task Force Radio Plugin[/I]", getCurrentChannel(ts3Functions.getCurrentServerConnectionHandlerID()), NULL);

	for (int q = 0; q < MAX_CHANNELS; q++)
	{
		floatsSample[q] = new float[1];
	}

    return 0;
}



/* Custom code called right before the plugin is unloaded */
void ts3plugin_shutdown() {
    /* Your plugin cleanup code here */
    log("shutdown...");
	exitThread = TRUE;	
	Sleep(1000);	
	DWORD exitCode;
	BOOL result = GetExitCodeThread(thread, &exitCode);
	if (!result || exitCode == STILL_ACTIVE) 
	{
		log("thread not terminated", LogLevel_CRITICAL);
	}
	EnterCriticalSection(&serverDataCriticalSection);
	serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].alive = false;
	LeaveCriticalSection(&serverDataCriticalSection);
	pipeConnected = inGame = false;
	ts3Functions.requestSendChannelTextMsg(ts3Functions.getCurrentServerConnectionHandlerID(), "[B]Task Force Radio: [/B][I]Disabling Task Force Radio Plugin[/I]", getCurrentChannel(ts3Functions.getCurrentServerConnectionHandlerID()), NULL);
	updateUserStatusInfo(false);
	thread = INVALID_HANDLE_VALUE;
	centerAll(ts3Functions.getCurrentServerConnectionHandlerID());
	exitThread = FALSE;
	
	/* Free pluginID if we registered it */
	if(pluginID) {
		free(pluginID);
		pluginID = NULL;
	}
}

/****************************** Optional functions ********************************/
/*
 * Following functions are optional, if not needed you don't need to implement them.
 */

/* Tell client if plugin offers a configuration window. If this function is not implemented, it's an assumed "does not offer" (PLUGIN_OFFERS_NO_CONFIGURE). */
int ts3plugin_offersConfigure() {	
	/*
	 * Return values:
	 * PLUGIN_OFFERS_NO_CONFIGURE         - Plugin does not implement ts3plugin_configure
	 * PLUGIN_OFFERS_CONFIGURE_NEW_THREAD - Plugin does implement ts3plugin_configure and requests to run this function in an own thread
	 * PLUGIN_OFFERS_CONFIGURE_QT_THREAD  - Plugin does implement ts3plugin_configure and requests to run this function in the Qt GUI thread
	 */
	return PLUGIN_OFFERS_NO_CONFIGURE;  /* In this case ts3plugin_configure does not need to be implemented */
}

/* Plugin might offer a configuration window. If ts3plugin_offersConfigure returns 0, this function does not need to be implemented. */
void ts3plugin_configure(void* handle, void* qParentWidget) {    
}

/*
 * If the plugin wants to use error return codes, plugin commands, hotkeys or menu items, it needs to register a command ID. This function will be
 * automatically called after the plugin was initialized. This function is optional. If you don't use these features, this function can be omitted.
 * Note the passed pluginID parameter is no longer valid after calling this function, so you must copy it and store it in the plugin.
 */
void ts3plugin_registerPluginID(const char* id) {
	const size_t sz = strlen(id) + 1;	
	pluginID = (char*)malloc(sz * sizeof(char));
	_strcpy(pluginID, sz, id);  /* The id buffer will invalidate after exiting this function */
	std::string message = std::string("registerPluginID: ") + std::string(pluginID);
	log(message.c_str(), LogLevel_INFO);
}

/* Plugin command keyword. Return NULL or "" if not used. */
const char* ts3plugin_commandKeyword() {
	return "";
}

/* Plugin processes console command. Return 0 if plugin handled the command, 1 if not handled. */
int ts3plugin_processCommand(uint64 serverConnectionHandlerID, const char* command) {
	return 0;  /* Plugin handled command */
}

/* Client changed current server connection handler */
void ts3plugin_currentServerConnectionChanged(uint64 serverConnectionHandlerID) {    
}

/*
 * Implement the following three functions when the plugin should display a line in the server/channel/client info.
 * If any of ts3plugin_infoTitle, ts3plugin_infoData or ts3plugin_freeMemory is missing, the info text will not be displayed.
 */

/* Static title shown in the left column in the info frame */
const char* ts3plugin_infoTitle() {
	std::string info = std::string("Task Force Radio Status (") + PLUGIN_VERSION + ")";
	size_t maxLen = info.length() + 1;
	char* result = (char*) malloc(maxLen * sizeof(char));
	memset(result, 0, maxLen);
	strncpy_s(result, maxLen, info.c_str(), info.length());
	return (const char*) result;
}

/*
 * Dynamic content shown in the right column in the info frame. Memory for the data string needs to be allocated in this
 * function. The client will call ts3plugin_freeMemory once done with the string to release the allocated memory again.
 * Check the parameter "type" if you want to implement this feature only for specific item types. Set the parameter
 * "data" to NULL to have the client ignore the info data.
 */
void ts3plugin_infoData(uint64 serverConnectionHandlerID, uint64 id, enum PluginItemType type, char** data) {
	char* name;
	
	switch(type) {
		case PLUGIN_CLIENT:
			if(ts3Functions.getClientVariableAsString(serverConnectionHandlerID, (anyID)id, CLIENT_META_DATA, &name) != ERROR_ok) {
				log("Error getting client metadata");
				return;
			}
			break;
		default:			
			data = NULL;  /* Ignore */
			return;
	}

	*data = (char*)malloc(INFODATA_BUFSIZE * sizeof(char));  /* Must be allocated in the plugin! */
	snprintf(*data, INFODATA_BUFSIZE, "%s", name);  /* bbCode is supported. HTML is not supported */
	ts3Functions.freeMemory(name);
}

/* Required to release the memory for parameter "data" allocated in ts3plugin_infoData and ts3plugin_initMenus */
void ts3plugin_freeMemory(void* data) {
	free(data);
}

/*
 * Plugin requests to be always automatically loaded by the TeamSpeak 3 client unless
 * the user manually disabled it in the plugin dialog.
 * This function is optional. If missing, no autoload is assumed.
 */
int ts3plugin_requestAutoload() {
	return 0;  /* 1 = request autoloaded, 0 = do not request autoload */
}

/*
 * Initialize plugin menus.
 * This function is called after ts3plugin_init and ts3plugin_registerPluginID. A pluginID is required for plugin menus to work.
 * Both ts3plugin_registerPluginID and ts3plugin_freeMemory must be implemented to use menus.
 * If plugin menus are not used by a plugin, do not implement this function or return NULL.
 */
void ts3plugin_initMenus(struct PluginMenuItem*** menuItems, char** menuIcon) {
}

/*
 * Initialize plugin hotkeys. If your plugin does not use this feature, this function can be omitted.
 * Hotkeys require ts3plugin_registerPluginID and ts3plugin_freeMemory to be implemented.
 * This function is automatically called by the client after ts3plugin_init.
 */
void ts3plugin_initHotkeys(struct PluginHotkey*** hotkeys) {
	hotkeys[0] = NULL;	
}

/************************** TeamSpeak callbacks ***************************/
/*
 * Following functions are optional, feel free to remove unused callbacks.
 * See the clientlib documentation for details on each function.
 */

/* Clientlib */


void ts3plugin_onConnectStatusChangeEvent(uint64 serverConnectionHandlerID, int newStatus, unsigned int errorNumber) {
    /* Some example code following to show how to use the information query functions. */
	unsigned int errorCode;
	if(newStatus == STATUS_CONNECTION_ESTABLISHED)
	{	
		std::string myNickname = getMyNickname(serverConnectionHandlerID);
		anyID myId = getMyId(serverConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection);

		serverIdToData[serverConnectionHandlerID] = SERVER_RADIO_DATA();					
		serverIdToData[serverConnectionHandlerID].myNickname = myNickname;

		LeaveCriticalSection(&serverDataCriticalSection);
	
		
		updateNicknamesList(serverConnectionHandlerID);

		// Set system 3d settings
		errorCode = ts3Functions.systemset3DSettings(serverConnectionHandlerID, 1.0f, 1.0f);
		if(errorCode != ERROR_ok)
		{
			log("Failed to set 3d settings", errorCode);
		}		
	} 
	else if (newStatus == STATUS_DISCONNECTED)
	{
		serverIdToData.erase(serverConnectionHandlerID);
	}
}

void ts3plugin_onNewChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 channelParentID) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onNewChannelCreatedEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 channelParentID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
}

void ts3plugin_onDelChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
}

void ts3plugin_onChannelMoveEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 newChannelParentID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onUpdateChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onUpdateChannelEditedEvent(uint64 serverConnectionHandlerID, uint64 channelID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
}

void ts3plugin_onUpdateClientEvent(uint64 serverConnectionHandlerID, anyID clientID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientMoveEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* moveMessage) {	
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientMoveSubscriptionEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility) {
}

void ts3plugin_onClientMoveTimeoutEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* timeoutMessage) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientMoveMovedEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, anyID moverID, const char* moverName, const char* moverUniqueIdentifier, const char* moveMessage) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientKickFromChannelEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, anyID kickerID, const char* kickerName, const char* kickerUniqueIdentifier, const char* kickMessage) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientKickFromServerEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, anyID kickerID, const char* kickerName, const char* kickerUniqueIdentifier, const char* kickMessage) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientIDsEvent(uint64 serverConnectionHandlerID, const char* uniqueClientIdentifier, anyID clientID, const char* clientName) {
}

void ts3plugin_onClientIDsFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onServerEditedEvent(uint64 serverConnectionHandlerID, anyID editerID, const char* editerName, const char* editerUniqueIdentifier) {
}

void ts3plugin_onServerUpdatedEvent(uint64 serverConnectionHandlerID) {
}

int ts3plugin_onServerErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, const char* extraMessage) {	
	if(returnCode) {
		/* A plugin could now check the returnCode with previously (when calling a function) remembered returnCodes and react accordingly */
		/* In case of using a a plugin return code, the plugin can return:
		 * 0: Client will continue handling this error (print to chat tab)
		 * 1: Client will ignore this error, the plugin announces it has handled it */
		return 1;
	}
	return 0;  /* If no plugin return code was used, the return value of this function is ignored */
}

void ts3plugin_onServerStopEvent(uint64 serverConnectionHandlerID, const char* shutdownMessage) {
}

int ts3plugin_onTextMessageEvent(uint64 serverConnectionHandlerID, anyID targetMode, anyID toID, anyID fromID, const char* fromName, const char* fromUniqueIdentifier, const char* message, int ffIgnored) {    
    return 0;  /* 0 = handle normally, 1 = client will ignore the text message */
}

void ts3plugin_onTalkStatusChangeEvent(uint64 serverConnectionHandlerID, int status, int isReceivedWhisper, anyID clientID) {	
}

void ts3plugin_onConnectionInfoEvent(uint64 serverConnectionHandlerID, anyID clientID) {
}

void ts3plugin_onServerConnectionInfoEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onChannelSubscribeEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
}

void ts3plugin_onChannelSubscribeFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onChannelUnsubscribeEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
}

void ts3plugin_onChannelUnsubscribeFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onChannelDescriptionUpdateEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
}

void ts3plugin_onChannelPasswordChangedEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
}

void ts3plugin_onPlaybackShutdownCompleteEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onSoundDeviceListChangedEvent(const char* modeID, int playOrCap) {
}

void applyGain(short * samples, int channels, int sampleCount, float directTalkingVolume)
{
	for (int i = 0; i < sampleCount * channels; i++) samples[i] = (short)(samples[i] * directTalkingVolume);
}

void processRadioDSP(short * samples, int channels, int sampleCount, float directTalkingVolume, Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>* filterSw,
																								Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>* filterLr)
{
	float zero = 0.0f;		

	for (int i = 0; i < sampleCount * channels; i+= channels)
	{	
		// prepare mono for radio
		short mono[MAX_CHANNELS];
		long long no3D = 0;
		for (int j = 0; j < MAX_CHANNELS; j++) mono[j] = 0;
		for (int j = 0; j < channels; j++)
		{
			no3D += samples[i + j];
		}
		for (int j = 0; j < channels; j++)
		{
			mono[j] = (short) (no3D / channels);
		}	
		// all channels mixed
		float mix[MAX_CHANNELS];
		for (int j = 0; j < MAX_CHANNELS; j++) mix[j] = 0.0;
		// process radio filter
		EnterCriticalSection(&serverDataCriticalSection);
		for (int j = 0; j < channels; j++)
		{			
			floatsSample[j][0] = ((float) mono[j] / (float) SHRT_MAX);			
		}
		// skip other channels
		for (int j = channels; j < MAX_CHANNELS; j++)
		{
			floatsSample[j][0] = 0.0;
		}		
		if (filterSw != NULL) filterSw->process<float>(1, floatsSample);
		if (filterLr != NULL) filterLr->process<float>(1, floatsSample);
		for (int j = 0; j < channels; j++) 
		{			
			if (filterSw != NULL) mix[j] = floatsSample[j][0] * RADIO_GAIN_SW;
			if (filterLr != NULL) mix[j] = floatsSample[j][0] * RADIO_GAIN_LR;
		}
		LeaveCriticalSection(&serverDataCriticalSection);
		// now process and add direct talking to mix
		for (int j = 0; j < channels; j++)
		{
			mix[j] +=  ((float) samples[i + j] / (float) SHRT_MAX) * directTalkingVolume;
		}
		// put mixed output to stream
		for (int j = 0; j < channels; j++)
		{
			float sample = mix[j];
			short newValue;
			if (sample > 1.0) newValue = SHRT_MAX;
			else if (sample < -1.0) newValue = SHRT_MIN;
			else newValue =  (short) (sample * (SHRT_MAX - 1));		
			samples[i + j] = newValue;
		}				
	}
}

void stereoToMonoDSP(short * samples, int channels, int sampleCount)
{
	// 3d sound to mono
	for (int i = 0; i < sampleCount * channels; i+= channels)
	{
		long long no3D = 0;
		for (int j = 0; j < channels; j++)
		{
			no3D += samples[i + j];
		}
		for (int j = 0; j < channels; j++)
		{
			samples[i + j] = (short) (no3D / channels);
		}		
	}
}

bool isSeriousModeEnabled(uint64 serverConnectionHandlerID, anyID clientId)
{
	static DWORD lastCheckTickCount = 0;
	static boolean cachedResult = false;
	if (GetTickCount() - lastCheckTickCount > MILLIS_TO_EXPIRE)
	{	
		uint64 channelId;
		DWORD error;
		if ((error = ts3Functions.getChannelOfClient(serverConnectionHandlerID, clientId, &channelId)) != ERROR_ok)
		{
			log("Can't get channel of client", error);
			return false;	
		}
		char* channelName;
		if ((error = ts3Functions.getChannelVariableAsString(serverConnectionHandlerID, channelId, CHANNEL_NAME, &channelName)) != ERROR_ok) {
			log("Can't get channel name", error);
			return false;
		}
		bool result = !strcmp(SERIOUS_MOD_CHANNEL_NAME, channelName);
		ts3Functions.freeMemory(channelName);
		cachedResult = result;
		lastCheckTickCount = GetTickCount();
	} 
	return cachedResult;
}

void ts3plugin_onEditPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels) {	
}

float volumeFromDistance(uint64 serverConnectionHandlerID, CLIENT_DATA* data)
{	
	EnterCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;	
	LeaveCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR clientPosition = data->clientPosition;
 	float d = distance(myPosition, clientPosition);
	if (d <= 1.0) return 1.0;
	float gain = 1.0f - log10((d / 20.0f) * 10.0f); // 20 metres
	if (gain < 0.001f) return 0.0f; else return min(1.0f, gain);	
}

enum OVER_RADIO_TYPE
{
	LISTEN_TO_SW,
	LISTEN_TO_LR,
	LISTEN_NONE
};

OVER_RADIO_TYPE isOverRadio(uint64 serverConnectionHandlerID, CLIENT_DATA* data)
{	
	OVER_RADIO_TYPE result = LISTEN_NONE;
	EnterCriticalSection(&serverDataCriticalSection);	
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;

	if (data->tangentPressed 
		&& (serverIdToData[serverConnectionHandlerID].myLrFrequency == data->frequency || serverIdToData[serverConnectionHandlerID].mySwFrequency == data->frequency))
	{
		if (data->longRangeTangent && distance(myPosition, clientPosition) < LR_DISTANCE)
		{
			result = LISTEN_TO_LR;
		} 
		else if (!data->longRangeTangent && distance(myPosition, clientPosition) < SW_DISTANCE)
		{
			result = LISTEN_TO_SW;
		}		
	} 
	LeaveCriticalSection(&serverDataCriticalSection);
	return result;	
}

bool isPluginEnabledForUser(uint64 serverConnectionHandlerID, anyID clientID)
{
	char* clientInfo;
	bool result = false;
	DWORD error;
	if ((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, clientID, CLIENT_META_DATA, &clientInfo)) != ERROR_ok) {
		log("Can't get client metadata", error);
		return false;
	} 
	else 
	{
		std::string shouldStartWith = getConnectionStatusInfo(true, true, false);
		std::string clientStatus = std::string(clientInfo);
		if (clientStatus.size() > shouldStartWith.size())
		{
			auto res = std::mismatch(shouldStartWith.begin(), shouldStartWith.end(), clientStatus.begin());
			result = (res.first == shouldStartWith.end());
		} 
		else 
		{
			result = false;
		}		
		ts3Functions.freeMemory(clientInfo);
	}

	return result;
}

void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {	
	static DWORD last_no_info;
	EnterCriticalSection(&serverDataCriticalSection);
	bool alive = serverIdToData[serverConnectionHandlerID].alive;
	LeaveCriticalSection(&serverDataCriticalSection);
	if (hasClientData(serverConnectionHandlerID, clientID) && isPluginEnabledForUser(serverConnectionHandlerID, clientID))
	{		
		CLIENT_DATA* data = getClientData(serverConnectionHandlerID, clientID);		
		if (isSeriousModeEnabled(serverConnectionHandlerID, clientID) && !alive)
		{
			applyGain(samples, channels, sampleCount, 0.0f);
		}
		else 
		{		
			if (data != NULL) 
			{		
				OVER_RADIO_TYPE overRadioType = isOverRadio(serverConnectionHandlerID, data);
				if (overRadioType != LISTEN_NONE)
				{			
					Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>* filterSw = (overRadioType == LISTEN_TO_SW) ? &(data->filterSW) : NULL;
					Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>* filterLr = (overRadioType == LISTEN_TO_LR) ? &(data->filterLR) : NULL;
					processRadioDSP(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data), filterSw, filterLr);
				} 
				else 
				{
					applyGain(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data));
				}
			}
		}
	}
	else 
	{		
		if (!isSeriousModeEnabled(serverConnectionHandlerID, clientID)) 
		{
			stereoToMonoDSP(samples, channels, sampleCount); // mono for clients without information about positions
		}
		else 
		{
			if (!alive & inGame & isPluginEnabledForUser(serverConnectionHandlerID, clientID))
				stereoToMonoDSP(samples, channels, sampleCount); // dead player hears other dead players in serious mode			
			else 
				applyGain(samples, channels, sampleCount, 0.0f); // alive player hears only alive players in serious mode
		}
		if (GetTickCount() - last_no_info > MILLIS_TO_EXPIRE) 
		{
			if (!hasClientData(serverConnectionHandlerID, clientID))
				log_string(std::string("No info about ") + std::to_string((long long)clientID), LogLevel_DEBUG);
			if (!isPluginEnabledForUser(serverConnectionHandlerID, clientID))
				log_string(std::string("No plugin enabled for ") + std::to_string((long long)clientID), LogLevel_DEBUG);
			last_no_info = GetTickCount();
		}		
	}
}

void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
}

void ts3plugin_onEditCapturedVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, int* edited) {
}

void ts3plugin_onCustom3dRolloffCalculationClientEvent(uint64 serverConnectionHandlerID, anyID clientID, float distance, float* volume) {	  	
	*volume = 1.0f;	// custom gain applied
}


void ts3plugin_onCustom3dRolloffCalculationWaveEvent(uint64 serverConnectionHandlerID, uint64 waveHandle, float distance, float* volume) {
}

void ts3plugin_onUserLoggingMessageEvent(const char* logMessage, int logLevel, const char* logChannel, uint64 logID, const char* logTime, const char* completelog_string) {
}

/* Clientlib rare */

void ts3plugin_onClientBanFromServerEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, anyID kickerID, const char* kickerName, const char* kickerUniqueIdentifier, uint64 time, const char* kickMessage) {
}

int ts3plugin_onClientPokeEvent(uint64 serverConnectionHandlerID, anyID fromClientID, const char* pokerName, const char* pokerUniqueIdentity, const char* message, int ffIgnored) {
    return 0;  /* 0 = handle normally, 1 = client will ignore the poke */
}

void ts3plugin_onClientSelfVariableUpdateEvent(uint64 serverConnectionHandlerID, int flag, const char* oldValue, const char* newValue) {
}

void ts3plugin_onFileListEvent(uint64 serverConnectionHandlerID, uint64 channelID, const char* path, const char* name, uint64 size, uint64 datetime, int type, uint64 incompletesize, const char* returnCode) {
}

void ts3plugin_onFileListFinishedEvent(uint64 serverConnectionHandlerID, uint64 channelID, const char* path) {
}

void ts3plugin_onFileInfoEvent(uint64 serverConnectionHandlerID, uint64 channelID, const char* name, uint64 size, uint64 datetime) {
}

void ts3plugin_onServerGroupListEvent(uint64 serverConnectionHandlerID, uint64 serverGroupID, const char* name, int type, int iconID, int saveDB) {
}

void ts3plugin_onServerGroupListFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onServerGroupByClientIDEvent(uint64 serverConnectionHandlerID, const char* name, uint64 serverGroupList, uint64 clientDatabaseID) {
}

void ts3plugin_onServerGroupPermListEvent(uint64 serverConnectionHandlerID, uint64 serverGroupID, unsigned int permissionID, int permissionValue, int permissionNegated, int permissionSkip) {
}

void ts3plugin_onServerGroupPermListFinishedEvent(uint64 serverConnectionHandlerID, uint64 serverGroupID) {
}

void ts3plugin_onServerGroupClientListEvent(uint64 serverConnectionHandlerID, uint64 serverGroupID, uint64 clientDatabaseID, const char* clientNameIdentifier, const char* clientUniqueID) {
}

void ts3plugin_onChannelGroupListEvent(uint64 serverConnectionHandlerID, uint64 channelGroupID, const char* name, int type, int iconID, int saveDB) {
}

void ts3plugin_onChannelGroupListFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onChannelGroupPermListEvent(uint64 serverConnectionHandlerID, uint64 channelGroupID, unsigned int permissionID, int permissionValue, int permissionNegated, int permissionSkip) {
}

void ts3plugin_onChannelGroupPermListFinishedEvent(uint64 serverConnectionHandlerID, uint64 channelGroupID) {
}

void ts3plugin_onChannelPermListEvent(uint64 serverConnectionHandlerID, uint64 channelID, unsigned int permissionID, int permissionValue, int permissionNegated, int permissionSkip) {
}

void ts3plugin_onChannelPermListFinishedEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
}

void ts3plugin_onClientPermListEvent(uint64 serverConnectionHandlerID, uint64 clientDatabaseID, unsigned int permissionID, int permissionValue, int permissionNegated, int permissionSkip) {
}

void ts3plugin_onClientPermListFinishedEvent(uint64 serverConnectionHandlerID, uint64 clientDatabaseID) {
}

void ts3plugin_onChannelClientPermListEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 clientDatabaseID, unsigned int permissionID, int permissionValue, int permissionNegated, int permissionSkip) {
}

void ts3plugin_onChannelClientPermListFinishedEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 clientDatabaseID) {
}

void ts3plugin_onClientChannelGroupChangedEvent(uint64 serverConnectionHandlerID, uint64 channelGroupID, uint64 channelID, anyID clientID, anyID invokerClientID, const char* invokerName, const char* invokerUniqueIdentity) {
}

int ts3plugin_onServerPermissionErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, unsigned int failedPermissionID) {
	return 0;  /* See onServerErrorEvent for return code description */
}

void ts3plugin_onPermissionListGroupEndIDEvent(uint64 serverConnectionHandlerID, unsigned int groupEndID) {
}

void ts3plugin_onPermissionListEvent(uint64 serverConnectionHandlerID, unsigned int permissionID, const char* permissionName, const char* permissionDescription) {
}

void ts3plugin_onPermissionListFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onPermissionOverviewEvent(uint64 serverConnectionHandlerID, uint64 clientDatabaseID, uint64 channelID, int overviewType, uint64 overviewID1, uint64 overviewID2, unsigned int permissionID, int permissionValue, int permissionNegated, int permissionSkip) {
}

void ts3plugin_onPermissionOverviewFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onServerGroupClientAddedEvent(uint64 serverConnectionHandlerID, anyID clientID, const char* clientName, const char* clientUniqueIdentity, uint64 serverGroupID, anyID invokerClientID, const char* invokerName, const char* invokerUniqueIdentity) {
}

void ts3plugin_onServerGroupClientDeletedEvent(uint64 serverConnectionHandlerID, anyID clientID, const char* clientName, const char* clientUniqueIdentity, uint64 serverGroupID, anyID invokerClientID, const char* invokerName, const char* invokerUniqueIdentity) {
}

void ts3plugin_onClientNeededPermissionsEvent(uint64 serverConnectionHandlerID, unsigned int permissionID, int permissionValue) {
}

void ts3plugin_onClientNeededPermissionsFinishedEvent(uint64 serverConnectionHandlerID) {
}

void ts3plugin_onFileTransferStatusEvent(anyID transferID, unsigned int status, const char* statusMessage, uint64 remotefileSize, uint64 serverConnectionHandlerID) {
}

void ts3plugin_onClientChatClosedEvent(uint64 serverConnectionHandlerID, anyID clientID, const char* clientUniqueIdentity) {
}

void ts3plugin_onClientChatComposingEvent(uint64 serverConnectionHandlerID, anyID clientID, const char* clientUniqueIdentity) {
}

void ts3plugin_onServerLogEvent(uint64 serverConnectionHandlerID, const char* logMsg) {
}

void ts3plugin_onServerLogFinishedEvent(uint64 serverConnectionHandlerID, uint64 lastPos, uint64 fileSize) {
}

void ts3plugin_onMessageListEvent(uint64 serverConnectionHandlerID, uint64 messageID, const char* fromClientUniqueIdentity, const char* subject, uint64 timestamp, int flagRead) {
}

void ts3plugin_onMessageGetEvent(uint64 serverConnectionHandlerID, uint64 messageID, const char* fromClientUniqueIdentity, const char* subject, const char* message, uint64 timestamp) {
}

void ts3plugin_onClientDBIDfromUIDEvent(uint64 serverConnectionHandlerID, const char* uniqueClientIdentifier, uint64 clientDatabaseID) {
}

void ts3plugin_onClientNamefromUIDEvent(uint64 serverConnectionHandlerID, const char* uniqueClientIdentifier, uint64 clientDatabaseID, const char* clientNickName) {
}

void ts3plugin_onClientNamefromDBIDEvent(uint64 serverConnectionHandlerID, const char* uniqueClientIdentifier, uint64 clientDatabaseID, const char* clientNickName) {
}

void ts3plugin_onComplainListEvent(uint64 serverConnectionHandlerID, uint64 targetClientDatabaseID, const char* targetClientNickName, uint64 fromClientDatabaseID, const char* fromClientNickName, const char* complainReason, uint64 timestamp) {
}

void ts3plugin_onBanListEvent(uint64 serverConnectionHandlerID, uint64 banid, const char* ip, const char* name, const char* uid, uint64 creationTime, uint64 durationTime, const char* invokerName,
							  uint64 invokercldbid, const char* invokeruid, const char* reason, int numberOfEnforcements, const char* lastNickName) {
}

void ts3plugin_onClientServerQueryLoginPasswordEvent(uint64 serverConnectionHandlerID, const char* loginPassword) {
}

void processPluginCommand(std::string command)
{
	std::vector<std::string> tokens = split(command, '@'); // may not be used in nickname
	if (tokens.size() == 4 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR"))
	{
  		bool pressed = (tokens[1] == "PRESSED");
		bool longRange = (tokens[0] == "TANGENT_LR");
		std::string nickname = tokens[3];
		std::string frequency = tokens[2];
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();

		boolean playPressed = false;
		boolean playReleased = false;

		EnterCriticalSection(&serverDataCriticalSection);
		bool alive = serverIdToData[serverId].alive;
		std::string mySwFrequency = serverIdToData[serverId].mySwFrequency;
		std::string myLrFrequency = serverIdToData[serverId].myLrFrequency;
		if (serverIdToData[serverId].nicknameToClientData.count(nickname))
		{		
			CLIENT_DATA* clientData = serverIdToData[serverId].nicknameToClientData[nickname];
			if (clientData)
			{			
				TS3_VECTOR myPosition = serverIdToData[serverId].myPosition;
		
				if (serverIdToData.count(serverId)) 
				{
					if (nickname != serverIdToData[serverId].myNickname) // ignore command from yourself
					{
						if (clientData->tangentPressed != pressed)
						{
							playPressed = pressed;
							playReleased = !pressed;
						}
						clientData->tangentPressed = pressed;
						clientData->longRangeTangent = longRange;
						clientData->frequency = frequency;
					}
				}		
				float d = distance(myPosition, clientData->clientPosition);
				LeaveCriticalSection(&serverDataCriticalSection);
		
				if (mySwFrequency == frequency && d < SW_DISTANCE)
				{					
					if (playPressed && alive) playWavFile("radio-sounds/remote_start.wav");
					if (playReleased && alive) playWavFile("radio-sounds/remote_end.wav");												
				}
				if (myLrFrequency == frequency && d < LR_DISTANCE)
				{
					if (playPressed && alive) playWavFile("radio-sounds/remote_start_lr.wav");
					if (playReleased && alive) playWavFile("radio-sounds/remote_end_lr.wav");											
				}
				EnterCriticalSection(&serverDataCriticalSection);
				if (playReleased && alive)
				{
					if (clientData->longRangeTangent) clientData->resetSWFilter(); else clientData->resetLRFilter();
				}
				LeaveCriticalSection(&serverDataCriticalSection);
			}
		}
	}
}

void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
	log_string(std::string("ON PLUGIN COMMAND ") +  pluginName + " " + pluginCommand, LogLevel_DEVEL);
	if(serverConnectionHandlerID == ts3Functions.getCurrentServerConnectionHandlerID())
	{
		if((strcmp(pluginName, PLUGIN_NAME)) == 0 || (strcmp(pluginName, PLUGIN_NAME_x64) == 0))
		{			
			processPluginCommand(std::string(pluginCommand));
		}
		else
		{
			log("Plugin command event failure", LogLevel_ERROR);			
		}
	}
}

void ts3plugin_onIncomingClientQueryEvent(uint64 serverConnectionHandlerID, const char* commandText) {
}

void ts3plugin_onServerTemporaryPasswordListEvent(uint64 serverConnectionHandlerID, const char* clientNickname, const char* uniqueClientIdentifier, const char* description, const char* password, uint64 timestampStart, uint64 timestampEnd, uint64 targetChannelID, const char* targetChannelPW) {
}

/* Client UI callbacks */

/*
 * Called from client when an avatar image has been downloaded to or deleted from cache.
 * This callback can be called spontaneously or in response to ts3Functions.getAvatar()
 */
void ts3plugin_onAvatarUpdated(uint64 serverConnectionHandlerID, anyID clientID, const char* avatarPath) {
}

/*
 * Called when a plugin menu item (see ts3plugin_initMenus) is triggered. Optional function, when not using plugin menus, do not implement this.
 * 
 * Parameters:
 * - serverConnectionHandlerID: ID of the current server tab
 * - type: Type of the menu (PLUGIN_MENU_TYPE_CHANNEL, PLUGIN_MENU_TYPE_CLIENT or PLUGIN_MENU_TYPE_GLOBAL)
 * - menuItemID: Id used when creating the menu item
 * - selectedItemID: Channel or Client ID in the case of PLUGIN_MENU_TYPE_CHANNEL and PLUGIN_MENU_TYPE_CLIENT. 0 for PLUGIN_MENU_TYPE_GLOBAL.
 */
void ts3plugin_onMenuItemEvent(uint64 serverConnectionHandlerID, enum PluginMenuType type, int menuItemID, uint64 selectedItemID) {	
}

/* This function is called if a plugin hotkey was pressed. Omit if hotkeys are unused. */
void ts3plugin_onHotkeyEvent(const char* keyword) {	
	/* Identify the hotkey by keyword ("keyword_1", "keyword_2" or "keyword_3" in this example) and handle here... */
}

/* Called when recording a hotkey has finished after calling ts3Functions.requestHotkeyInputDialog */
void ts3plugin_onHotkeyRecordedEvent(const char* keyword, const char* key) {
}
