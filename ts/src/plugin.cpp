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
#include <math.h>
#include <iostream>
#include <sstream>
#include <map>
#include <vector>
#include <algorithm>
#include "public_errors.h"
#include "public_errors_rare.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"
#include "plugin.h"
#include <DspFilters/Butterworth.h>
#include "sqlite3/sqlite3.h"



#include "RadioEffect.hpp"


#include "clientData.hpp"
#include "serverData.hpp"
#include "task_force_radio.hpp"
#include "common.hpp"
#include "pipe_handler.hpp"
#include "helpers.hpp"
#include "PlaybackHandler.hpp"
#include "Logger.hpp"
#include "SharedMemoryHandler.hpp"
#include "Teamspeak.hpp"


enum LISTED_ON {
	LISTED_ON_SW,
	LISTED_ON_LR,
	LISTED_ON_DD, //#diverRadio
	LISTED_ON_NONE,
	LISTED_ON_GROUND
};

struct LISTED_INFO {
	OVER_RADIO_TYPE over;//What radiotype the Sender is using
	LISTED_ON on;//What radiotype we are receiving on
	int volume;
	stereoMode stereoMode;
	std::string radio_id;
	Position3D pos;
	float waveZ;
	std::pair<std::string, float> vehicle;//Vehiclename and isolation
};
//#TODO remove all these global variables!
#define PATH_BUFSIZE 512
char pluginPath[PATH_BUFSIZE];

std::thread threadPipeHandle;
std::thread threadService;

volatile bool exitThread = FALSE;
volatile bool pipeConnected = false;

volatile bool pttDelay = false;
volatile long pttDelayMs = 0;

volatile uint64 notSeriousChannelId = uint64(-1);
volatile bool vadEnabled = false;

CriticalSectionLock tangentCriticalSection;

void log_string(std::string message, LogLevel level) {
	Logger::log(LoggerTypes::teamspeakClientlog, message, level);//Default loglevel is Info
}

void logdeprecate(char* message, DWORD errorCode, LogLevel level) {
	Teamspeak::log(message, errorCode, level);
}

#include <chrono>

bool isSeriousModeEnabled(uint64 serverConnectionHandlerID, anyID clientId) {
	std::string	serious_mod_channel_name = TFAR::config.get<std::string>(Setting::serious_channelName);
	return (serious_mod_channel_name != "") && Teamspeak::isInChannel(serverConnectionHandlerID, clientId, serious_mod_channel_name.c_str());
}

float distanceForDiverRadio(float distance, uint64 serverConnectionHandlerID) {
	float wavesLevel;
	wavesLevel = TFAR::getInstance().m_gameData.wavesLevel; //#TODO Setting
	return DD_MIN_DISTANCE + (DD_MAX_DISTANCE - DD_MIN_DISTANCE) * (1.0f - wavesLevel);
}

float effectErrorFromDistance(OVER_RADIO_TYPE radioType, float distance, uint64 serverConnectionHandlerID, std::shared_ptr<clientData>& data) {
	float maxD = 0.0f;
	switch (radioType) {
		case LISTEN_TO_SW: maxD = static_cast<float>(data->range); break;
		case LISTEN_TO_DD: maxD = distanceForDiverRadio(distance, serverConnectionHandlerID); break;
		case LISTEN_TO_LR: maxD = static_cast<float>(data->range);
		default: break;
	};
	return distance / maxD;
}

float effectiveDistance(uint64 serverConnectionHandlerID, std::shared_ptr<clientData>& data) {

	auto serverDirectory = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!serverDirectory) return 0.f;
	auto myClientData = serverDirectory->myClientData;
	if (!myClientData) return 0.f;

	float d = myClientData->getClientPosition().distanceTo(data->getClientPosition());
	// (bob distance player) + (bob call TFAR_fnc_calcTerrainInterception) * 7 + (bob call TFAR_fnc_calcTerrainInterception) * 7 * ((bob distance player) / 2000.0)
	float result = d +
		+(data->terrainInterception * TFAR::getInstance().m_gameData.terrainIntersectionCoefficient)
		+ (data->terrainInterception * TFAR::getInstance().m_gameData.terrainIntersectionCoefficient * d / 2000.0f);
	result *= TFAR::getInstance().m_gameData.receivingDistanceMultiplicator;
	return result;
}

