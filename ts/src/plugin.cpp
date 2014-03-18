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
#include "simpleSource\SimpleComp.h"
#include <wininet.h>

#include "RadioEffect.h"

#define RADIO_GAIN_LR 5
#define RADIO_GAIN_DD 15
#define CANT_SPEAK_GAIN 14

#define MAX_CHANNELS  8
static float* floatsSample[MAX_CHANNELS];

#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe"
//#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe_debug"
#define PLUGIN_NAME "task_force_radio"
#define PLUGIN_NAME_x32 "task_force_radio_win32"
#define PLUGIN_NAME_x64 "task_force_radio_win64"
#define MILLIS_TO_EXPIRE 4000  // 4 seconds without updates of client position to expire

#define DD_MIN_DISTANCE 70
#define DD_MAX_DISTANCE 300

inline float sq(float x) {return x * x;}

float distance(TS3_VECTOR from, TS3_VECTOR to)
{
	return sqrt(sq(from.x - to.x) + sq(from.y - to.y) + sq(from.z - to.z));
}

#define PLUGIN_VERSION "0.8.4a"
#define CANT_SPEAK_DISTANCE 5

#define UPDATE_URL L"raw.github.com"
#define UPDATE_FILE L"/michail-nikolaev/task-force-arma-3-radio/master/current_version.txt"

enum OVER_RADIO_TYPE
{
	LISTEN_TO_SW,
	LISTEN_TO_LR,
	LISTEN_TO_DD,
	LISTEN_TO_NONE
};

enum LISTED_ON {
	LISTED_ON_SW,
	LISTED_ON_LR,
	LISTED_ON_DD,
	LISTED_ON_NONE
};

int versionNumber(std::string versionString)
{
	int number = 0;
	for (unsigned int q = 0; q < versionString.length(); q++) {
		char ch = versionString.at(q);
		if (isdigit(ch))
		{
			number += (ch - 48);
		}
		if (ch == '.')
		{
			number *= 10;
		}
	}
	return number;
}

bool isUpdateAvaible() {	
	DWORD dwBytes;
	char ch;
	std::string pluginVersion;

	DWORD r = 0;
	if (!InternetGetConnectedState(&r, 0)) return false;
	if (r & INTERNET_CONNECTION_OFFLINE) return false;

	HINTERNET Initialize = InternetOpen(L"TFAR", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
	HINTERNET Connection = InternetConnect(Initialize,UPDATE_URL,INTERNET_DEFAULT_HTTP_PORT, NULL,NULL,INTERNET_SERVICE_HTTP,0,0);
	HINTERNET File = HttpOpenRequest(Connection,NULL,UPDATE_FILE,NULL,NULL,NULL,0,0);

	if(HttpSendRequest(File,NULL,0,NULL,0))
	{
		while(InternetReadFile(File,&ch,1,&dwBytes))
		{
			if(dwBytes != 1)break;
			pluginVersion += ch;
		}
	}
	InternetCloseHandle(File);
	InternetCloseHandle(Connection);
	InternetCloseHandle(Initialize);
	std::string currentVersion = PLUGIN_VERSION;
	if (pluginVersion.length() < 10)
	{		
		int pluginVersionI = versionNumber(pluginVersion);
		int currentVersionI = versionNumber(currentVersion);
		return currentVersionI > currentVersionI;
	} 
	else
	{
		return false;
	}	
}

struct CLIENT_DATA
{	
	bool pluginEnabled;
	DWORD pluginEnabledCheck;
	anyID clientId;
	OVER_RADIO_TYPE tangentOverType;
	TS3_VECTOR clientPosition;
	uint64 positionTime;

	std::string frequency;	
	int voiceVolume;
	int range;

	bool canSpeak;
	bool clientTalkingNow;
	int dataFrame;

	bool canUseSWRadio;
	bool canUseLRRadio;
	bool canUseDDRadio;


	std::string subtype;
	std::string vehicleId;

	int terrainInterception;
	PersonalRadioEffect swEffect;	
	LongRangeRadioffect lrEffect;
	UnderWaterRadioEffect ddEffect;
	

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS> filterCantSpeak;	


	chunkware_simple::SimpleComp compressor;
	void resetPersonalRadioEffect() 
	{
		swEffect.reset();
	}
	void resetLongRangeRadioEffect()
	{
		lrEffect.reset();
	}
	void resetUnderwaterRadioEffect()
	{
		ddEffect.reset();
	}

	CLIENT_DATA() 
	{
		positionTime = 0;
		tangentOverType = LISTEN_TO_NONE;
		dataFrame = 0;
		clientPosition.x = clientPosition.y = clientPosition.z = 0;
		clientId = -1;
		voiceVolume = 0;
		canSpeak = true;
		canUseLRRadio = canUseSWRadio = canUseDDRadio = clientTalkingNow = false;
		range = 0;
		terrainInterception = 0;

		filterCantSpeak.setup(4, 48000, 100);

		compressor.setSampleRate(48000);		
		compressor.setThresh(65);
		compressor.setRelease(300);		
		compressor.setAttack(1);
		compressor.setRatio(0.1);		
		compressor.initRuntime();

		resetPersonalRadioEffect();
		resetLongRangeRadioEffect();
		resetUnderwaterRadioEffect();
	}

};

typedef std::map<std::string, CLIENT_DATA*> STRING_TO_CLIENT_DATA_MAP;
struct FREQ_SETTINGS
{
	int volume;
	int stereoMode;
};
#define INVALID_DATA_FRAME 9999
struct SERVER_RADIO_DATA 
{	
	std::string myNickname;
	std::string myOriginalNickname;
	bool tangentPressed;
	TS3_VECTOR myPosition;
	STRING_TO_CLIENT_DATA_MAP nicknameToClientData;
	std::map<std::string, FREQ_SETTINGS> mySwFrequencies;
	std::map<std::string, FREQ_SETTINGS> myLrFrequencies;
	std::string myDdFrequency;
	int ddVolumeLevel;
	int myVoiceVolume;
	bool alive;
	bool canSpeak;	
	float wavesLevel;
	float terrainIntersectionCoefficient;

	std::string serious_mod_channel_name;
	std::string serious_mod_channel_password;
	std::string addon_version;


	int currentDataFrame;

	SERVER_RADIO_DATA()
	{
		tangentPressed = false;
		currentDataFrame = INVALID_DATA_FRAME;
		terrainIntersectionCoefficient = 10.0f;
	}
};
typedef std::map<uint64, SERVER_RADIO_DATA> SERVER_ID_TO_SERVER_DATA;



#define PATH_BUFSIZE 512
char pluginPath[PATH_BUFSIZE];

HANDLE thread = INVALID_HANDLE_VALUE;
HANDLE threadService = INVALID_HANDLE_VALUE;

volatile bool exitThread = FALSE;
volatile bool pipeConnected = false;
volatile bool inGame = false;

volatile uint64 notSeriousChannelId = uint64(-1);
volatile bool vadEnabled = false;
static char* pluginID = NULL;

CRITICAL_SECTION serverDataCriticalSection;
SERVER_ID_TO_SERVER_DATA serverIdToData;

static struct TS3Functions ts3Functions;
//#define DEBUG_MOD_ENABLED

void log(const char* message, LogLevel level = LogLevel_DEVEL)
{
#ifndef DEBUG_MOD_ENABLED
	if (level != LogLevel_DEVEL && level != LogLevel_DEBUG)
#endif
	ts3Functions.logMessage(message, level, "task_force_radio", 141);
}

void log_string(std::string message, LogLevel level = LogLevel_DEVEL) 
{
	log(message.c_str(), level);
}

void log(char* message, DWORD errorCode, LogLevel level = LogLevel_INFO)
{
	char* errorBuffer;	
	ts3Functions.getErrorMessage(errorCode, &errorBuffer);
	std::string output = std::string(message) + std::string(" : ") + std::string(errorBuffer);
#ifndef DEBUG_MOD_ENABLED
	if (level != LogLevel_DEVEL && level != LogLevel_DEBUG)
#endif
	ts3Functions.logMessage(output.c_str(), level, "task_force_radio", 141);
	ts3Functions.freeMemory(errorBuffer);
}

bool startWith(std::string shouldStartWith, std::string startIn)
{
	if (startIn.size() > shouldStartWith.size())
	{
		auto res = std::mismatch(shouldStartWith.begin(), shouldStartWith.end(), startIn.begin());
		return (res.first == shouldStartWith.end());
	} 
	else 
	{
		return false;
	}		
}

HANDLE openPipe() 
{
	HANDLE pipe = CreateFile(
			PIPE_NAME,
			GENERIC_READ | GENERIC_WRITE, 
			FILE_SHARE_READ | FILE_SHARE_WRITE,
			NULL,
			OPEN_EXISTING,
			FILE_ATTRIBUTE_NORMAL,
			NULL
		);
	DWORD error = GetLastError();
	DWORD dwMode = PIPE_READMODE_MESSAGE; 
	SetNamedPipeHandleState( 
		pipe,    // pipe handle 
		&dwMode,  // new pipe mode 
		NULL,     // don't set maximum bytes 
		NULL);    // don't set maximum time 
	return pipe;
}

bool isConnected(uint64 serverConnectionHandlerID)
{	
	DWORD error;
	int result;
	if((error = ts3Functions.getConnectionStatus(serverConnectionHandlerID, &result)) != ERROR_ok)
	{
		return false;
	}
	return result != 0;
}

void playWavFile(const char* fileNameWithoutExtension, bool withGain, int gainLevel)
{	
	if (!isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) return;
	std::string path = std::string(pluginPath);	
	DWORD error;	
	std::string to_play = "";

	if (withGain) to_play = path + std::string(fileNameWithoutExtension) + "_" + std::to_string((long long)gainLevel) + ".wav";
	else to_play = path + std::string(fileNameWithoutExtension) + ".wav";

	if ((error = ts3Functions.playWaveFile(ts3Functions.getCurrentServerConnectionHandlerID(), to_play.c_str())) != ERROR_ok) 
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
		log("Failed to set VAD value", error);
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

anyID getClientId(uint64 serverConnectionHandlerID, std::string nickname)
{
	anyID clienId = -1;
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnectionHandlerID) && serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(nickname) && serverIdToData[serverConnectionHandlerID].nicknameToClientData[nickname])
	{
		clienId = serverIdToData[serverConnectionHandlerID].nicknameToClientData[nickname]->clientId;
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return clienId;
}

std::string getChannelName(uint64 serverConnectionHandlerID, anyID clientId)
{			
	if (clientId == (anyID)-1) return "";
	uint64 channelId;
	DWORD error;
	if ((error = ts3Functions.getChannelOfClient(serverConnectionHandlerID, clientId, &channelId)) != ERROR_ok)
	{
		log("Can't get channel of client", error);
		return "";	
	}
	char* channelName;
	if ((error = ts3Functions.getChannelVariableAsString(serverConnectionHandlerID, channelId, CHANNEL_NAME, &channelName)) != ERROR_ok) {
		log("Can't get channel name", error);
		return "";
	}
	std::string result = std::string(channelName);
	ts3Functions.freeMemory(channelName);			
	return result;
}

bool isInChannel(uint64 serverConnectionHandlerID, anyID clientId, const char* channelToCheck) 
{
	return getChannelName(serverConnectionHandlerID, clientId) == channelToCheck;
}

bool isSeriousModeEnabled(uint64 serverConnectionHandlerID, anyID clientId)
{
	std::string serious_mod_channel_name = "__unknown__";
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnectionHandlerID)) {
		serious_mod_channel_name = serverIdToData[serverConnectionHandlerID].serious_mod_channel_name;
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return (serious_mod_channel_name != "") && isInChannel(serverConnectionHandlerID, clientId, serious_mod_channel_name.c_str());
}