LISTED_INFO isOverLocalRadio(uint64 serverConnectionHandlerID, std::shared_ptr<clientData>& senderData, std::shared_ptr<clientData>& myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent) {
	LISTED_INFO result;
	result.over = LISTEN_TO_NONE;
	result.volume = 0;
	result.on = LISTED_ON_NONE;
	result.waveZ = 1.0f;
	if (senderData == NULL || myData == NULL) return result;

	Position3D myPosition = myData->getClientPosition();
	Position3D clientPosition = senderData->getClientPosition();
	std::string senderFrequency = senderData->getCurrentTransmittingFrequency();

	result.radio_id = "local_radio";
	result.vehicle = helpers::getVehicleDescriptor(myData->getVehicleId());

	//Sender is sending on a Frequency we are listening to on our LR Radio
	bool senderOnLRFrequency = TFAR::getInstance().m_gameData.myLrFrequencies.count(senderFrequency) != 0;
	//Sender is sending on a Frequency we are listening to on our SW Radio
	bool senderOnSWFrequency = TFAR::getInstance().m_gameData.mySwFrequencies.count(senderFrequency) != 0;

	//Receive DD->DD
	if ((senderData->currentTransmittingTangentOverType == LISTEN_TO_DD || ignoreDdTangent)	 //#diverRadio
		&& (TFAR::getInstance().m_gameData.myDdFrequency == senderFrequency)) {
		float dUnderWater = myPosition.distanceTo(clientPosition);
		if (senderData->canUseDDRadio && myData->canUseDDRadio && dUnderWater < distanceForDiverRadio(dUnderWater, serverConnectionHandlerID)) {
			result.over = LISTEN_TO_DD;
			result.on = LISTED_ON_DD;
			result.volume = TFAR::getInstance().m_gameData.ddVolumeLevel;
			result.stereoMode = stereoMode::stereo;
		}
	}

	float effectiveDist = effectiveDistance(serverConnectionHandlerID, senderData);
	/*
	DD is handling effectiveDistance differently so we couldnt do this before
	But now all other types are handling effectiveDist equally
	so we can just skip all other checks if distance is higher than radio range
	*/

	if (effectiveDist > senderData->range)
		return result;

	//If we didn't find anything result.on has to be LISTED_ON_NONE so we can set result.over
	//even if we won't find a valid path on the receiver side

	if ((senderData->currentTransmittingTangentOverType == LISTEN_TO_SW || ignoreSwTangent) && senderData->canUseSWRadio) {//Sending from SW
		result.over = LISTEN_TO_SW;
	} else if ((senderData->currentTransmittingTangentOverType == LISTEN_TO_LR || ignoreLrTangent) && senderData->canUseLRRadio) {//Sending from LR
		result.over = LISTEN_TO_LR;
	} else {
		//He isn't actually sending on anything... 
		return result;
	}

	if (senderOnLRFrequency && myData->canUseLRRadio) {//to our LR
		auto &frequencyInfo = TFAR::getInstance().m_gameData.myLrFrequencies[senderFrequency];
		if (!TFAR::config.get<bool>(Setting::full_duplex) &&
			frequencyInfo.radioClassname.compare(TFAR::getInstance().m_gameData.currentTransmittingRadio)) {
			return result;
		}
		result.on = LISTED_ON_LR;
		result.volume = frequencyInfo.volume;
		result.stereoMode = frequencyInfo.stereoMode;
	} else if (senderOnSWFrequency && myData->canUseSWRadio) {//to our SW
		auto &frequencyInfo = TFAR::getInstance().m_gameData.mySwFrequencies[senderFrequency];
		if (!TFAR::config.get<bool>(Setting::full_duplex) &&
			frequencyInfo.radioClassname.compare(TFAR::getInstance().m_gameData.currentTransmittingRadio)) {
			return result;
		}
		result.on = LISTED_ON_SW;
		result.volume = frequencyInfo.volume;
		result.stereoMode = frequencyInfo.stereoMode;
	}
	return result;
}

//#TODO move into clientData
std::vector<LISTED_INFO> isOverRadio(TSServerID serverConnectionHandlerID, std::shared_ptr<clientData>& senderData, std::shared_ptr<clientData>& myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent) {
	std::vector<LISTED_INFO> result;
	if (!senderData || !myData) return result;
	//check if we receive him over a radio we have on us
	if (senderData->clientId != myData->clientId) {
		LISTED_INFO local = isOverLocalRadio(serverConnectionHandlerID, senderData, myData, ignoreSwTangent, ignoreLrTangent, ignoreDdTangent);
		if (local.on != LISTED_ON_NONE && local.over != LISTEN_TO_NONE) {
			result.push_back(local);
		}
	}

	float effectiveDistance_ = effectiveDistance(serverConnectionHandlerID, senderData);
	const std::string senderNickname = senderData->getNickname();
	//check if we receive him over a radio laying on ground
	if (effectiveDistance_ > senderData->range)//does his range reach to us?
		return result;	 //His distance > range

	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);

	if (
		(senderData->canUseSWRadio && (senderData->currentTransmittingTangentOverType == LISTEN_TO_SW || ignoreSwTangent)) || //Sending over SW
		(senderData->canUseLRRadio && (senderData->currentTransmittingTangentOverType == LISTEN_TO_LR || ignoreLrTangent))) { //Sending over LR
		for (std::multimap<std::string, SPEAKER_DATA>::iterator itr = TFAR::getInstance().m_gameData.speakers.begin(); itr != TFAR::getInstance().m_gameData.speakers.end(); ++itr) {
			if ((itr->first == senderData->getCurrentTransmittingFrequency()) &&
				(itr->second.nickname != senderNickname)) {//If the speaker is Senders backpack we don't hear it.. Because he is sending with his Backpack so it can't receive
				SPEAKER_DATA speaker = itr->second;
				LISTED_INFO info;
				info.on = LISTED_ON_GROUND;
				info.over = (senderData->currentTransmittingTangentOverType == LISTEN_TO_SW || ignoreSwTangent) ? LISTEN_TO_SW : LISTEN_TO_LR;
				info.radio_id = speaker.radio_id;
				info.stereoMode = stereoMode::stereo;
				info.vehicle = speaker.vehicle;
				info.volume = speaker.volume;
				info.waveZ = speaker.waveZ;
				bool posSet = false;
				if (speaker.pos) {
					info.pos = speaker.pos;
					posSet = true;
				} else {//pos is empty array. Which tells us to use clients Position
					int currentDataFrame = TFAR::getInstance().m_gameData.currentDataFrame;
					if (clientDataDir && clientDataDir->getClientData(speaker.nickname)) {
						std::shared_ptr<clientData>& clientData = clientDataDir->getClientData(speaker.nickname);
						if (abs(currentDataFrame - clientData->dataFrame) <= 1) {
							info.pos = clientData->getClientPosition();
							posSet = true;
						}
					}
				}
				if (posSet) {
					result.push_back(info);
				}
			}
		}
	}
	return result;
}

void setGameClientMuteStatus(TSServerID serverConnectionHandlerID, TSClientID clientID) {
	bool mute = false;
	if (isSeriousModeEnabled(serverConnectionHandlerID, clientID)) {

		auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
		std::shared_ptr<clientData> clientData;
		if (clientDataDir)
			clientData = clientDataDir->getClientData(clientID);
		auto myData = clientDataDir->myClientData;

		if (clientData && myData && TFAR::getInstance().m_gameData.alive) {
			std::vector<LISTED_INFO> listedInfo = isOverRadio(serverConnectionHandlerID, clientData, myData, false, false, false);
			if (listedInfo.empty()) {
				bool isTalk = clientData->clientTalkingNow || Teamspeak::isTalking(serverConnectionHandlerID, clientData->clientId);
				mute = myData->getClientPosition().distanceTo(clientData->getClientPosition()) > clientData->voiceVolume || !isTalk;
			} else {
				mute = false;
			}
		} else {
			mute = true;
		}
		if (mute && clientData) clientData->resetVoices();
	}
	Teamspeak::setClientMute(serverConnectionHandlerID, clientID, mute);
}