bool isOtherRadioPluginEnabled(uint64 serverConnectionHandlerID, anyID clientId)
{ 
	std::string channelName = getChannelName(serverConnectionHandlerID, clientId);
	return (channelName == "RT")
			|| (channelName == "RT_A2")
			|| (channelName == "RT_OFP")
			|| (channelName == "RT_A3")
			|| (channelName == "Radio")
			|| (channelName == "[ARMA3.RU] Radio")
			|| (channelName == "PvP_WOG");			
}

void setClientMuteStatus(uint64 serverConnectionHandlerID, anyID clientId, bool status)
{	
	anyID clientIds[2];
	clientIds[0] = clientId;
	clientIds[1] = 0;
	if (clientIds[0] > 0)
	{
		DWORD error;
		if (status)
		{
			if ((error = ts3Functions.requestMuteClients(serverConnectionHandlerID, clientIds, NULL)) != ERROR_ok)
			{
				log("Can't mute client", error);
			}
		} 
		else 
		{
			if ((error = ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientIds, NULL)) != ERROR_ok)
			{
				log("Can't unmute client", error);
			}
		}
	}
}

struct LISTED_INFO {
	OVER_RADIO_TYPE over;
	LISTED_ON on;
	int volume;
	int stereoMode;
};

float distanceForDiverRadio(float d, uint64 serverConnectionHandlerID)
{
	float wavesLevel;
	EnterCriticalSection(&serverDataCriticalSection);
	wavesLevel = serverIdToData[serverConnectionHandlerID].wavesLevel;
	LeaveCriticalSection(&serverDataCriticalSection);
	return DD_MIN_DISTANCE + (DD_MAX_DISTANCE - DD_MIN_DISTANCE) * (1.0f - wavesLevel);
}

float effectErrorFromDistance(OVER_RADIO_TYPE radioType, float d, uint64 serverConnectionHandlerID, CLIENT_DATA* data)
{
	float maxD = 0.0f;
	switch (radioType)
	{
		case LISTEN_TO_SW: maxD = (float) data->range; break;
		case LISTEN_TO_DD: maxD = distanceForDiverRadio(d, serverConnectionHandlerID); break;
		case LISTEN_TO_LR: maxD = (float) data->range;
		default: break;
	};	
	return d / maxD;	
}

float effectiveDistance(uint64 serverConnectionHandlerID, CLIENT_DATA* data, CLIENT_DATA* myData)
{
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;
	float d = distance(myPosition, clientPosition);	
	return d + data->terrainInterception *  serverIdToData[serverConnectionHandlerID].terrainIntersectionCoefficient;
}


LISTED_INFO isOverRadio(uint64 serverConnectionHandlerID, CLIENT_DATA* data, CLIENT_DATA* myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent)
{		
	LISTED_INFO result;
	result.over = LISTEN_TO_NONE;
	result.volume = 0;
	result.on = LISTED_ON_NONE;
	if (data == NULL || myData == NULL) return result;

	EnterCriticalSection(&serverDataCriticalSection);	
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;

	float d = effectiveDistance(serverConnectionHandlerID, data, myData);

	if ((data->tangentOverType == LISTEN_TO_SW || ignoreSwTangent)
		&& serverIdToData[serverConnectionHandlerID].myLrFrequencies.count(data->frequency))
	{
		if (data->canUseSWRadio && myData->canUseLRRadio && d < data->range)
		{
			result.over = LISTEN_TO_SW;
			result.on = LISTED_ON_LR;
			result.volume = serverIdToData[serverConnectionHandlerID].myLrFrequencies[data->frequency].volume;
			result.stereoMode = serverIdToData[serverConnectionHandlerID].myLrFrequencies[data->frequency].stereoMode;
		}		
	}
	
	if ((data->tangentOverType == LISTEN_TO_SW || ignoreSwTangent)
		&& serverIdToData[serverConnectionHandlerID].mySwFrequencies.count(data->frequency))
	{
		if (data->canUseSWRadio && myData->canUseSWRadio && d < data->range)
		{
			result.over = LISTEN_TO_SW;
			result.on = LISTED_ON_SW;
			result.volume = serverIdToData[serverConnectionHandlerID].mySwFrequencies[data->frequency].volume;
			result.stereoMode = serverIdToData[serverConnectionHandlerID].mySwFrequencies[data->frequency].stereoMode;
		}		
	}
	
	if ((data->tangentOverType == LISTEN_TO_LR || ignoreLrTangent)
		&& serverIdToData[serverConnectionHandlerID].mySwFrequencies.count(data->frequency))
	{
		if (data->canUseLRRadio && myData->canUseSWRadio && d < data->range)
		{
			result.over = LISTEN_TO_LR;
			result.on = LISTED_ON_SW;
			result.volume = serverIdToData[serverConnectionHandlerID].mySwFrequencies[data->frequency].volume;
			result.stereoMode = serverIdToData[serverConnectionHandlerID].mySwFrequencies[data->frequency].stereoMode;
		}		
	}

	if ((data->tangentOverType == LISTEN_TO_LR || ignoreLrTangent)
		&& serverIdToData[serverConnectionHandlerID].myLrFrequencies.count(data->frequency))
	{
		if (data->canUseLRRadio && myData->canUseLRRadio && d < data->range)
		{
			result.over = LISTEN_TO_LR;
			result.on = LISTED_ON_LR;
			result.volume = serverIdToData[serverConnectionHandlerID].myLrFrequencies[data->frequency].volume;
			result.stereoMode = serverIdToData[serverConnectionHandlerID].myLrFrequencies[data->frequency].stereoMode;
		}		
	}
	
	if ((data->tangentOverType == LISTEN_TO_DD || ignoreDdTangent)
		&& (serverIdToData[serverConnectionHandlerID].myDdFrequency == data->frequency))
	{
		if (data->canUseDDRadio && myData->canUseDDRadio && d < distanceForDiverRadio(d, serverConnectionHandlerID))
		{
			result.over = LISTEN_TO_DD;			
			result.on = LISTED_ON_DD;
			result.volume = serverIdToData[serverConnectionHandlerID].ddVolumeLevel;
			result.stereoMode = 0;
		}		
	}
	
	LeaveCriticalSection(&serverDataCriticalSection);
	return result;	
}

std::string getClientNickname(uint64 serverConnectionHandlerID, anyID clientID)
{
	std::string nickname = "Unknown nickname";
	EnterCriticalSection(&serverDataCriticalSection);
	for (STRING_TO_CLIENT_DATA_MAP::iterator it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin(); 
		it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++)
	{
		if (it->second->clientId == clientID)
		{
			nickname = it->first;
			break;
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return nickname;
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

bool hasClientData(uint64 serverConnectionHandlerID, anyID clientID)
{
	bool result = false;
	DWORD time = GetTickCount();
	EnterCriticalSection(&serverDataCriticalSection);
	int currentDataFrame = serverIdToData[serverConnectionHandlerID].currentDataFrame;
	for (STRING_TO_CLIENT_DATA_MAP::iterator it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin(); 
		it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++)
	{
		if (it->second->clientId == clientID && (abs(currentDataFrame - it->second->dataFrame) <= 1))
		{
			result = true;
			break;
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return result;
}

float distanceFromClient(uint64 serverConnectionHandlerID, CLIENT_DATA* data)
{
	EnterCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;		
	TS3_VECTOR clientPosition = data->clientPosition;
	float d = distance(myPosition, clientPosition);
	LeaveCriticalSection(&serverDataCriticalSection);
	return d;
}

float volumeFromDistance(uint64 serverConnectionHandlerID, CLIENT_DATA* data, float d, bool shouldPlayerHear)
{	
	EnterCriticalSection(&serverDataCriticalSection);
	int clientVolume = data->voiceVolume;
	bool canSpeak = data->canSpeak;
	LeaveCriticalSection(&serverDataCriticalSection);
		
	if (d <= 1.0) return 1.0;
	float maxDistance = shouldPlayerHear ? (float) clientVolume : CANT_SPEAK_DISTANCE;
	float gain = 1.0f - log10((d / maxDistance) * 10.0f);
	if (gain < 0.001f) return 0.0f; else return min(1.0f, gain);	
}


anyID getMyId(uint64 serverConnectionHandlerID)
{
	anyID myID = (anyID) -1;
	if (!isConnected(serverConnectionHandlerID)) return myID;
	DWORD error;
	if((error = ts3Functions.getClientID(serverConnectionHandlerID, &myID)) != ERROR_ok)
	{
		log("Failure getting client ID", error);
	}
	return myID;
}

bool isTalking(uint64 currentServerConnectionHandlerID, anyID myId, anyID playerId) {
	int result = 0;
	DWORD error;
	if (playerId == myId) {
		if ((error = ts3Functions.getClientSelfVariableAsInt(currentServerConnectionHandlerID, CLIENT_FLAG_TALKING, &result)) != ERROR_ok) {
			log("Can't get talking status", error);
		}
	}
	else {
		if ((error = ts3Functions.getClientVariableAsInt(currentServerConnectionHandlerID, playerId, CLIENT_FLAG_TALKING, &result)) != ERROR_ok) {
			log("Can't get talking status", error);
		}
	}
	return result != 0;
}


void setGameClientMuteStatus(uint64 serverConnectionHandlerID, anyID clientId)
{	
	bool mute = false;
	if (isSeriousModeEnabled(serverConnectionHandlerID, clientId))
	{
		EnterCriticalSection(&serverDataCriticalSection);		
		CLIENT_DATA* data = hasClientData(serverConnectionHandlerID, clientId) ? getClientData(serverConnectionHandlerID, clientId) : NULL;
		CLIENT_DATA* myData = hasClientData(serverConnectionHandlerID, getMyId(serverConnectionHandlerID)) 
								? getClientData(serverConnectionHandlerID, getMyId(serverConnectionHandlerID)) : NULL;
		bool alive = false;		
		if (data && myData && serverIdToData[serverConnectionHandlerID].alive)
		{
			LISTED_INFO listedInfo = isOverRadio(serverConnectionHandlerID, data, myData, false, false, false);
			if (listedInfo.on == LISTEN_TO_NONE)
			{
				bool isTalk = data->clientTalkingNow || isTalking(serverConnectionHandlerID, getMyId(serverConnectionHandlerID), clientId);
				mute = (distanceFromClient(serverConnectionHandlerID, data) > data->voiceVolume) || (!isTalk);
			}
			else {
				mute = false;
			}
		} 
		else
		{
			mute = true;
		}			
		LeaveCriticalSection(&serverDataCriticalSection);
	}
	setClientMuteStatus(serverConnectionHandlerID, clientId, mute);	
}


void unmuteAll(uint64 serverConnectionHandlerID)
{
	anyID* ids;
	DWORD error;
	if((error = ts3Functions.getClientList(serverConnectionHandlerID, &ids)) != ERROR_ok)
	{
		log("Error getting all clients from server", error);
		return;
	}	
	
	if((error = ts3Functions.requestUnmuteClients(serverConnectionHandlerID, ids, NULL)) != ERROR_ok)
	{
		log("Can't unmute all clients", error);
	}	
	ts3Functions.freeMemory(ids);
}



std::string getConnectionStatusInfo(bool pipeConnected, bool inGame, bool includeVersion)
{
	uint64 id = ts3Functions.getCurrentServerConnectionHandlerID();
	EnterCriticalSection(&serverDataCriticalSection);
	std::string addon = serverIdToData[id].addon_version;
	LeaveCriticalSection(&serverDataCriticalSection);
	
	std::string result = std::string("[I]Connected[/I] [B]") 
		+ (pipeConnected ? "Y" : "N") + "[/B] [I]Play[/I] [B]" 
		+ (inGame ? "Y" : "N") 
		+ (includeVersion ? std::string("[/B] [I]P:[/I][B]") + PLUGIN_VERSION + "[/B]" : "")
		+ (includeVersion ? std::string("[I] A: [/I][B]") + addon + "[/B]" : "");
	return result;
}

void updateUserStatusInfo(bool pluginEnabled) {		
	if (!isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) return;
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

void setMuteForDeadPlayers(uint64 serverConnectionHandlerID, bool isSeriousModeEnabled)
{
	bool alive = false;
	EnterCriticalSection(&serverDataCriticalSection);
	alive = serverIdToData[serverConnectionHandlerID].alive;
	LeaveCriticalSection(&serverDataCriticalSection);	
	std::vector<anyID> clientsIds = getChannelClients(serverConnectionHandlerID, getCurrentChannel(serverConnectionHandlerID));
	anyID myId = getMyId(serverConnectionHandlerID);
	for (auto it = clientsIds.begin(); it != clientsIds.end(); it++)
	{		
		if (!(*it == myId))
		{			
			if (!hasClientData(serverConnectionHandlerID, *it))
			{
				setClientMuteStatus(serverConnectionHandlerID, (*it), alive && isSeriousModeEnabled); // mute not listed client if you alive, and unmute them if not
			}
		}		
	}
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
	anyID myId = getMyId(serverConnectionHandlerID);
	if (myId == (anyID) -1) return "";	
	if((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, myId, CLIENT_NICKNAME, &bufferForNickname)) != ERROR_ok) {
		log("Error getting client nickname", error, LogLevel_DEBUG);
		return "";
	}
	std::string result = std::string(bufferForNickname);
	ts3Functions.freeMemory(bufferForNickname);
	return result;
}

void onGameEnd(uint64 serverConnectionHandlerID, anyID clientId) 
{
	log("On Game End");
	DWORD error;
	if (notSeriousChannelId != uint64(-1))
	{
		if (getCurrentChannel(serverConnectionHandlerID) != notSeriousChannelId) 
		{
			if ((error = ts3Functions.requestClientMove(serverConnectionHandlerID, clientId, notSeriousChannelId, "", NULL)) != ERROR_ok) {
				log("Can't join back channel", error);
			}
		}
		notSeriousChannelId = uint64(-1);
	}
	unmuteAll(serverConnectionHandlerID);
	EnterCriticalSection(&serverDataCriticalSection);
	serverIdToData[serverConnectionHandlerID].serious_mod_channel_name = "";
	serverIdToData[serverConnectionHandlerID].serious_mod_channel_password = "";
	std::string revertNickname = serverIdToData[serverConnectionHandlerID].myOriginalNickname; 
	serverIdToData[serverConnectionHandlerID].myOriginalNickname = "";
	LeaveCriticalSection(&serverDataCriticalSection);

	if((error = ts3Functions.setClientSelfVariableAsString(serverConnectionHandlerID,  CLIENT_NICKNAME, revertNickname.c_str())) != ERROR_ok) {
		log("Error setting back client nickname", error);				
	}
}

void onGameStart(uint64 serverConnectionHandlerID, anyID clientId)
{
	log("On Respawn");	
	if (isConnected(serverConnectionHandlerID))
	{
		uint64 beforeGameChannelId = getCurrentChannel(serverConnectionHandlerID);		
		uint64* result;
		DWORD error;

		std::string serious_mod_channel_name = "__unknown__";
		std::string serious_mod_channel_password = "__unknown__";
		EnterCriticalSection(&serverDataCriticalSection);
		if (serverIdToData.count(serverConnectionHandlerID)) {
			serious_mod_channel_name = serverIdToData[serverConnectionHandlerID].serious_mod_channel_name;
			serious_mod_channel_password = serverIdToData[serverConnectionHandlerID].serious_mod_channel_password;
		}
		LeaveCriticalSection(&serverDataCriticalSection);

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
					if (!strcmp(serious_mod_channel_name.c_str(), channelName))
					{								
						if ((error = ts3Functions.requestClientMove(serverConnectionHandlerID, clientId, channelId, serious_mod_channel_password.c_str(), NULL)) != ERROR_ok) {
							log("Can't join channel", error);
						} 
						else 
						{
							joined = true;
						}					
					}
					ts3Functions.freeMemory(channelName);
				}
			}
			if (joined) notSeriousChannelId = beforeGameChannelId;
			ts3Functions.freeMemory(result);
		}
	}
}


bool isTrue(std::string& string)
{
	return string == "true";
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
			if (serverIdToData.count(serverConnectionHandlerID))
			{			
				std::string clientNickname(name);
				if (!serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(clientNickname))
				{
					serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname] = new CLIENT_DATA();
				}
				serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname]->clientId = clientId;
			}
			LeaveCriticalSection(&serverDataCriticalSection);

			ts3Functions.freeMemory(name);
		}					
	}
	std::string myNickname = getMyNickname(serverConnectionHandlerID);
	EnterCriticalSection(&serverDataCriticalSection);			
	serverIdToData[serverConnectionHandlerID].myNickname = myNickname;
	LeaveCriticalSection(&serverDataCriticalSection);

}