std::string getConnectionStatusInfo(bool pipeConnected, bool inGame, bool includeVersion) {
	std::ostringstream stringStream;
	stringStream << "Connected to Game: " << (pipeConnected ? "[B]Yes[/B]" : "[B]No[/B]") << std::endl;
	stringStream << "Playing: " << (inGame ? "[B]Yes[/B]" : "[B]No[/B]") << std::endl;
	if (includeVersion) {
		stringStream << "Plugin version: [B]" << PLUGIN_VERSION << "[/B]" << std::endl;
		stringStream << "Addon version: [B]" << TFAR::config.get<std::string>(Setting::addon_version) << "[/B]" << std::endl;
	}
	return stringStream.str();
}

void updateUserStatusInfo(bool pluginEnabled) {
	if (!Teamspeak::isConnected()) return;
	std::string result;
	if (pluginEnabled)
		result = getConnectionStatusInfo(pipeConnected, TFAR::getInstance().getCurrentlyInGame(), true);
	else
		result = "[B]Task Force Radio Plugin Disabled[/B]";
	Teamspeak::setMyMetaData(result);
}

void setMuteForDeadPlayers(uint64 serverConnectionHandlerID, bool isSeriousModeEnabled) {
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!clientDataDir)
		return;

	bool alive = TFAR::getInstance().m_gameData.alive;
	std::vector<TSClientID> clientsIds = Teamspeak::getChannelClients(serverConnectionHandlerID, Teamspeak::getCurrentChannel(serverConnectionHandlerID));
	anyID myId = Teamspeak::getMyId(serverConnectionHandlerID);
	for (auto & Id : clientsIds) {
		if (Id != myId && !clientDataDir->getClientData(Id)) {
			Teamspeak::setClientMute(serverConnectionHandlerID, Id, alive && isSeriousModeEnabled); // mute not listed client if you alive, and unmute them if not
		}
	}
}

void updateNicknamesList(TSServerID serverConnectionHandlerID = Teamspeak::getCurrentServerConnection()) {
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!clientDataDir)
		return;
	return;//#TODO deprecate!
	//std::vector<TSClientID> clients = Teamspeak::getChannelClients(serverConnectionHandlerID, Teamspeak::getCurrentChannel(serverConnectionHandlerID));
	//for (anyID clientId : clients) {
	//	std::string clientNickname = Teamspeak::getClientNickname(serverConnectionHandlerID, clientId);
	//	if (clientNickname.empty()) continue;
	//	std::shared_ptr<clientData>& data = serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname];
	//	if (data)
	//		data->clientId = clientId;
	//}
	//serverIdToData.setMyNickname(serverConnectionHandlerID, Teamspeak::getMyNickname(serverConnectionHandlerID));
}

DEFINE_API_PROFILER(processUnitPosition);

std::string processUnitPosition(TSServerID serverConnection, const unitPositionPacket & packet) {
	API_PROFILER(processUnitPosition);

	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnection);
	if (!clientDataDir)
		return "NOT_SPEAKING";

	auto clientData = clientDataDir->getClientData(packet.nickname);
	if (!clientData)
		return "NOT_SPEAKING";

	clientData->updatePosition(packet);
	bool clientTalkingOnRadio = (clientData->currentTransmittingTangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;

	if (clientData == clientDataDir->myClientData) {
		Teamspeak::setMyClient3DPosition(serverConnection, Position3D());
	} else {
		setGameClientMuteStatus(serverConnection, clientData->clientId);
		Teamspeak::setClient3DPosition(serverConnection, clientData->clientId, Position3D());
	}

	if (clientTalkingOnRadio || clientData->clientTalkingNow) {
		return "SPEAKING";
	}
	return "NOT_SPEAKING";
}

PTTDelayArguments::subtypes PTTDelayArguments::stringToSubtype(const std::string& type) {
	switch (type.length()) {
		case const_strlen("dd"): return subtypes::dd;
		case const_strlen("digital"): return subtypes::digital;
		case const_strlen("airborne"): return subtypes::airborne;
		case const_strlen("digital_lr"): return subtypes::digital_lr;
		case const_strlen("phone"): return subtypes::phone;
		default: return subtypes::invalid;
	}
}

#include "CommandProcessor.hpp"

void removeExpiredPositions(TSServerID serverConnectionHandlerID) {
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	//#TODO add removeExpiredPositions func to serverData
	//if (clientDataDir)
	//	clientDataDir->nicknameToClientData.removeExpiredPositions(TFAR::getInstance().m_gameData.currentDataFrame);
}

volatile DWORD lastInGame = GetTickCount();
volatile DWORD lastCheckForExpire = GetTickCount();
volatile DWORD lastInfoUpdate = GetTickCount();