std::map<std::string, FREQ_SETTINGS> parseFrequencies(std::string string) {
	std::map<std::string, FREQ_SETTINGS> result;
	std::string sub = string.substr(1, string.length() - 2);	
	std::vector<std::string> v = split(sub, ',');
	for (auto i = v.begin(); i != v.end(); i++) 
	{
		std::string xs = *i;
		xs = xs.substr(1, xs.length() - 2);
		std::vector<std::string> parts = split(xs, '|');
		if (parts.size() == 3) {
			FREQ_SETTINGS settings;
			settings.volume = std::atoi(parts[1].c_str());
			settings.stereoMode = std::atoi(parts[2].c_str());
			result[parts[0]] = settings;
		}
	}
	return result;
}

std::string processGameCommand(std::string command)
{	
	DWORD error;
	uint64 currentServerConnectionHandlerID = ts3Functions.getCurrentServerConnectionHandlerID();
	std::vector<std::string> tokens = split(command, '\t'); //may not be used in nickname	
	if (tokens.size() == 2 && tokens[0] == "TS_INFO") 
	{
		if (tokens[1] == "SERVER")
		{
			char* name;
			error = ts3Functions.getServerVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), VIRTUALSERVER_NAME, &name);
			if(error != ERROR_ok) {
				log("Can't get server name", error, LogLevel_ERROR);
				return "ERROR_GETTING_SERVER_NAME";
			} else {
				std::string result(name);
				ts3Functions.freeMemory(name);
				return result;
			}
			
		} 
		else if (tokens[1] == "CHANNEL") 
		{
			return getChannelName(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
		} 
		else if (tokens[1] == "PING")
		{
			return "PONG";
		}
	}	
	else if (tokens.size() == 2 && tokens[0] == "KILLED") 
	{
		std::string nickname = tokens[1];
		EnterCriticalSection(&serverDataCriticalSection);		
		if (serverIdToData.count(currentServerConnectionHandlerID))
		{
			if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(nickname))
			{
				CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];
				if (clientData)
				{
					clientData->dataFrame = INVALID_DATA_FRAME;
				}
			}
		}
		LeaveCriticalSection(&serverDataCriticalSection);
		setMuteForDeadPlayers(currentServerConnectionHandlerID, isSeriousModeEnabled(currentServerConnectionHandlerID, getMyId(currentServerConnectionHandlerID)));
	}
	else if (tokens.size() == 4 && tokens[0] == "VERSION") 
	{
		EnterCriticalSection(&serverDataCriticalSection);				
		serverIdToData[currentServerConnectionHandlerID].addon_version = tokens[1];
		serverIdToData[currentServerConnectionHandlerID].serious_mod_channel_name = tokens[2];
		serverIdToData[currentServerConnectionHandlerID].serious_mod_channel_password = tokens[3];
		serverIdToData[currentServerConnectionHandlerID].currentDataFrame++;
		LeaveCriticalSection(&serverDataCriticalSection);
		return "OK";
	}		
	else if (tokens.size() == 12 && tokens[0] == "POS") 
	{	
		std::string nickname = tokens[1];
		float x = std::stof(tokens[2]);
		float y = std::stof(tokens[3]);
		float z = std::stof(tokens[4]);		
		float viewAngle = std::stof(tokens[5]);
		bool canSpeak = isTrue(tokens[6]);
		bool canUseSWRadio = isTrue(tokens[7]);
		bool canUseLRRadio = isTrue(tokens[8]);
		bool canUseDDRadio = isTrue(tokens[9]);
		std::string vehicleId = tokens[10];
		int terrainInterception = std::stoi(tokens[11]);

		TS3_VECTOR position;
		position.x = x;
		position.y = z; // yes, it is correct
		position.z = y; // yes, it is correct				
		DWORD time = GetTickCount();
		anyID myId = getMyId(currentServerConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection); 
		anyID playerId = anyID(-1);
		bool clientTalkingOnRadio = false;
		if (serverIdToData.count(currentServerConnectionHandlerID))
		{		
			if (nickname == serverIdToData[currentServerConnectionHandlerID].myNickname) 
			{

				float radians = viewAngle * ((float) M_PI / 180.0f);
				TS3_VECTOR look;
				look.x = sin(radians);
				look.z = cos(radians);
				look.y = 0;
				CLIENT_DATA* clientData = NULL;
				if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(nickname))
						clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];

				if (clientData)
				{
					playerId = myId;
					clientData->clientId = myId;
					clientData->clientPosition = position;
					clientData->positionTime = time;
					clientData->canSpeak = canSpeak;
					clientData->canUseSWRadio = canUseSWRadio;
					clientData->canUseLRRadio = canUseLRRadio;
					clientData->canUseDDRadio = canUseDDRadio;
					clientData->vehicleId = vehicleId;
					clientData->terrainInterception = terrainInterception;
					clientData->dataFrame = serverIdToData[currentServerConnectionHandlerID].currentDataFrame;
					clientTalkingOnRadio = (clientData->tangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
				}
				serverIdToData[currentServerConnectionHandlerID].myPosition = position;
				serverIdToData[currentServerConnectionHandlerID].canSpeak = canSpeak;

				LeaveCriticalSection(&serverDataCriticalSection);
				TS3_VECTOR zero;
				zero.x = zero.y = zero.z = 0.0f;
				DWORD error = ts3Functions.systemset3DListenerAttributes(currentServerConnectionHandlerID, &zero, &look, NULL);
				EnterCriticalSection(&serverDataCriticalSection); 
				if(error != ERROR_ok)
				{
					log("Failed to set own 3d position", error);
				}				
			} 
			else 
			{
				if (!serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(nickname))
				{
					LeaveCriticalSection(&serverDataCriticalSection);
					if (isConnected(currentServerConnectionHandlerID)) updateNicknamesList(currentServerConnectionHandlerID);
					EnterCriticalSection(&serverDataCriticalSection);
				}
				if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(nickname))
				{
					CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];
					if (clientData)
					{		
						playerId = clientData->clientId;
						clientData->clientPosition = position;				
						clientData->positionTime = time;
						clientData->canSpeak = canSpeak;
						clientData->canUseSWRadio = canUseSWRadio;
						clientData->canUseLRRadio = canUseLRRadio;
						clientData->canUseDDRadio = canUseDDRadio;						
						clientData->vehicleId = vehicleId;
						clientData->terrainInterception = terrainInterception;
						clientData->dataFrame = serverIdToData[currentServerConnectionHandlerID].currentDataFrame;
						clientTalkingOnRadio = (clientData->tangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
						LeaveCriticalSection(&serverDataCriticalSection);							
						if ((error = ts3Functions.channelset3DAttributes(currentServerConnectionHandlerID, clientData->clientId, &position)) != ERROR_ok)
						{
							log("Can't set client 3D position", error);
						}
						EnterCriticalSection(&serverDataCriticalSection);
					}
				
				}
				LeaveCriticalSection(&serverDataCriticalSection);
				if (isConnected(currentServerConnectionHandlerID)) setGameClientMuteStatus(currentServerConnectionHandlerID, getClientId(currentServerConnectionHandlerID, nickname));
				EnterCriticalSection(&serverDataCriticalSection);
			}	
		}
		LeaveCriticalSection(&serverDataCriticalSection);		
		
		if (playerId != anyID(-1)) {			
			if (isTalking(currentServerConnectionHandlerID, myId, playerId) || clientTalkingOnRadio) {
				return "SPEAKING";
			}			
		}
		return  "NOT_SPEAKING";
	} 
	else if (tokens.size() == 5 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" || tokens[0] == "TANGENT_DD"))
	{
		bool pressed = (tokens[1] == "PRESSED");
		bool longRange = (tokens[0] == "TANGENT_LR");		
		bool diverRadio = (tokens[0] == "TANGENT_DD");
		std::string subtype = tokens[4];

		bool changed = false;		
		EnterCriticalSection(&serverDataCriticalSection);
		if (serverIdToData.count(currentServerConnectionHandlerID))
		{			
			changed = (serverIdToData[currentServerConnectionHandlerID].tangentPressed != pressed);
			serverIdToData[currentServerConnectionHandlerID].tangentPressed = pressed;			
			if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(serverIdToData[currentServerConnectionHandlerID].myNickname))
			{
				CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[serverIdToData[currentServerConnectionHandlerID].myNickname];
				if (longRange) clientData->canUseLRRadio = true;
				else if (diverRadio) clientData->canUseDDRadio = true;
				else clientData->canUseSWRadio = true;
				clientData->subtype = subtype;
			}
		}
		LeaveCriticalSection(&serverDataCriticalSection);		
		if (changed)
		{			
			if (pressed)
			{
				if (subtype == "digital_lr") playWavFile("radio-sounds/lr/local_start", false, 0);
				else if (subtype == "dd") playWavFile("radio-sounds/dd/local_start", false, 0);
				else if (subtype == "digital") playWavFile("radio-sounds/sw/local_start", false, 0);
				else if (subtype == "airborne") playWavFile("radio-sounds/ab/local_start", false, 0);

				vadEnabled = hlp_checkVad();
				if (vadEnabled) hlp_disableVad();
			} 
			else
			{
				if (vadEnabled)	hlp_enableVad();	

				if (subtype == "digital_lr") playWavFile("radio-sounds/lr/local_end", false, 0);
				else if (subtype == "dd") playWavFile("radio-sounds/dd/local_end", false, 0);
				else if (subtype == "digital") playWavFile("radio-sounds/sw/local_end", false, 0);
				else if (subtype == "airborne") playWavFile("radio-sounds/ab/local_end", false, 0);
			}
			// broadcast info about tangent pressed over all client						
			std::string commandToBroadcast = command + "\t" + serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].myNickname;
			log_string(commandToBroadcast, LogLevel_DEVEL);			

			if((error = ts3Functions.setClientSelfVariableAsInt(currentServerConnectionHandlerID, CLIENT_INPUT_DEACTIVATED, pressed || vadEnabled ? INPUT_ACTIVE : INPUT_DEACTIVATED)) != ERROR_ok) {
				log("Can't active talking by tangent", error);
			}
			DWORD error = ts3Functions.flushClientSelfUpdates(currentServerConnectionHandlerID, NULL); 			
			if(error != ERROR_ok && error != ERROR_ok_no_update) {
				log("Can't flush self updates", error);
			}
			ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, commandToBroadcast.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
		}
		return "OK";
	} 	
	else if (tokens.size() == 10 && tokens[0] == "FREQ")
	{				
		EnterCriticalSection(&serverDataCriticalSection);	
		if (serverIdToData.count(currentServerConnectionHandlerID))
		{		
			serverIdToData[currentServerConnectionHandlerID].mySwFrequencies = parseFrequencies(tokens[1]);
			serverIdToData[currentServerConnectionHandlerID].myLrFrequencies = parseFrequencies(tokens[2]);
			serverIdToData[currentServerConnectionHandlerID].myDdFrequency = tokens[3];
			serverIdToData[currentServerConnectionHandlerID].alive = tokens[4] == "true";		
			serverIdToData[currentServerConnectionHandlerID].myVoiceVolume = std::atoi(tokens[5].c_str());
			serverIdToData[currentServerConnectionHandlerID].ddVolumeLevel = (int) std::atof(tokens[6].c_str());
			serverIdToData[currentServerConnectionHandlerID].wavesLevel = (float) std::atof(tokens[8].c_str());
			serverIdToData[currentServerConnectionHandlerID].terrainIntersectionCoefficient = (float) std::atof(tokens[9].c_str());
		}
		std::string nickname =  tokens[7];
		LeaveCriticalSection(&serverDataCriticalSection);		
		std::string myNickname = getMyNickname(currentServerConnectionHandlerID);
		if (myNickname != nickname && myNickname.length() > 0 && (nickname != "Error: No unit" && nickname != "Error: No vehicle"))
		{
			DWORD error;			
			if((error = ts3Functions.setClientSelfVariableAsString(currentServerConnectionHandlerID,  CLIENT_NICKNAME, nickname.c_str())) != ERROR_ok) {
				log("Error setting client nickname", error);				
			} else {
				EnterCriticalSection(&serverDataCriticalSection);
				serverIdToData[currentServerConnectionHandlerID].myOriginalNickname = myNickname;
				LeaveCriticalSection(&serverDataCriticalSection);
			}
		}
		return "OK";
	}
	return "FAIL";
}

void removeExpiredPositions(uint64 serverConnectionHandlerID)
{
	DWORD time = GetTickCount();
	std::vector<std::string> toRemove;

	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnectionHandlerID))
	{	
		for (auto it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin(); it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++)
		{
			if (it->second && (time - it->second->positionTime > (MILLIS_TO_EXPIRE * 5) || (abs(serverIdToData[serverConnectionHandlerID].currentDataFrame - it->second->dataFrame) > 1)))
			{			
				toRemove.push_back(it->first);
			}
		}
		for (auto it = toRemove.begin(); it != toRemove.end(); it++)
		{
			CLIENT_DATA* data = serverIdToData[serverConnectionHandlerID].nicknameToClientData[*it];
			serverIdToData[serverConnectionHandlerID].nicknameToClientData.erase(*it);
			log_string(std::string("Expire position of ") + *it + " time:" + std::to_string(time - data->positionTime), LogLevel_DEBUG);
			delete data;			
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);

}

volatile DWORD lastInGame = GetTickCount();
volatile DWORD lastCheckForExpire = GetTickCount();		
volatile DWORD lastInfoUpdate = GetTickCount();

DWORD WINAPI UpdateThread( LPVOID lpParam ) 
{
	if (isUpdateAvaible())
	{
		MessageBox(NULL, L"New version of Task Force Arrowhead Radio is available. Check radio.task-force.ru/en", L"Task Force Arrowhead Radio Update", MB_OK);
	}
	return 0;
}