void ServiceThread() {

	while (!exitThread) {
		if (!Teamspeak::isConnected()) {  //If not connected we don't have any clientData anyway
			Sleep(500);
			continue;
		}
		if (GetTickCount() - lastCheckForExpire > MILLIS_TO_EXPIRE) {
			bool isSerious = isSeriousModeEnabled(Teamspeak::getCurrentServerConnection(), Teamspeak::getMyId());
			removeExpiredPositions(Teamspeak::getCurrentServerConnection());
			if (TFAR::getInstance().getCurrentlyInGame()) setMuteForDeadPlayers(Teamspeak::getCurrentServerConnection(), isSerious);
			lastCheckForExpire = GetTickCount();
		}
		if (GetTickCount() - lastInfoUpdate > MILLIS_TO_EXPIRE) {
			updateUserStatusInfo(true);
			lastInfoUpdate = GetTickCount();
		}
		Sleep(100);
	}
}
#define USE_SHAREDMEM
void PipeThread() {
#ifdef USE_SHAREDMEM
	SharedMemoryHandler pipeHandler;


	pipeHandler.onDisconnected.connect(
		[&]() {
		OutputDebugStringA("disconnected\n");
		pipeConnected = false;
		updateUserStatusInfo(true);
		TFAR::getInstance().onGameDisconnected();

	});

	pipeHandler.onConnected.connect(
		[&]() {
		OutputDebugStringA("connected\n");
		pipeConnected = true;
		TFAR::getInstance().onGameConnected();
	});

#else
	pipe_handler pipeHandler;
#endif


	std::string command;
	while (!exitThread) {
		if (!pipeHandler.isConnected()) { //Need this call! It sets the lastPluginTick variable and causes on(dis)Connected events
			std::this_thread::sleep_for(5ms);
			continue;
		}

#ifdef USE_SHAREDMEM
		pipeHandler.setConfigNeedsRefresh(TFAR::config.needsRefresh());	//#TODO Signal/Slot ?
#endif
		if (!pipeHandler.getData(command, 20ms))//This will still wait. 1ms if SHAMEM error. 20ms if game unconnected
			continue;

		speedTest gameCommandIn("gameCommandInPipe", false);
		bool dataReturned = false;
		if (command.back() == '~') {//a ~ at the end identifies an Async call
			command.pop_back();//removes ~ from end
#ifdef USE_SHAREDMEM
			TFAR::getInstance().getCommandProcessor()->queueCommand(command);
#else
			if (pipeHandler.sendData("OK", 2)) {
				log_string("Info to ARMA send async", LogLevel_DEBUG);
				dataReturned = true;
			} else {
				log_string("Can't send info to ARMA async", LogLevel_ERROR);
			}
#endif	
		} else {
			gameCommandIn.reset();
#ifdef USE_SHAREDMEM
			std::string commandResult = TFAR::getInstance().getCommandProcessor()->processCommand(command);
			pipeHandler.sendData(commandResult);
			if (gameCommandIn.getCurrentElapsedTime().count() > 200)
				log_string("gameinteraction " + std::to_string(gameCommandIn.getCurrentElapsedTime().count()) + command, LogLevel_INFO);   //#TODO remove logging and creation variable
#else
			if (gameCommandIn.getCurrentElapsedTime().count() > 200)
				log_string("gameinteraction " + std::to_string(gameCommandIn.getCurrentElapsedTime().count()) + command, LogLevel_INFO);   //#TODO remove logging and creation variable

			if (!dataReturned) {
				if (pipeHandler.sendData(commandResult)) {
					log_string("Info to ARMA send", LogLevel_DEBUG);
				} else {
					log_string("Can't send info to ARMA", LogLevel_ERROR);
				}
			}
#endif

		}

	}
}

int pttCallback(void *arg, int argc, char **argv, char **azColName) {
	if (argc != 1) return 1;
	if (argv[0] != NULL) {
		std::vector<std::string> v = helpers::split(argv[0], '\n');
		for (const std::string i : v) {
			if (i == "delay_ptt=true") {
				pttDelay = true;
			}
			if (i.substr(0, const_strlen("delay_ptt_msecs")) == "delay_ptt_msecs") {
				std::vector<std::string> values = helpers::split(i, '=');
				pttDelayMs = std::stoi(values[1]);
			}
		}
	}
	return 0;
}

/*
 * Custom code called right after loading the plugin. Returns 0 on success, 1 on failure.
 * If the function returns 1 on failure, the plugin will be unloaded again.
 */
extern struct TS3Functions ts3Functions;

/* Plugin API version. Must be the same as the clients API major version, else the plugin fails to load. */


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


#pragma comment (lib, "version.lib")
int ts3plugin_apiVersion() {

	WCHAR fileName[_MAX_PATH];
	DWORD size = GetModuleFileName(nullptr, fileName, _MAX_PATH);
	fileName[size] = NULL;
	DWORD handle = 0;
	size = GetFileVersionInfoSize(fileName, &handle);
	BYTE* versionInfo = new BYTE[size];
	if (!GetFileVersionInfo(fileName, handle, size, versionInfo)) {
		delete[] versionInfo;
		return PLUGIN_API_VERSION;
	}
	UINT    			len = 0;
	VS_FIXEDFILEINFO*   vsfi = nullptr;
	VerQueryValue(versionInfo, L"\\", reinterpret_cast<void**>(&vsfi), &len);
	short version = HIWORD(vsfi->dwFileVersionLS);
	delete[] versionInfo;
	switch (version) {
		case 9: return 19;
		case 10: return 19;
		case 11: return 19;
		case 12: return 19;
		case 13: return 19;
		case 14: return 20;
		case 15: return 20;
		case 16: return 20;
		case 17: return 20;
		case 18: return 20;
		case 19: return 20;
		case 20: return 21;
		default: return PLUGIN_API_VERSION;
	}
}

bool pluginInitialized = false;
int ts3plugin_init() {
	pluginInitialized = true;
	if (ts3plugin_apiVersion() <= 20) {
		ts3Functions.getPluginPath(pluginPath, PATH_BUFSIZE);
	} else {	//Compatibility hack for API version > 21
		typedef  void(*getPluginPath_20)(char* path, size_t maxLen, const char* pluginID);
		static_cast<getPluginPath_20>(static_cast<void*>(ts3Functions.getPluginPath))(pluginPath, PATH_BUFSIZE, TFAR::getInstance().getPluginID().c_str()); //This is ugly but keeps compatibility
	}


#ifdef ENABLE_API_PROFILER
	Logger::registerLogger(LoggerTypes::profiler, std::make_shared<FileLogger>("P:/profiler.log"));
	Logger::registerLogger(LoggerTypes::gameCommands, std::make_shared<FileLogger>("P:/gameCommands.log"));
	Logger::registerLogger(LoggerTypes::pluginCommands, std::make_shared<FileLogger>("P:/pluginCommands.log"));
	Logger::registerLogger(LoggerTypes::teamspeakClientlog, std::make_shared<TeamspeakLogger>(LogLevel::LogLevel_INFO));
#endif


	//#TODO this func should be in Teamspeak and TFAR needs init event

	TFAR::getInstance().setPluginPath(pluginPath);
	TFAR::getServerDataDirectory();//initializes the ServerdataDirectory so it connects its Slots to TFAR's Signals

	Teamspeak::_onInit();


	exitThread = false;
	threadPipeHandle = std::thread(&PipeThread);
	threadService = std::thread(&ServiceThread);
	TFAR::createCheckForUpdateThread();

	TFAR::getInstance().onGameDisconnected.connect([]() {
		TFAR::getInstance().m_gameData.alive = false;
		TFAR::getInstance().m_gameData.currentDataFrame = INVALID_DATA_FRAME;
	});




	char path[MAX_PATH];
	ts3Functions.getConfigPath(path, MAX_PATH);
	strcat_s(path, MAX_PATH, "settings.db");

	sqlite3 *db = 0;
	char *err = 0;
	if (!sqlite3_open(path, &db)) {
		sqlite3_exec(db, "SELECT value FROM Profiles WHERE key='Capture/Default/PreProcessing'", pttCallback, NULL, &err);
		sqlite3_close(db);
	}

	return 0;
}

/* Custom code called right before the plugin is unloaded */
void ts3plugin_shutdown() {
	if (!pluginInitialized) return;	//For some reason shutdown is called before init.
	pluginInitialized = false;
	/* Your plugin cleanup code here */
	Logger::log(LoggerTypes::teamspeakClientlog, "shutdown...", LogLevel_DEVEL);

	exitThread = true;
	threadPipeHandle.join();
	threadService.join();
	TFAR::getInstance().onShutdown();//Call shutdown Signal

	TFAR::getInstance().m_gameData.alive = false;
	pipeConnected = false;
	updateUserStatusInfo(false);
	Teamspeak::unmuteAll();
}

/*
 * Dynamic content shown in the right column in the info frame. Memory for the data string needs to be allocated in this
 * function. The client will call ts3plugin_freeMemory once done with the string to release the allocated memory again.
 * Check the parameter "type" if you want to implement this feature only for specific item types. Set the parameter
 * "data" to NULL to have the client ignore the info data.
 */
void ts3plugin_infoData(uint64 serverConnectionHandlerID, uint64 id, enum PluginItemType type, char** data) {

	if (PLUGIN_CLIENT == type) {
		std::string metaData = Teamspeak::getMetaData(serverConnectionHandlerID, id);
		*data = static_cast<char*>(malloc(INFODATA_BUFSIZE * sizeof(char)));  /* Must be allocated in the plugin! */
		snprintf(*data, INFODATA_BUFSIZE, "%s", metaData.c_str());  /* bbCode is supported. HTML is not supported */
	} else {
		*data = NULL;
	}
}

/************************** TeamSpeak callbacks ***************************/
/*
 * Following functions are optional, feel free to remove unused callbacks.
 * See the clientlib documentation for details on each function.
 */

 /* Clientlib */


bool isPluginEnabledForUser(TSServerID serverConnectionHandlerID, TSClientID clientID) {	 //#TODO isn't it enough to check if their metaData contains <TFAR> ?
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!clientDataDir) return false;
	auto clientData = clientDataDir->getClientData(clientID);
	if (!clientData) return false;


	DWORD currentTime = GetTickCount();	 //#TODO std::chrono milliseconds 1 tick == 1 ms
	bool result;

	if (currentTime - clientData->pluginEnabledCheck < 10000) {
		result = clientData->pluginEnabled;
	} else {
		std::string clientInfo = Teamspeak::getMetaData(Teamspeak::getCurrentServerConnection(), clientID);
		if (clientInfo.empty()) return false;
		std::string shouldStartWith = getConnectionStatusInfo(true, true, false);  //slow 1%
		result = clientData->pluginEnabled = helpers::startsWith(shouldStartWith, clientInfo);
	}

	clientData->pluginEnabledCheck = currentTime;

	return result;
}

//packet receive ->	decode -> onEditPlaybackVoiceDataEvent -> 3D positioning -> onEditPostProcessVoiceDataEvent -> mixing -> onEditMixedPlaybackVoiceDataEvent -> speaker output
void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
	TFAR::getInstance().getPlaybackHandler()->onEditMixedPlaybackVoiceDataEvent(samples, sampleCount, channels, channelSpeakerArray, channelFillMask);
}