DWORD WINAPI ServiceThread( LPVOID lpParam )
{			
	while (!exitThread)
	{
		if (GetTickCount() - lastCheckForExpire > MILLIS_TO_EXPIRE)
		{			
			bool isSerious = isSeriousModeEnabled(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
			removeExpiredPositions(ts3Functions.getCurrentServerConnectionHandlerID());
			if (isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) 
			{
				if (inGame) setMuteForDeadPlayers(ts3Functions.getCurrentServerConnectionHandlerID(), isSerious);
				updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());
			}						
			lastCheckForExpire = GetTickCount();
		}
		if (GetTickCount() - lastInGame > MILLIS_TO_EXPIRE)
		{
			if (!isOtherRadioPluginEnabled(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID())))
			{
				centerAll(ts3Functions.getCurrentServerConnectionHandlerID());			
				unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
			}			
			InterlockedExchange(&lastInGame, GetTickCount());
			if (inGame) 
			{
				playWavFile("radio-sounds/off", 0, false);			
				EnterCriticalSection(&serverDataCriticalSection);				
				serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].alive = false;
				serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].currentDataFrame = INVALID_DATA_FRAME;
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
		Sleep(100);
	}

	return NULL;
}

#define FAILS_TO_SLEEP 1000
DWORD WINAPI PipeThread( LPVOID lpParam )
{	
	HANDLE pipe = INVALID_HANDLE_VALUE;	
	
	DWORD sleep = FAILS_TO_SLEEP;
	while (!exitThread)
	{
		if (pipe == INVALID_HANDLE_VALUE) pipe = openPipe();		

		DWORD numBytesRead = 0;
		DWORD numBytesAvail = 0;
		
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
					sleep = FAILS_TO_SLEEP;
					std::string command = std::string(buffer);				
					if (!pipeConnected)
					{
						pipeConnected = true;						
					}
					std::string result = processGameCommand(command);
					if (!startWith("VERSION", command))
					{
						InterlockedExchange(&lastInGame, GetTickCount());
						EnterCriticalSection(&serverDataCriticalSection);
						std::string channelName = serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].serious_mod_channel_name;
						LeaveCriticalSection(&serverDataCriticalSection);
						if (!inGame && channelName.length() > 0)
						{
							playWavFile("radio-sounds/on", false, 0);
							inGame = true;							
							onGameStart(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
							EnterCriticalSection(&serverDataCriticalSection);
							serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].currentDataFrame = 0;
							LeaveCriticalSection(&serverDataCriticalSection);
						}	
					}
					const char* output = result.c_str();
					DWORD written = 0;
					if (WriteFile(pipe, output, (DWORD) result.length() + 1, &written, NULL)) {
						log_string("Info to ARMA send", LogLevel_DEBUG);
					} else {
						log_string("Can't send info to ARMA", LogLevel_ERROR);
					}
				} else {
					if (pipeConnected) 
					{
						pipeConnected = false;						
					}					
					Sleep(1000);
					pipe = openPipe();					
				}		
			} else sleep--;			
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
 		if (!sleep) 
 		{
 			Sleep(1);
			sleep = FAILS_TO_SLEEP;
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

#define PLUGIN_API_VERSION 20

#define INFODATA_BUFSIZE 512


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
	if (isConnected(ts3Functions.getCurrentServerConnectionHandlerID()))
	{
		centerAll(ts3Functions.getCurrentServerConnectionHandlerID());
		updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());		
	}

	for (int q = 0; q < MAX_CHANNELS; q++)
	{
		floatsSample[q] = new float[1];
	}
	thread = CreateThread(NULL, 0, PipeThread, NULL, 0, NULL);		
	threadService = CreateThread(NULL, 0, ServiceThread, NULL, 0, NULL);		
	CreateThread(NULL, 0, UpdateThread, NULL, 0, NULL);

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

	result = GetExitCodeThread(threadService, &exitCode);
	if (!result || exitCode == STILL_ACTIVE) 
	{
		log("service thread not terminated", LogLevel_CRITICAL);
	}

	EnterCriticalSection(&serverDataCriticalSection);
	serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].alive = false;
	LeaveCriticalSection(&serverDataCriticalSection);
	pipeConnected = inGame = false;	
	updateUserStatusInfo(false);
	thread = threadService = INVALID_HANDLE_VALUE;
	centerAll(ts3Functions.getCurrentServerConnectionHandlerID());
	unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
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


template<class T>
void processRadioEffect(short* samples, int channels, int sampleCount, float gain, T* effect, int stereoMode)
{
	int startChannel = 0;
	int endChannel = channels;
	if (stereoMode == 1) 
	{			
		startChannel = 0;
		endChannel = 1;
		gain *= 1.5f;
	} 
	else if (stereoMode == 2) 
	{
		startChannel = 1;
		endChannel = 2;
		gain *= 1.5f;
	}
	for (int i = 0; i < sampleCount * channels; i+= channels)
	{			
		// prepare mono for radio						
		long long no3D = 0;				
		for (int j = 0; j < channels; j++)
		{
			no3D += samples[i + j];
		}
		
		short to_process = (short) (no3D / channels);		
		float buffer  = ((float) to_process / (float) SHRT_MAX) * gain;
		
		EnterCriticalSection(&serverDataCriticalSection);				
		effect->process(&buffer, 1);		
		LeaveCriticalSection(&serverDataCriticalSection);								

		// put mixed output to stream			
		for (int j = 0; j < channels; j++) samples[i + j] = 0;		

		for (int j = startChannel; j < endChannel; j++)
		{
			float sample = buffer;
			short newValue;
			if (sample > 1.0) newValue = SHRT_MAX;
			else if (sample < -1.0) newValue = SHRT_MIN;
			else newValue =  (short) (sample * (SHRT_MAX - 1));		
			samples[i + j] = newValue;
		}	
	}
}

template<class T>
void processFilterStereo(short * samples, int channels, int sampleCount, float gain, T* filter)
{			
	for (int i = 0; i < sampleCount * channels; i+= channels)
	{	
		// all channels mixed
		float mix[MAX_CHANNELS];
		for (int j = 0; j < MAX_CHANNELS; j++) mix[j] = 0.0;
			
		// prepare mono for radio
		short to_process[MAX_CHANNELS];
		for (int j = 0; j < MAX_CHANNELS; j++) to_process[j] = 0;

		for (int j = 0; j < channels; j++)
		{
			to_process[j] = samples[i + j];
		}			
				
		// process radio filter
		EnterCriticalSection(&serverDataCriticalSection);
		for (int j = 0; j < channels; j++)
		{			
			floatsSample[j][0] = ((float) to_process[j] / (float) SHRT_MAX);			
		}
		// skip other channels
		for (int j = channels; j < MAX_CHANNELS; j++)
		{
			floatsSample[j][0] = 0.0;
		}		
		filter->process<float>(1, floatsSample);			
		for (int j = 0; j < channels; j++) 
		{			
			mix[j] = floatsSample[j][0] * gain;				
		}
		LeaveCriticalSection(&serverDataCriticalSection);								
			
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

void stereoToMonoDSP(short * samples, int channels, int sampleCount, unsigned int channelFillMask)
{
	// 3d sound to mono
	for (int i = 0; i < sampleCount * channels; i+= channels)
	{
		long long no3D = 0;
		int mask = 1;
		int realChannels = 0;
		for (int j = 0; j < channels; j++)
		{
			if (channelFillMask & mask)
			{
				no3D += samples[i + j];
				realChannels++;
			}			
			mask <<= 1;
		}
		mask = 1;
		for (int j = 0; j < channels; j++)
		{
			if (channelFillMask & mask)
			{
				samples[i + j] = (short) (no3D / realChannels);
				mask <<= 1;
			}			
		}		
	}
}

void ts3plugin_onEditPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels) {	
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
		result = startWith(shouldStartWith, clientStatus);		
		ts3Functions.freeMemory(clientInfo);
	}
	DWORD currentTime = GetTickCount();
	EnterCriticalSection(&serverDataCriticalSection);
	CLIENT_DATA* data = getClientData(serverConnectionHandlerID, clientID);
	if (data) 
	{
		if (result) 
		{			
			data->pluginEnabledCheck = currentTime;
		} else {
			if (currentTime - data->pluginEnabledCheck < 10000) 
			{
				result = data->pluginEnabled;
			}
		}
		data->pluginEnabled = result;
	}
	LeaveCriticalSection(&serverDataCriticalSection);

	return result;
}

short* allocatePool(int sampleCount, int channels, short* samples)
{
	short* result = new short[sampleCount * channels];
	memcpy(result, samples, sampleCount * channels * sizeof(short));
	return result;
}

void mix(short* to, short* from, int sampleCount, int channels)
{
	for (int q = 0; q < sampleCount * channels; q++)
	{
		to[q] += from[q];
	}
}

float volumeMultiplifier(float volumeValue)
{
	float normalized = (volumeValue + 1) / 10.0f;
	return pow(normalized, 4);
}

std::pair<std::string, bool> getVehicleDescriptor(std::string vechicleId) {
	std::pair<std::string, bool> result;
	result.first == ""; // hear vehicle
	result.second = false; // hear 

	if (vechicleId == "no" || (vechicleId.find("_turnout") != std::string::npos)) {
		result.second = true; 
	}
	if (vechicleId.find("_turnout") != std::string::npos) {
		result.first = vechicleId.substr(0, vechicleId.find("_turnout"));
	} else {
		result.first = vechicleId;
	}
	return result;
}

void processCompressor(chunkware_simple::SimpleComp* compressor, short* samples, int channels, int sampleCount)
{
	if (channels >= 2) 
	{
		for (int q = 0; q < sampleCount; q++) {
			double left = samples[channels * q];
			double right = samples[channels * q + 1];
			compressor->process(left, right);
			samples[channels * q] = (short) left;
			samples[channels * q + 1] = (short) right;
		}
	}
}