void ts3plugin_onEditPostProcessVoiceDataEventStereo(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels) {
	if (!TFAR::getInstance().getCurrentlyInGame())
		return;
	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
	static DWORD last_no_info;
	anyID myId = Teamspeak::getMyId(serverConnectionHandlerID);
	std::string myNickname = Teamspeak::getMyNickname(serverConnectionHandlerID);

	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!clientDataDir) return;	//Unknown server
	auto clientData = clientDataDir->getClientData(clientID);
	if (!clientData) {
		//Should not happen..
		log_string(std::string("No info about ") + std::to_string((long long) clientID) + " " + Teamspeak::getClientNickname(serverConnectionHandlerID, clientID), LogLevel_ERROR);
		return; //Unknown client
	}

	bool alive = TFAR::getInstance().m_gameData.alive && clientDataDir->myClientData;//If i don't know who i am... I am not alive

	bool hasPluginEnabled = isPluginEnabledForUser(serverConnectionHandlerID, clientID);

	if (!clientData || !clientDataDir->myClientData || !hasPluginEnabled) {
		if (clientID == myId) {
			memset(samples, 0, channels * sampleCount * sizeof(short));
			return;
		}


		if (isSeriousModeEnabled(serverConnectionHandlerID, clientID)) {
			if (alive && TFAR::getInstance().getCurrentlyInGame() && hasPluginEnabled)
				helpers::applyGain(samples, sampleCount, channels, 0.0f); // alive player hears only alive players in serious mode
		}
		if (GetTickCount() - last_no_info > MILLIS_TO_EXPIRE) {
			std::string nickname = clientData->getNickname();
			if (!hasPluginEnabled)
				log_string(std::string("No plugin enabled for ") + std::to_string((long long) clientID) + " " + nickname, LogLevel_DEBUG);
			last_no_info = GetTickCount();
		}
		return;
	}
	bool canSpeak = clientDataDir->myClientData->canSpeak;
	if (isSeriousModeEnabled(serverConnectionHandlerID, clientID) && !alive) {
		helpers::applyGain(samples, sampleCount, channels, 0.0f);
	} else {
		auto myData = clientDataDir->myClientData;
		auto myPosition = myData->getClientPosition();
		float globalGain = TFAR::getInstance().m_gameData.globalVolume;
		if (clientData && myData) {
			helpers::applyGain(samples, sampleCount, channels, clientData->voiceVolumeMultiplifier);
			short* original_buffer = helpers::allocatePool(sampleCount, channels, samples);

			bool shouldPlayerHear = (clientData->canSpeak && canSpeak);

			std::pair<std::string, float> myVehicleDesriptor = helpers::getVehicleDescriptor(myData->getVehicleId());
			std::pair<std::string, float> hisVehicleDesriptor = helpers::getVehicleDescriptor(clientData->getVehicleId());

			const float vehicleVolumeLoss = helpers::clamp(myVehicleDesriptor.second + hisVehicleDesriptor.second, 0.0f, 0.99f);
			bool vehicleCheck = (myVehicleDesriptor.first == hisVehicleDesriptor.first);
			float distanceFromClient_ = myPosition.distanceTo(clientData->getClientPosition()) + (2 * clientData->objectInterception); //2m more dist for each obstacle

			if (myId != clientID && distanceFromClient_ <= clientData->voiceVolume) {
				//Direct Speech
				//process voice
				auto relativePosition = myPosition.directionTo(clientData->getClientPosition());
				auto myViewDirection = myData->getViewDirection();
				//Time differential based on direction
				clientData->getClunk("voice_clunk")->process(samples, channels, sampleCount, relativePosition, myViewDirection);//interaural time difference
				//Volume differential based on direction
				helpers::applyILD(samples, sampleCount, channels, myPosition, myViewDirection, clientData->getClientPosition(),clientData->getViewDirection());

		//helpers::applyILD(samples, sampleCount, channels, relativePosition, myViewDirection);//interaural level difference


				if (shouldPlayerHear) {
					if (vehicleVolumeLoss < 0.01 || vehicleCheck) {

						helpers::applyGain(samples, sampleCount, channels, helpers::volumeAttenuation(distanceFromClient_, shouldPlayerHear, clientData->voiceVolume));
						if (clientData->objectInterception > 0) {
							helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, 1.0f,
								clientData->getFilterObjectInterception(clientData->objectInterception)); //getFilterObjectInterception
						}
					} else {
						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, helpers::volumeAttenuation(distanceFromClient_, shouldPlayerHear, clientData->voiceVolume, 1.0f - vehicleVolumeLoss) * pow(1.0f - vehicleVolumeLoss, 1.2f), clientData->getFilterVehicle("local_vehicle", vehicleVolumeLoss));
					}
				} else {
					helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, helpers::volumeAttenuation(distanceFromClient_, shouldPlayerHear, clientData->voiceVolume) * CANT_SPEAK_GAIN, (clientData->getFilterCantSpeak("local_cantspeak")));
				}

			} else {
				memset(samples, 0, channels * sampleCount * sizeof(short));
			}
			// process radio here
			processCompressor(&clientData->compressor, original_buffer, channels, sampleCount);

			std::vector<LISTED_INFO> listed_info = isOverRadio(serverConnectionHandlerID, clientData, myData, false, false, false);
			float radioDistance = effectiveDistance(serverConnectionHandlerID, clientData);

			for (size_t q = 0; q < listed_info.size(); q++) {
				LISTED_INFO& info = listed_info[q];
				short* radio_buffer = helpers::allocatePool(sampleCount, channels, original_buffer);
				float volumeLevel = helpers::volumeMultiplifier(static_cast<float>(info.volume));

				switch (PTTDelayArguments::stringToSubtype(clientData->getCurrentTransmittingSubtype())) {
					case PTTDelayArguments::subtypes::digital:
						clientData->getSwRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, serverConnectionHandlerID, clientData));
						processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, clientData->getSwRadioEffect(info.radio_id), info.stereoMode);
						break;
					case PTTDelayArguments::subtypes::digital_lr:
					case PTTDelayArguments::subtypes::airborne:
						clientData->getLrRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, serverConnectionHandlerID, clientData));
						processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, clientData->getLrRadioEffect(info.radio_id), info.stereoMode);
						break;
					case PTTDelayArguments::subtypes::dd: {
						float ddVolumeLevel = helpers::volumeMultiplifier(static_cast<float>(TFAR::getInstance().m_gameData.ddVolumeLevel));
						clientData->getUnderwaterRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, clientData->getClientPosition().distanceTo(myData->getClientPosition()), serverConnectionHandlerID, clientData));
						processRadioEffect(radio_buffer, channels, sampleCount, ddVolumeLevel * 0.6f, clientData->getUnderwaterRadioEffect(info.radio_id), info.stereoMode);
						break; }
					case  PTTDelayArguments::subtypes::phone:
						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, volumeLevel * 10.0f, (clientData->getSpeakerPhone(info.radio_id)));
						break;
					default:
						helpers::applyGain(radio_buffer, sampleCount, channels, 0.0f);
						break;
				}

				if (info.on == LISTED_ON_GROUND) {

					float distance_from_radio = myPosition.distanceTo(info.pos);

					const float radioVehicleVolumeLoss = helpers::clamp(myVehicleDesriptor.second + info.vehicle.second, 0.0f, 0.99f);
					bool radioVehicleCheck = (myVehicleDesriptor.first == info.vehicle.first);

					helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, SPEAKER_GAIN, (clientData->getSpeakerFilter(info.radio_id)));

					float speakerDistance = (info.volume / 10.f) * TFAR::getInstance().m_gameData.speakerDistance;
					if (radioVehicleVolumeLoss < 0.01f || radioVehicleCheck) {
						helpers::applyGain(radio_buffer, sampleCount, channels, helpers::volumeAttenuation(distance_from_radio, shouldPlayerHear, speakerDistance));
					} else {
						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, helpers::volumeAttenuation(distance_from_radio, shouldPlayerHear, speakerDistance, 1.0f - radioVehicleVolumeLoss) * pow((1.0f - radioVehicleVolumeLoss), 1.2f), (clientData->getFilterVehicle(info.radio_id, radioVehicleVolumeLoss)));
					}
					if (info.waveZ < UNDERWATER_LEVEL) {
						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, CANT_SPEAK_GAIN, (clientData->getFilterCantSpeak(info.radio_id)));
					}
					auto relativePosition = myPosition.directionTo(info.pos);
					auto myViewDirection = myData->getViewDirection();

					clientData->getClunk(info.radio_id)->process(radio_buffer, channels, sampleCount, relativePosition, myViewDirection);//interaural time difference
					helpers::applyILD(radio_buffer, sampleCount, channels, relativePosition, myViewDirection);//interaural level difference
				}
				helpers::mix(samples, radio_buffer, sampleCount, channels);


				delete[] radio_buffer;
			}

			delete[] original_buffer;

			helpers::applyGain(samples, sampleCount, channels, globalGain);
		}
	}

}