void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {	
	static DWORD last_no_info;	
 	EnterCriticalSection(&serverDataCriticalSection);
	bool alive = serverIdToData[serverConnectionHandlerID].alive;
	bool canSpeak = serverIdToData[serverConnectionHandlerID].canSpeak;
	anyID myId = getMyId(serverConnectionHandlerID);
	LeaveCriticalSection(&serverDataCriticalSection);
	if (hasClientData(serverConnectionHandlerID, clientID) && hasClientData(serverConnectionHandlerID, myId) && isPluginEnabledForUser(serverConnectionHandlerID, clientID))	
	{				
		if (isSeriousModeEnabled(serverConnectionHandlerID, clientID) && !alive)
		{
			applyGain(samples, channels, sampleCount, 0.0f);
		}
		else		
		{
			CLIENT_DATA* data = getClientData(serverConnectionHandlerID, clientID);		
			CLIENT_DATA* myData = getClientData(serverConnectionHandlerID, myId);
			if (data && myData) 
			{		
				EnterCriticalSection(&serverDataCriticalSection);								
				LISTED_INFO listed_info = isOverRadio(serverConnectionHandlerID, data, myData, false, false, false);								
				bool shouldPlayerHear = (data->canSpeak && canSpeak);
				
				
				std::pair<std::string, bool> myVehicleDesriptor = getVehicleDescriptor(myData->vehicleId);
				std::pair<std::string, bool> hisVehicleDesriptor = getVehicleDescriptor(data->vehicleId);

				bool vehicleCheck = (myVehicleDesriptor.first == hisVehicleDesriptor.first) || (myVehicleDesriptor.second && hisVehicleDesriptor.second);
				float d = distanceFromClient(serverConnectionHandlerID, data);

				if (listed_info.over != LISTEN_TO_NONE)
				{					
					float radioDistance = effectiveDistance(serverConnectionHandlerID, data, myData);
					short* sw_buffer = NULL;
					if (data->subtype == "digital")
					{
						sw_buffer = allocatePool(sampleCount, channels, samples);
						float volumeLevel = volumeMultiplifier((float) listed_info.volume);
						processCompressor(&data->compressor, sw_buffer, channels, sampleCount);
						data->swEffect.setErrorLeveL(effectErrorFromDistance(listed_info.over, radioDistance, serverConnectionHandlerID, data));
						processRadioEffect(sw_buffer, channels, sampleCount, volumeLevel * 0.35f, &data->swEffect, listed_info.stereoMode);
					}
					short* lr_buffer = NULL;
					if (data->subtype == "digital_lr" || data->subtype == "airborne")
					{
						lr_buffer = allocatePool(sampleCount, channels, samples);
						float volumeLevel = volumeMultiplifier((float) listed_info.volume);						
						processCompressor(&data->compressor, lr_buffer, channels, sampleCount);
						data->lrEffect.setErrorLeveL(effectErrorFromDistance(listed_info.over, radioDistance, serverConnectionHandlerID, data));
						processRadioEffect(lr_buffer, channels, sampleCount, volumeLevel * 0.35f, &data->lrEffect, listed_info.stereoMode);
					}
					short* dd_buffer = NULL;
					if (data->subtype == "dd")
					{
						dd_buffer = allocatePool(sampleCount, channels, samples);
						float volumeLevel = volumeMultiplifier((float) serverIdToData[serverConnectionHandlerID].ddVolumeLevel);
						processCompressor(&data->compressor, dd_buffer, channels, sampleCount);
						data->ddEffect.setErrorLeveL(effectErrorFromDistance(listed_info.over, radioDistance, serverConnectionHandlerID, data));
						processRadioEffect(dd_buffer, channels, sampleCount, volumeLevel * 0.4f, &data->ddEffect, listed_info.stereoMode);
					}							
					if (!shouldPlayerHear && vehicleCheck)
					{						
						processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear) * CANT_SPEAK_GAIN, &(data->filterCantSpeak));
					}
					applyGain(samples, channels, sampleCount, vehicleCheck ? volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear) : 0.0f);
					if (sw_buffer)
					{
						mix(samples, sw_buffer, sampleCount, channels);
						delete sw_buffer;
					}
					if (lr_buffer)
					{
						mix(samples, lr_buffer, sampleCount, channels);
						delete lr_buffer;
					}
					if (dd_buffer)
					{
						mix(samples, dd_buffer, sampleCount, channels);
						delete dd_buffer;
					}					
				} 
				else 
				{										
					if (shouldPlayerHear)
						applyGain(samples, channels, sampleCount, vehicleCheck ? volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear) : 0.0f);
					else
					{						
						processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear) * CANT_SPEAK_GAIN, &(data->filterCantSpeak));
					}						
				}
				LeaveCriticalSection(&serverDataCriticalSection);
			}
		}
	}
	else 
	{		
		if (!isOtherRadioPluginEnabled(serverConnectionHandlerID, clientID))
		{		
			if (!isSeriousModeEnabled(serverConnectionHandlerID, clientID)) 
			{
				stereoToMonoDSP(samples, channels, sampleCount, *channelFillMask); // mono for clients without information about positions
			}
			else 
			{
				if (!alive & inGame & isPluginEnabledForUser(serverConnectionHandlerID, clientID))
					stereoToMonoDSP(samples, channels, sampleCount, *channelFillMask); // dead player hears other dead players in serious mode			
				else 
					applyGain(samples, channels, sampleCount, 0.0f); // alive player hears only alive players in serious mode
			}
			if (GetTickCount() - last_no_info > MILLIS_TO_EXPIRE) 
			{
				std::string nickname = getClientNickname(serverConnectionHandlerID, clientID);
				if (!hasClientData(serverConnectionHandlerID, clientID))
					log_string(std::string("No info about ") + std::to_string((long long)clientID) + " " + nickname, LogLevel_DEBUG);
				if (!isPluginEnabledForUser(serverConnectionHandlerID, clientID))
					log_string(std::string("No plugin enabled for ") + std::to_string((long long)clientID) + " " + nickname, LogLevel_DEBUG);
				last_no_info = GetTickCount();
			}
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
	if (flag == CLIENT_FLAG_TALKING && inGame)
	{
		
		std::string one = "1";
		bool start = (one == newValue);
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
		std::string myNickname = getMyNickname(serverId);
		EnterCriticalSection(&serverDataCriticalSection);
		std::string command = "VOLUME\t" + myNickname + "\t" + std::to_string(serverIdToData[serverId].myVoiceVolume) + "\t" + (start ? "true" : "false");
		LeaveCriticalSection(&serverDataCriticalSection);
		ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, command.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
	}
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
	DWORD currentTime = GetTickCount();
	std::vector<std::string> tokens = split(command, '\t'); // may not be used in nickname
	uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
	DWORD time =  GetTickCount();
	if (tokens.size() == 6 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" ||  tokens[0] == "TANGENT_DD"))
	{
  		bool pressed = (tokens[1] == "PRESSED");
		bool longRange = (tokens[0] == "TANGENT_LR");
		bool diverRadio = (tokens[0] == "TANGENT_DD");
		bool shortRange = !longRange && !diverRadio;
		std::string subtype = tokens[4];
		int range = std::atoi(tokens[3].c_str());
		std::string nickname = tokens[5];
		std::string frequency = tokens[2];		

		boolean playPressed = false;
		boolean playReleased = false;
		anyID myId = getMyId(serverId);		
		EnterCriticalSection(&serverDataCriticalSection);
		bool alive = serverIdToData[serverId].alive;		

		if (serverIdToData.count(serverId) && serverIdToData[serverId].nicknameToClientData.count(nickname))
		{		
			CLIENT_DATA* clientData = serverIdToData[serverId].nicknameToClientData[nickname];
			if (clientData)
			{	
				clientData->positionTime = time;
				clientData->pluginEnabled = true;
				clientData->pluginEnabledCheck = currentTime;				
				clientData->subtype = subtype;

				if (longRange) clientData->canUseLRRadio = true;
				else if (diverRadio) clientData->canUseDDRadio = true;
				else clientData->canUseSWRadio = true;

				TS3_VECTOR myPosition = serverIdToData[serverId].myPosition;						
				if (nickname != serverIdToData[serverId].myNickname) // ignore command from yourself
				{					
					log_string(std::string("REMOTE COMMAND ") +  command, LogLevel_DEVEL);
					if ((clientData->tangentOverType != LISTEN_TO_NONE) != pressed)
					{
						playPressed = pressed;
						playReleased = !pressed;
					}					
					if (pressed)
					{
						if (longRange) clientData->tangentOverType = LISTEN_TO_LR;
						else if (diverRadio) clientData->tangentOverType = LISTEN_TO_DD;
						else clientData->tangentOverType = LISTEN_TO_SW;						
					}
					else
					{
						clientData->tangentOverType = LISTEN_TO_NONE;
					}					
					clientData->frequency = frequency;					
					clientData->range = range;

					anyID clientId = clientData->clientId;
					LISTED_INFO listedInfo = isOverRadio(serverId, clientData, getClientData(serverId, myId), !longRange && !diverRadio, longRange, diverRadio);
					LeaveCriticalSection(&serverDataCriticalSection);
					setGameClientMuteStatus(serverId, clientId);
					if (alive && listedInfo.on != LISTED_ON_NONE) {
						if (subtype == "digital")
						{
							if (playPressed) playWavFile("radio-sounds/sw/remote_start", true, listedInfo.volume + 1);
							if (playReleased) playWavFile("radio-sounds/sw/remote_end", true, listedInfo.volume + 1);
						}
						if (subtype == "digital_lr")
						{
							if (playPressed) playWavFile("radio-sounds/lr/remote_start", true, listedInfo.volume + 1);
							if (playReleased) playWavFile("radio-sounds/lr/remote_end", true, listedInfo.volume + 1);
						}
						if (subtype == "digital_dd")
						{
							if (playPressed) playWavFile("radio-sounds/dd/remote_start", true, listedInfo.volume + 1);
							if (playReleased) playWavFile("radio-sounds/dd/remote_end", true, listedInfo.volume + 1);
						}
						if (subtype == "airborne")
						{
							if (playPressed) playWavFile("radio-sounds/ab/remote_start", true, listedInfo.volume + 1);
							if (playReleased) playWavFile("radio-sounds/ab/remote_end", true, listedInfo.volume + 1);
						}
					}
					EnterCriticalSection(&serverDataCriticalSection);
					if (playReleased && alive)
					{
						clientData->resetPersonalRadioEffect();
						clientData->resetLongRangeRadioEffect();
						clientData->resetUnderwaterRadioEffect();
					}

				}
				else 
				{
					log_string(std::string("MY COMMAND ") +  command, LogLevel_DEVEL);
				}												
			}
			else 
			{
				log_string(std::string("PLUGIN COMMAND, BUT NO CLIENT DATA ") +  nickname);
			}
		}
		else 
		{
			log_string(std::string("PLUGIN FROM UNKNOWN NICKNAME ") +  nickname);
		}
		LeaveCriticalSection(&serverDataCriticalSection);
	}
	else if (tokens.size() == 4 && tokens[0] == "VOLUME")
	{			
		EnterCriticalSection(&serverDataCriticalSection);
		std::string nickname = tokens[1];
		std::string volume = tokens[2];
		bool start = isTrue(tokens[3]);
		bool myCommand = (nickname == serverIdToData[serverId].myNickname);
		if (serverIdToData.count(serverId) && serverIdToData[serverId].nicknameToClientData.count(nickname) && serverIdToData[serverId].nicknameToClientData[nickname]) 
		{
			serverIdToData[serverId].nicknameToClientData[nickname]->voiceVolume = std::stoi(volume.c_str());
			serverIdToData[serverId].nicknameToClientData[nickname]->pluginEnabled = true;
			serverIdToData[serverId].nicknameToClientData[nickname]->pluginEnabledCheck = currentTime;
			serverIdToData[serverId].nicknameToClientData[nickname]->clientTalkingNow = start;
			LeaveCriticalSection(&serverDataCriticalSection);
			if (!myCommand) 
			{
				setGameClientMuteStatus(serverId, serverIdToData[serverId].nicknameToClientData[nickname]->clientId);
			}
			EnterCriticalSection(&serverDataCriticalSection);
		}
		LeaveCriticalSection(&serverDataCriticalSection);		
	}
	else 
	{
		log_string(std::string("UNKNOWN PLUGIN COMMAND ") +  command);
	}
}

void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
	log_string(std::string("ON PLUGIN COMMAND ") +  pluginName + " " + pluginCommand, LogLevel_DEVEL);
	if(serverConnectionHandlerID == ts3Functions.getCurrentServerConnectionHandlerID())
	{
		if((strcmp(pluginName, PLUGIN_NAME) == 0) || (strcmp(pluginName, PLUGIN_NAME_x64) == 0) || (strcmp(pluginName, PLUGIN_NAME_x32) == 0))
		{			
			processPluginCommand(std::string(pluginCommand));
		}
		else
		{
			log("Plugin command event failure", LogLevel_ERROR);			
		}
	} 
	else 
	{
		log("Plugin command unknown ID", LogLevel_ERROR);			
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