//packet receive ->	decode -> onEditPlaybackVoiceDataEvent -> 3D positioning -> onEditPostProcessVoiceDataEvent -> mixing -> onEditMixedPlaybackVoiceDataEvent -> speaker output
//Data from other clients to us. After 3D processing
void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
	if (!TFAR::getInstance().getCurrentlyInGame())
		return;

	short* stereo = new short[sampleCount * 2];
	for (int q = 0; q < sampleCount; q++) {
		for (int g = 0; g < 2; g++)
			stereo[q * 2 + g] = samples[q * channels + g];
	}

	ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, clientID, stereo, sampleCount, 2);

	for (int q = 0; q < sampleCount; q++) {
		for (int g = 0; g < 2; g++)
			samples[q * channels + g] = stereo[q * 2 + g];
		for (int g = 2; g < channels; g++)
			samples[q * channels + g] = 0;
	}

	delete[] stereo;
}

//Data from our microphone before its sent
void ts3plugin_onEditCapturedVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, int* edited) {
	if (!TFAR::getInstance().getCurrentlyInGame() || !(*edited & 2))
		return;

	if (!TFAR::getInstance().m_gameData.alive || TFAR::getInstance().m_gameData.speakers.empty()) return;
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!clientDataDir || !clientDataDir->myClientData) return;


	short* voice;
	if (channels == 1) {  //copy to stereo
		voice = new short[sampleCount * 2];
		for (int q = 0; q < sampleCount; q++) {
			voice[q * 2] = samples[q];
			voice[q * 2 + 1] = samples[q];
		}
	} else
		voice = samples;

	ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, clientDataDir->myClientData->clientId, voice, sampleCount, 2);

	TFAR::getInstance().getPlaybackHandler()->appendPlayback("my_radio_voice", voice, sampleCount, 2);
	if (channels == 1)
		delete[] voice;
}

void ts3plugin_onCustom3dRolloffCalculationClientEvent(uint64 serverConnectionHandlerID, anyID clientID, float distance, float* volume) {
	*volume = 1.0f;	// custom gain applied
}

/* Clientlib rare */
void ts3plugin_onClientSelfVariableUpdateEvent(uint64 serverConnectionHandlerID, int flag, const char* oldValue, const char* newValue) {
	if (flag == CLIENT_FLAG_TALKING && TFAR::getInstance().getCurrentlyInGame()) {
		//#TODO resend this when talking while changing volume
		std::string one = "1";
		bool start = (one == newValue);
		TSServerID serverId = Teamspeak::getCurrentServerConnection();
		std::string myNickname = Teamspeak::getMyNickname(serverId);
		std::string command = "VOLUME\t" + myNickname + "\t" + std::to_string(TFAR::getInstance().m_gameData.myVoiceVolume) + "\t" + (start ? "true" : "false");
		Logger::log(LoggerTypes::pluginCommands, "Send " + command);
		Teamspeak::sendPluginCommand(serverId, TFAR::getInstance().getPluginID(), command, PluginCommandTarget_CURRENT_CHANNEL);
	}

	/*
	Don't know what this was supposed to be. So I'll just leave it here - Dedmen
	if (flag == CLIENT_FLAG_TALKING && *newValue == '0' && inGame) {
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
		bool set_talk_to_true = false;
		if (TFAR::getInstance().m_gameData.tangentPressed) {
			set_talk_to_true = true;
		}
		if (set_talk_to_true) {
			//TODO:
			/*DWORD error;
			if ((error = ts3Functions.setClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_DEACTIVATED, INPUT_ACTIVE)) != ERROR_ok) {
				log("Can't active talking by tangent", error);
			}
			error = ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
			if (error != ERROR_ok && error != ERROR_ok_no_update) {
				log("Can't flush self updates", error);
			};* /
		}
	}
	*/
}

void processAllTangentRelease(TSServerID serverId, std::vector<std::string> &tokens) {
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverId);
	if (!clientDataDir) return;
	const std::string nickname = tokens[1];//only copying for readability.. hope compiler optimizes that out
	auto clientData = clientDataDir->getClientData(nickname);
	if (!clientData) return;

	clientData->currentTransmittingTangentOverType = LISTEN_TO_NONE;
}

void processTangentPress(TSServerID serverId, std::vector<std::string> &tokens, std::string &command) {
	std::string nickname = tokens[5];
	//Input validation first.
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverId);
	if (!clientDataDir) return;
	auto clientData = clientDataDir->getClientData(nickname);
	if (!clientData) {
		log_string(std::string("PLUGIN FROM UNKNOWN NICKNAME ") + nickname);
		return;
	}
	auto myClientData = clientDataDir->myClientData;
	if (!myClientData) //if we don't know who we are we also can't hear anything
		return;



	DWORD time = GetTickCount();
	bool pressed = (tokens[1] == "PRESSED");
	bool longRange = (tokens[0] == "TANGENT_LR");	 //#TODO make enum to switch on instead 3 bools
	bool diverRadio = (tokens[0] == "TANGENT_DD");
	bool shortRange = !longRange && !diverRadio;
	std::string subtype = tokens[4];
	int range = helpers::parseArmaNumberToInt(tokens[3]);

	std::string frequency = tokens[2];
	bool playPressed = false;

	bool alive = TFAR::getInstance().m_gameData.alive;



	clientData->pluginEnabled = true;//He just sent us a Plugin command... Either he has Plugin enabled or he is a hacker
	clientData->pluginEnabledCheck = time;
	clientData->setLastPositionUpdateTime(time);
	clientData->setCurrentTransmittingSubtype(subtype);


	//If he could press the tangent.. He is obviously able to use that radio... unless he is using telekinesis...
	if (longRange) clientData->canUseLRRadio = true;
	else if (diverRadio) clientData->canUseDDRadio = true;
	else clientData->canUseSWRadio = true;

	if ((clientData->currentTransmittingTangentOverType != LISTEN_TO_NONE) != pressed) {
		playPressed = pressed;
	}

	//tell his clientData where he is transmitting from
	if (pressed) {
		if (longRange) clientData->currentTransmittingTangentOverType = LISTEN_TO_LR;
		else if (diverRadio) clientData->currentTransmittingTangentOverType = LISTEN_TO_DD;
		else clientData->currentTransmittingTangentOverType = LISTEN_TO_SW;
	} else {
		clientData->currentTransmittingTangentOverType = LISTEN_TO_NONE;
	}

	clientData->setCurrentTransmittingFrequency(frequency);
	clientData->range = range;

	anyID clientId = clientData->clientId;

	//Check where we can Receive him. Radios or Speakers
	std::vector<LISTED_INFO> listedInfos = isOverRadio(serverId, clientData, myClientData, !longRange && !diverRadio, longRange, diverRadio);
	for (LISTED_INFO & listedInfo : listedInfos) {
		std::string vehicleName;
		float vehicleIsolation;
		std::tie(vehicleName, vehicleIsolation) = helpers::getVehicleDescriptor(myClientData->getVehicleId());

		const float vehicleVolumeLoss = helpers::clamp(vehicleIsolation + listedInfo.vehicle.second, 0.0f, 0.99f);
		bool vehicleCheck = (vehicleName == listedInfo.vehicle.first);

		float gain = helpers::volumeMultiplifier(static_cast<float>(listedInfo.volume)) * TFAR::getInstance().m_gameData.globalVolume;

		setGameClientMuteStatus(serverId, clientId);
		if (alive && listedInfo.on != LISTED_ON_NONE) {
			switch (PTTDelayArguments::stringToSubtype(subtype)) {
				case PTTDelayArguments::subtypes::digital:
					if (playPressed) TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/sw/remote_start" : "radio-sounds/sw/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
					break;
				case PTTDelayArguments::subtypes::digital_lr:
					if (playPressed) TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/lr/remote_start" : "radio-sounds/lr/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
					break;
				case PTTDelayArguments::subtypes::dd:
					if (playPressed) TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/dd/remote_start" : "radio-sounds/dd/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
					break;
				case PTTDelayArguments::subtypes::airborne:
					if (playPressed) TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/ab/remote_start" : "radio-sounds/ab/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
					break;
			}
		}
	}

	if (!playPressed && alive) {
		clientData->resetRadioEffect();
	}

}

void processPluginCommand(std::string command) {
	DWORD currentTime = GetTickCount();
	std::vector<std::string> tokens = helpers::split(command, '\t'); // may not be used in nickname
	TSServerID serverId = Teamspeak::getCurrentServerConnection();

	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverId);
	if (!clientDataDir) return;



	if (tokens.size() == 6 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" || tokens[0] == "TANGENT_DD")) {
		processTangentPress(serverId, tokens, command);
	} else if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS") {
		processAllTangentRelease(serverId, tokens);
	} else if (tokens.size() == 4 && tokens[0] == "VOLUME") {
		std::string nickname = tokens[1];
		auto clientData = clientDataDir->getClientData(nickname);
		if (!clientData) return; //Don't know who the sender is.. so we don't care

		std::string volume = tokens[2];
		bool start = helpers::isTrue(tokens[3]);
		bool myCommand = clientData == clientDataDir->myClientData;

		clientData->voiceVolume = std::stoi(volume.c_str());
		clientData->pluginEnabled = true;
		clientData->pluginEnabledCheck = currentTime;
		clientData->clientTalkingNow = start;
		if (!myCommand) {
			setGameClientMuteStatus(serverId, clientData->clientId);
		}
	} else if (tokens.size() == 2 && tokens[0] == "REQVOL") {//#TODO request volume onGameStart for each client not currently known
		TSClientID clientID = std::stoi(tokens[1]);
		if (!clientDataDir->myClientData)
			return;
		auto volume = clientDataDir->myClientData->voiceVolume;
		std::string myNickname = clientDataDir->myClientData->getNickname();
		bool curTalking = clientDataDir->myClientData->clientTalkingNow;
		//#TODO send a VOLUME command
		//Teamspeak::sendPluginCommand(Teamspeak::getCurrentServerConnection(), TFAR::getInstance().getPluginID(), command, PluginCommandTarget_CLIENT, { clientID });
	} else {
		log_string(std::string("UNKNOWN PLUGIN COMMAND ") + command);
	}
}

void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
	Logger::log(LoggerTypes::pluginCommands, std::string(pluginName) + ":" + std::string(pluginCommand));
	log_string(std::string("ON PLUGIN COMMAND ") + pluginName + " " + pluginCommand, LogLevel_DEVEL);
	if (serverConnectionHandlerID == Teamspeak::getCurrentServerConnection()) {
		if (strncmp(pluginName, PLUGIN_NAME, strlen(PLUGIN_NAME)) == 0) {
			processPluginCommand(std::string(pluginCommand));
		} else {
			Logger::log(LoggerTypes::teamspeakClientlog, "Plugin command event failure", LogLevel_ERROR);
		}
	} else {
		Logger::log(LoggerTypes::teamspeakClientlog, "Plugin command unknown ID", LogLevel_ERROR);
	}
}
