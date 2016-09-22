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



#include "RadioEffect.h"


#include "client_data.hpp"
#include "server_radio_data.hpp"
#include "task_force_radio.hpp"
#include "common.h"
#include "pipe_handler.h"
#include "helpers.h"
#include "playback_handler.h"

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
	int stereoMode;
	std::string radio_id;
	TS3_VECTOR pos;
	float waveZ;
	std::pair<std::string, float> vehicle;
};

#define PATH_BUFSIZE 512
char pluginPath[PATH_BUFSIZE];

HANDLE threadPipeHandle = INVALID_HANDLE_VALUE;
HANDLE threadService = INVALID_HANDLE_VALUE;

volatile bool exitThread = FALSE;
volatile bool pipeConnected = false;
volatile bool inGame = false;

volatile bool pttDelay = false;
volatile long pttDelayMs = 0;

volatile uint64 notSeriousChannelId = uint64(-1);
volatile bool vadEnabled = false;
char* pluginID = NULL;

CRITICAL_SECTION serverDataCriticalSection;
CRITICAL_SECTION tangentCriticalSection;

SERVER_ID_TO_SERVER_DATA serverIdToData;
playback_handler playbackHandler;

struct TS3Functions ts3Functions;
//#define DEBUG_MOD_ENABLED

void log(const char* message, LogLevel level) {
#ifndef DEBUG_MOD_ENABLED
	if (level != LogLevel_DEVEL && level != LogLevel_DEBUG)
#endif
		ts3Functions.logMessage(message, level, "task_force_radio", 141);
}

void log_string(std::string message, LogLevel level) {
	log(message.c_str(), level);
}

void log(char* message, DWORD errorCode, LogLevel level = LogLevel_INFO) {
	char* errorBuffer;
	ts3Functions.getErrorMessage(errorCode, &errorBuffer);
	std::string output = std::string(message) + std::string(" : ") + std::string(errorBuffer);
#ifndef DEBUG_MOD_ENABLED
	if (level != LogLevel_DEVEL && level != LogLevel_DEBUG)
#endif
		ts3Functions.logMessage(output.c_str(), level, "task_force_radio", 141);
	ts3Functions.freeMemory(errorBuffer);
}

bool isConnected(uint64 serverConnectionHandlerID) {
	DWORD error;
	int result;
	if ((error = ts3Functions.getConnectionStatus(serverConnectionHandlerID, &result)) != ERROR_ok) {
		return false;
	}
	return result != 0;
}

CLIENT_DATA* getClientData(uint64 serverConnectionHandlerID, anyID clientID) {
	auto foundClientDatas = serverIdToData.getClientDataByClientID(serverConnectionHandlerID, clientID);
	if (foundClientDatas.empty())
		return nullptr;
	return foundClientDatas.back();//There should really only be one DATA here.. But we cant be sure
}

bool hasClientData(uint64 serverConnectionHandlerID, anyID clientID) {
	bool result = false;
	DWORD time = GetTickCount();
	EnterCriticalSection(&serverDataCriticalSection);
	int currentDataFrame = serverIdToData[serverConnectionHandlerID].currentDataFrame;
	auto foundClientDatas = serverIdToData[serverConnectionHandlerID].nicknameToClientData.getClientDataByClientID(clientID);
	for (CLIENT_DATA* it : foundClientDatas) {
		if (abs(currentDataFrame - it->dataFrame) <= 1) {
			result = true;
			break;
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return result;
}

anyID getMyId(uint64 serverConnectionHandlerID) {
	anyID myID = (anyID) -1;
	if (!isConnected(serverConnectionHandlerID)) return myID;
	DWORD error;
	if ((error = ts3Functions.getClientID(serverConnectionHandlerID, &myID)) != ERROR_ok) {
		log("Failure getting client ID", error);
	}
	return myID;
}

float volumeFromDistance(float distance, bool shouldPlayerHear, int clientDistance, float multiplifer = 1.0f) {
	return helpers::volumeFromDistance(distance, shouldPlayerHear, static_cast<float>(clientDistance), multiplifer);
}

void playWavFile(uint64 serverConnectionHandlerID, const char* fileNameWithoutExtension, float gain, TS3_VECTOR position, bool onGround, int radioVolume, bool underwater, float vehicleVolumeLoss, bool vehicleCheck) {
	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
	if (!isConnected(serverConnectionHandlerID)) return;
	std::string path = std::string(pluginPath);
	std::string to_play = path + std::string(fileNameWithoutExtension) + ".wav";

	clunk::WavFile* wave = NULL;
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData[serverConnectionHandlerID].waves.count(to_play) == 0) {
		FILE *f = fopen(to_play.c_str(), "rb");
		if (f) {
			clunk::WavFile* wav = new clunk::WavFile(f);
			wav->read();
			if (wav->ok() && wav->_spec.channels == 2 && wav->_spec.sample_rate == 48000) {
				serverIdToData[serverConnectionHandlerID].waves[to_play] = wav;
				wave = serverIdToData[serverConnectionHandlerID].waves[to_play];
			}
			fclose(f);
		}
	} else {
		wave = serverIdToData[serverConnectionHandlerID].waves[to_play];
	}
	LeaveCriticalSection(&serverDataCriticalSection);

	if (wave) {
		short* data = static_cast<short*>(wave->_data.get_ptr());
		int samples = static_cast<int>((wave->_data.get_size() / sizeof(short)) / wave->_spec.channels);
		short* input = new short[samples * wave->_spec.channels];

		memcpy(input, data, wave->_data.get_size());
		helpers::applyGain(input, wave->_spec.channels, samples, gain);

		std::string id = to_play + std::to_string(rand());
		anyID me = getMyId(serverConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection);

		if (hasClientData(serverConnectionHandlerID, me)) {
			CLIENT_DATA* clientData = getClientData(serverConnectionHandlerID, me);
			if (clientData) {
				float speakerDistance = (radioVolume / 10.f) * serverIdToData[serverConnectionHandlerID].speakerDistance;
				float distance_from_radio = helpers::distance(clientData->clientPosition, position);

				if (vehicleVolumeLoss > 0.01f && !vehicleCheck) {
					helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(input, wave->_spec.channels, samples, volumeFromDistance(distance_from_radio, true, speakerDistance, 1.0f - vehicleVolumeLoss) * pow(1.0f - vehicleVolumeLoss, 1.2f), clientData->getFilterVehicle(id + "vehicle", vehicleVolumeLoss));
				}
				if (onGround) {
					helpers::applyGain(input, wave->_spec.channels, samples, volumeFromDistance(distance_from_radio, true, speakerDistance));
					helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>(input, wave->_spec.channels, samples, SPEAKER_GAIN, (clientData->getSpeakerFilter(id)));
					if (underwater) {
						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(input, wave->_spec.channels, samples, CANT_SPEAK_GAIN * 50, (clientData->getFilterCantSpeak(id)));
					}
				}
				clientData->getClunk(id)->process(input, wave->_spec.channels, samples, position, clientData->viewAngle);
				clientData->removeClunk(id);
				helpers::applyILD(input, wave->_spec.channels, samples, position, clientData->viewAngle);
			}

		}
		LeaveCriticalSection(&serverDataCriticalSection);
		playbackHandler.appendPlayback(id, serverConnectionHandlerID, input, samples, wave->_spec.channels);
		delete[] input;
	}
}

void playWavFile(const char* fileNameWithoutExtension) {
	if (!isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) return;
	std::string path = std::string(pluginPath);
	DWORD error;
	std::string to_play = path + std::string(fileNameWithoutExtension) + ".wav";

	if ((error = ts3Functions.playWaveFile(ts3Functions.getCurrentServerConnectionHandlerID(), to_play.c_str())) != ERROR_ok) {
		log("can't play sound", error, LogLevel_ERROR);
	}
}




// taken from https://github.com/MadStyleCow/A2TS_Rebuild/blob/master/src/ts3plugin.cpp#L1367
bool hlp_checkVad() {
	char* vad; // Is "true" or "false"
	DWORD error;
	if ((error = ts3Functions.getPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", &vad)) == ERROR_ok) {
		bool result = strcmp(vad, "true") == 0;
		ts3Functions.freeMemory(vad);
		return result;
	} else {
		log("Failed to get VAD value", error);
		return false;
	}
}

void hlp_enableVad() {
	DWORD error;
	if ((error = ts3Functions.setPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", "true")) != ERROR_ok) {
		log("Failed to set VAD value", error);
	}
}

void hlp_disableVad() {
	DWORD error;
	if ((error = ts3Functions.setPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", "false")) != ERROR_ok) {
		log("Failure disabling VAD", error);
	}
}

anyID getClientId(uint64 serverConnectionHandlerID, std::string nickname) {
	anyID clienId = -1;
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnectionHandlerID) && serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(nickname) && serverIdToData[serverConnectionHandlerID].nicknameToClientData[nickname]) {
		clienId = serverIdToData[serverConnectionHandlerID].nicknameToClientData[nickname]->clientId;
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return clienId;
}

const std::string getChannelName(uint64 serverConnectionHandlerID, anyID clientId) {
	if (clientId == anyID(-1)) return "";
	uint64 channelId;
	DWORD error;
	if ((error = ts3Functions.getChannelOfClient(serverConnectionHandlerID, clientId, &channelId)) != ERROR_ok) {
		log("Can't get channel of client", error);
		return "";
	}
	char* channelName;
	if ((error = ts3Functions.getChannelVariableAsString(serverConnectionHandlerID, channelId, CHANNEL_NAME, &channelName)) != ERROR_ok) {
		log("Can't get channel name", error);
		return "";
	}
	const std::string result(channelName);
	ts3Functions.freeMemory(channelName);
	return result;
}

bool isInChannel(uint64 serverConnectionHandlerID, anyID clientId, const char* channelToCheck) {
	return getChannelName(serverConnectionHandlerID, clientId) == channelToCheck;
}

bool isSeriousModeEnabled(uint64 serverConnectionHandlerID, anyID clientId) {
	std::string serious_mod_channel_name = "__unknown__";
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnectionHandlerID)) {
		serious_mod_channel_name = serverIdToData[serverConnectionHandlerID].serious_mod_channel_name;
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	return (serious_mod_channel_name != "") && isInChannel(serverConnectionHandlerID, clientId, serious_mod_channel_name.c_str());
}

void setClientMuteStatus(uint64 serverConnectionHandlerID, anyID clientId, bool status) {
	if (clientId <= 0)
		return;
	anyID clientIds[2];
	clientIds[0] = clientId;
	clientIds[1] = 0;

#ifndef unmuteAllClients
	EnterCriticalSection(&serverDataCriticalSection);
	serverIdToData[serverConnectionHandlerID].mutedClients.push_back(clientId);
	LeaveCriticalSection(&serverDataCriticalSection);
#endif

	DWORD error;
	if (status) {
		if ((error = ts3Functions.requestMuteClients(serverConnectionHandlerID, clientIds, NULL)) != ERROR_ok) {
			log("Can't mute client", error);
		}
	} else {
		if ((error = ts3Functions.requestUnmuteClients(serverConnectionHandlerID, clientIds, NULL)) != ERROR_ok) {
			log("Can't unmute client", error);
		}
	}
}

float distanceForDiverRadio(float distance, uint64 serverConnectionHandlerID) {
	float wavesLevel;
	wavesLevel = serverIdToData.getWavesLevel(serverConnectionHandlerID);
	return DD_MIN_DISTANCE + (DD_MAX_DISTANCE - DD_MIN_DISTANCE) * (1.0f - wavesLevel);
}

float effectErrorFromDistance(OVER_RADIO_TYPE radioType, float distance, uint64 serverConnectionHandlerID, CLIENT_DATA* data) {
	float maxD = 0.0f;
	switch (radioType) {
		case LISTEN_TO_SW: maxD = static_cast<float>(data->range); break;
		case LISTEN_TO_DD: maxD = distanceForDiverRadio(distance, serverConnectionHandlerID); break;
		case LISTEN_TO_LR: maxD = static_cast<float>(data->range);
		default: break;
	};
	return distance / maxD;
}

float effectiveDistance(uint64 serverConnectionHandlerID, CLIENT_DATA* data) {
	CriticalSectionLock lock(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;
	float d = helpers::distance(myPosition, clientPosition);
	// (bob distance player) + (bob call TFAR_fnc_calcTerrainInterception) * 7 + (bob call TFAR_fnc_calcTerrainInterception) * 7 * ((bob distance player) / 2000.0)
	float result = d +
		+(data->terrainInterception * serverIdToData[serverConnectionHandlerID].terrainIntersectionCoefficient)
		+ (data->terrainInterception * serverIdToData[serverConnectionHandlerID].terrainIntersectionCoefficient * d / 2000.0f);
	result *= serverIdToData[serverConnectionHandlerID].receivingDistanceMultiplicator;
	return result;
}

LISTED_INFO isOverLocalRadio(uint64 serverConnectionHandlerID, CLIENT_DATA* senderData, CLIENT_DATA* myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent) {
	LISTED_INFO result;
	result.over = LISTEN_TO_NONE;
	result.volume = 0;
	result.on = LISTED_ON_NONE;
	result.waveZ = 1.0f;
	if (senderData == NULL || myData == NULL) return result;

	CriticalSectionLock lock(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = senderData->clientPosition;

	result.pos.x = result.pos.y = result.pos.z = 0.0f;

	result.radio_id = "local_radio";
	result.vehicle = helpers::getVehicleDescriptor(myData->vehicleId);

	//Sender is sending on a Frequency we are listening to on our LR Radio
	bool senderOnLRFrequency = serverIdToData[serverConnectionHandlerID].myLrFrequencies.count(senderData->frequency) != 0;
	//Sender is sending on a Frequency we are listening to on our SW Radio
	bool senderOnSWFrequency = serverIdToData[serverConnectionHandlerID].mySwFrequencies.count(senderData->frequency) != 0;

	//Receive DD->DD
	if ((senderData->tangentOverType == LISTEN_TO_DD || ignoreDdTangent)	 //#diverRadio
		&& (serverIdToData[serverConnectionHandlerID].myDdFrequency == senderData->frequency)) {
		float dUnderWater = helpers::distance(myPosition, clientPosition);
		if (senderData->canUseDDRadio && myData->canUseDDRadio && dUnderWater < distanceForDiverRadio(dUnderWater, serverConnectionHandlerID)) {
			result.over = LISTEN_TO_DD;
			result.on = LISTED_ON_DD;
			result.volume = serverIdToData[serverConnectionHandlerID].ddVolumeLevel;
			result.stereoMode = 0;
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

	if ((senderData->tangentOverType == LISTEN_TO_SW || ignoreSwTangent) && senderData->canUseSWRadio) {//Sending from SW
		result.over = LISTEN_TO_SW;
	} else if ((senderData->tangentOverType == LISTEN_TO_LR || ignoreLrTangent) && senderData->canUseLRRadio) {//Sending from LR
		result.over = LISTEN_TO_LR;
	} else {
		//He isn't actually sending on anything... 
		return result;
	}

	if (senderOnLRFrequency && myData->canUseLRRadio) {//to our LR
		result.on = LISTED_ON_LR;
		result.volume = serverIdToData[serverConnectionHandlerID].myLrFrequencies[senderData->frequency].volume;
		result.stereoMode = serverIdToData[serverConnectionHandlerID].myLrFrequencies[senderData->frequency].stereoMode;
	} else if (senderOnSWFrequency && myData->canUseSWRadio) {//to our SW
		result.on = LISTED_ON_SW;
		result.volume = serverIdToData[serverConnectionHandlerID].mySwFrequencies[senderData->frequency].volume;
		result.stereoMode = serverIdToData[serverConnectionHandlerID].mySwFrequencies[senderData->frequency].stereoMode;
	}
	return result;
}

std::string getClientNickname(uint64 serverConnectionHandlerID, anyID clientID) {
	CriticalSectionLock lock(&serverDataCriticalSection);
	for (STRING_TO_CLIENT_DATA_MAP::iterator it = serverIdToData[serverConnectionHandlerID].nicknameToClientData.begin();
		it != serverIdToData[serverConnectionHandlerID].nicknameToClientData.end(); it++) {
		if (it->second->clientId == clientID) {
			return it->first;
		}
	}
	return "Unknown nickname";
}

std::vector<LISTED_INFO> isOverRadio(uint64 serverConnectionHandlerID, CLIENT_DATA* senderData, CLIENT_DATA* myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent) {
	std::vector<LISTED_INFO> result;
	if (senderData == NULL || myData == NULL) return result;
	//check if we receive him over a radio we have on us
	if (senderData->clientId != myData->clientId) {
		LISTED_INFO local = isOverLocalRadio(serverConnectionHandlerID, senderData, myData, ignoreSwTangent, ignoreLrTangent, ignoreDdTangent);
		if (local.on != LISTED_ON_NONE && local.over != LISTEN_TO_NONE) {
			result.push_back(local);
		}
	}

	CriticalSectionLock lock(&serverDataCriticalSection);
	float effectiveDistance_ = effectiveDistance(serverConnectionHandlerID, senderData);
	const std::string nickname = getClientNickname(serverConnectionHandlerID, senderData->clientId);
	//check if we receive him over a radio laying on ground
	if (effectiveDistance_ < senderData->range) {//does his range reach to us?
		if (
			(senderData->canUseSWRadio && (senderData->tangentOverType == LISTEN_TO_SW || ignoreSwTangent)) || //Sending over SW
			(senderData->canUseLRRadio && (senderData->tangentOverType == LISTEN_TO_LR || ignoreLrTangent))) { //Sending over LR
			for (std::multimap<std::string, SPEAKER_DATA>::iterator itr = serverIdToData[serverConnectionHandlerID].speakers.begin(); itr != serverIdToData[serverConnectionHandlerID].speakers.end(); ++itr) {
				if ((itr->first == senderData->frequency) && (itr->second.nickname != nickname)) {
					SPEAKER_DATA speaker = itr->second;
					LISTED_INFO info;
					info.on = LISTED_ON_GROUND;
					info.over = (senderData->tangentOverType == LISTEN_TO_SW || ignoreSwTangent) ? LISTEN_TO_SW : LISTEN_TO_LR;
					info.radio_id = speaker.radio_id;
					info.stereoMode = 0;
					info.vehicle = speaker.vehicle;
					info.volume = speaker.volume;
					info.waveZ = speaker.waveZ;
					bool posSet = false;
					if (speaker.pos.size() == 3) {
						info.pos = { speaker.pos[0],speaker.pos[1],speaker.pos[2] };
						posSet = true;
					} else {
						int currentDataFrame = serverIdToData[serverConnectionHandlerID].currentDataFrame;
						if (serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(speaker.nickname)) {
							CLIENT_DATA* clientData = serverIdToData[serverConnectionHandlerID].nicknameToClientData[speaker.nickname];
							if (abs(currentDataFrame - clientData->dataFrame) <= 1) {
								info.pos = clientData->clientPosition;
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
	}
	return result;
}



float distanceFromClient(uint64 serverConnectionHandlerID, CLIENT_DATA* data) {//#TODO replace by just helpers::distance
	EnterCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition; //#TODO add getter fucntion with CriticalSections
	LeaveCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR clientPosition = data->clientPosition;
	float d = helpers::distance(myPosition, clientPosition);
	return d;
}

bool isTalking(uint64 currentServerConnectionHandlerID, anyID myId, anyID playerId) {
	int result = 0;
	DWORD error;
	if (playerId == myId) {
		if ((error = ts3Functions.getClientSelfVariableAsInt(currentServerConnectionHandlerID, CLIENT_FLAG_TALKING, &result)) != ERROR_ok) {
			log("Can't get talking status", error);
		}
	} else {
		if ((error = ts3Functions.getClientVariableAsInt(currentServerConnectionHandlerID, playerId, CLIENT_FLAG_TALKING, &result)) != ERROR_ok) {
			log("Can't get talking status", error);
		}
	}
	return result != 0;
}

void setGameClientMuteStatus(uint64 serverConnectionHandlerID, anyID clientId) {
	bool mute = false;
	if (isSeriousModeEnabled(serverConnectionHandlerID, clientId)) {
		CriticalSectionLock lock(&serverDataCriticalSection);
		CLIENT_DATA* data = hasClientData(serverConnectionHandlerID, clientId) ? getClientData(serverConnectionHandlerID, clientId) : NULL;
		CLIENT_DATA* myData = hasClientData(serverConnectionHandlerID, getMyId(serverConnectionHandlerID))
			? getClientData(serverConnectionHandlerID, getMyId(serverConnectionHandlerID)) : NULL;
		bool alive = false;
		if (data && myData && serverIdToData[serverConnectionHandlerID].alive) {
			std::vector<LISTED_INFO> listedInfo = isOverRadio(serverConnectionHandlerID, data, myData, false, false, false);
			if (listedInfo.size() == 0) {
				bool isTalk = data->clientTalkingNow || isTalking(serverConnectionHandlerID, getMyId(serverConnectionHandlerID), clientId);
				mute = (distanceFromClient(serverConnectionHandlerID, data) > data->voiceVolume) || (!isTalk);
			} else {
				mute = false;
			}
		} else {
			mute = true;
		}
		if (mute) data->resetVoices();
	}
	setClientMuteStatus(serverConnectionHandlerID, clientId, mute);
}

void unmuteAll(uint64 serverConnectionHandlerID) {
	anyID* ids;
	DWORD error;

#ifdef unmuteAllClients
	if ((error = ts3Functions.getClientList(serverConnectionHandlerID, &ids)) != ERROR_ok) {
		log("Error getting all clients from server", error);
		return;
	}
#else
	EnterCriticalSection(&serverDataCriticalSection);
	//copying to keep CriticalSection locked for short time
	//and i have to	copy anyway because the IDArray has to be null-terminated
	std::vector<anyID> mutedClients = serverIdToData[serverConnectionHandlerID].mutedClients;
	LeaveCriticalSection(&serverDataCriticalSection);
	mutedClients.push_back(0);//Null-terminate so we can send it to requestUnmuteClients
	ids = mutedClients.data();
#endif
	//Or add a list of muted clients to server_radio_data and only unmute them and also call unmuteAll as soon as Arma disconnects from TS
	if ((error = ts3Functions.requestUnmuteClients(serverConnectionHandlerID, ids, NULL)) != ERROR_ok) {
		log("Can't unmute all clients", error);
	}
#ifdef unmuteAllClients
	ts3Functions.freeMemory(ids);
#endif
}


std::string getMetaData(anyID clientId) {
	std::string result;
	char* clientInfo;
	DWORD error;
	if ((error = ts3Functions.getClientVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, CLIENT_META_DATA, &clientInfo)) != ERROR_ok) {
		log("Can't get client metadata", error);
		return "";
	} else {
		std::string sharedMsg = clientInfo;
		if (sharedMsg.find(START_DATA) == std::string::npos || sharedMsg.find(END_DATA) == std::string::npos) {
			result = "";
		} else {
			result = sharedMsg.substr(sharedMsg.find(START_DATA) + strlen(START_DATA), sharedMsg.find(END_DATA) - sharedMsg.find(START_DATA) - strlen(START_DATA));
		}
		ts3Functions.freeMemory(clientInfo);
		return result;
	}
}

void setMetaData(std::string data) {
	char* clientInfo;
	DWORD error;
	if ((error = ts3Functions.getClientVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()), CLIENT_META_DATA, &clientInfo)) != ERROR_ok) {
		log("setMetaData - Can't get client metadata", error);
	} else {
		std::string to_set;
		std::string sharedMsg = clientInfo;
		if (sharedMsg.find(START_DATA) == std::string::npos || sharedMsg.find(END_DATA) == std::string::npos) {
			to_set = to_set + START_DATA + data + END_DATA;
		} else {
			std::string before = sharedMsg.substr(0, sharedMsg.find(START_DATA));
			std::string after = sharedMsg.substr(sharedMsg.find(END_DATA) + strlen(END_DATA), std::string::npos);
			to_set = before + START_DATA + data + END_DATA + after;
		}
		if ((error = ts3Functions.setClientSelfVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_META_DATA, to_set.c_str())) != ERROR_ok) {
			log("setMetaData - Can't set own META_DATA", error);
		}
		ts3Functions.freeMemory(clientInfo);
	}
	ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
}

std::string getConnectionStatusInfo(bool pipeConnected, bool inGame, bool includeVersion) {
	std::string result = std::string("[I]Connected[/I] [B]")
		+ (pipeConnected ? "Y" : "N") + "[/B] [I]Play[/I] [B]"
		+ (inGame ? "Y" : "N")
		+ (includeVersion ? std::string("[/B] [I]P:[/I][B]") + PLUGIN_VERSION + "[/B]" : "")
		+ (includeVersion ? std::string("[I] A: [/I][B]") + serverIdToData.getAddonVersion(ts3Functions.getCurrentServerConnectionHandlerID()) + "[/B]" : "");
	return result;
}

void updateUserStatusInfo(bool pluginEnabled) {
	if (!isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) return;
	std::string result;
	if (pluginEnabled)
		result = getConnectionStatusInfo(pipeConnected, inGame, true);
	else
		result = "[B]Task Force Radio Plugin Disabled[/B]";
	setMetaData(result);
}

std::vector<anyID> getChannelClients(uint64 serverConnectionHandlerID, uint64 channelId) {
	std::vector<anyID> result;
	anyID* clients = NULL;
	//int i = 0;
	//anyID* clientsCopy = clients;
	if (ts3Functions.getChannelClientList(serverConnectionHandlerID, channelId, &clients) == ERROR_ok) {
		int i = 0;
		//anyID* clientsCopy = clients;
		while (clients[i]) {
			result.push_back(clients[i]);
			i++;
		}
		ts3Functions.freeMemory(clients);
	}
	return result;
}

uint64 getCurrentChannel(uint64 serverConnectionHandlerID) {
	uint64 channelId;
	DWORD error;
	if ((error = ts3Functions.getChannelOfClient(serverConnectionHandlerID, getMyId(serverConnectionHandlerID), &channelId)) != ERROR_ok) {
		log("Can't get current channel", error);
	}
	return channelId;
}

void setMuteForDeadPlayers(uint64 serverConnectionHandlerID, bool isSeriousModeEnabled) {
	bool alive = false;
	EnterCriticalSection(&serverDataCriticalSection);
	alive = serverIdToData[serverConnectionHandlerID].alive;
	LeaveCriticalSection(&serverDataCriticalSection);
	std::vector<anyID> clientsIds = getChannelClients(serverConnectionHandlerID, getCurrentChannel(serverConnectionHandlerID));
	anyID myId = getMyId(serverConnectionHandlerID);
	for (auto it = clientsIds.begin(); it != clientsIds.end(); it++) {//#FOREACH
		if (!(*it == myId)) {
			if (!hasClientData(serverConnectionHandlerID, *it)) {
				setClientMuteStatus(serverConnectionHandlerID, (*it), alive && isSeriousModeEnabled); // mute not listed client if you alive, and unmute them if not
			}
		}
	}
}

std::string getMyNickname(uint64 serverConnectionHandlerID) {
	char* bufferForNickname;
	DWORD error;
	anyID myId = getMyId(serverConnectionHandlerID);
	if (myId == anyID(-1)) return "";
	if ((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, myId, CLIENT_NICKNAME, &bufferForNickname)) != ERROR_ok) {
		log("Error getting client nickname", error, LogLevel_DEBUG);
		return "";
	}
	std::string result(bufferForNickname);
	ts3Functions.freeMemory(bufferForNickname);
	return result;
}

void onGameEnd(uint64 serverConnectionHandlerID, anyID clientId) {
	log("On Game End");
	DWORD error;
	if (notSeriousChannelId != uint64(-1)) {
		if (getCurrentChannel(serverConnectionHandlerID) != notSeriousChannelId) {
			if ((error = ts3Functions.requestClientMove(serverConnectionHandlerID, clientId, notSeriousChannelId, "", NULL)) != ERROR_ok) {
				log("Can't join back channel", error);
			}
		}
		notSeriousChannelId = uint64(-1);
	}
	unmuteAll(serverConnectionHandlerID);

	EnterCriticalSection(&serverDataCriticalSection);
	auto& data = serverIdToData[serverConnectionHandlerID];
	data.serious_mod_channel_name = "";	   //#TEST does this work? You can see it if it resets
	data.serious_mod_channel_password = "";
	std::string revertNickname = data.myOriginalNickname;
	data.myOriginalNickname = "";
	LeaveCriticalSection(&serverDataCriticalSection);

	if ((error = ts3Functions.setClientSelfVariableAsString(serverConnectionHandlerID, CLIENT_NICKNAME, revertNickname.c_str())) != ERROR_ok) {
		log("Error setting back client nickname", error);
	}
}

void onGameStart(uint64 serverConnectionHandlerID, anyID clientId) {
	log("On Respawn");
	if (isConnected(serverConnectionHandlerID)) {
		uint64 beforeGameChannelId = getCurrentChannel(serverConnectionHandlerID);
		uint64* result;
		DWORD error;

		auto seriousModeChannelInfo = serverIdToData.getSeriousModeChannel(serverConnectionHandlerID);

		if ((error = ts3Functions.getChannelList(serverConnectionHandlerID, &result)) != ERROR_ok) {
			log("Can't get channel list", error);
		} else {
			bool joined = false;
			uint64* iter = result;
			while (*iter && !joined) {
				uint64 channelId = *iter;
				iter++;
				char* channelName;
				if ((error = ts3Functions.getChannelVariableAsString(serverConnectionHandlerID, channelId, CHANNEL_NAME, &channelName)) != ERROR_ok) {
					log("Can't get channel name", error);
				} else {
					if (!strcmp(seriousModeChannelInfo.first.c_str(), channelName)) {
						if ((error = ts3Functions.requestClientMove(serverConnectionHandlerID, clientId, channelId, seriousModeChannelInfo.second.c_str(), nullptr)) != ERROR_ok) {
							log("Can't join channel", error);
						} else {
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


void updateNicknamesList(uint64 serverConnectionHandlerID) {
	std::vector<anyID> clients = getChannelClients(serverConnectionHandlerID, getCurrentChannel(serverConnectionHandlerID));
	DWORD error;
	for (anyID clientId : clients) {
		char* name;
		if ((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, clientId, CLIENT_NICKNAME, &name)) != ERROR_ok) {
			log("Error getting client nickname", error);
			continue;
		} else {
			if (serverIdToData.count(serverConnectionHandlerID)) {
				CriticalSectionLock lock(&serverDataCriticalSection);
				std::string clientNickname(name);
				if (!serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(clientNickname)) {
					serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname] = new CLIENT_DATA();
				}
				CLIENT_DATA* data = serverIdToData[serverConnectionHandlerID].nicknameToClientData[clientNickname];
				data->clientId = clientId;
			}
			ts3Functions.freeMemory(name);
		}
	}
	serverIdToData.setMyNickname(serverConnectionHandlerID, getMyNickname(serverConnectionHandlerID));
}

std::string ts_info(std::string &command) {
	if (command == "SERVER") {
		char* name;
		DWORD error = ts3Functions.getServerVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), VIRTUALSERVER_NAME, &name);
		if (error != ERROR_ok) {
			log("Can't get server name", error, LogLevel_ERROR);
			return "ERROR_GETTING_SERVER_NAME";
		} else {
			std::string result(name);
			ts3Functions.freeMemory(name);
			return result;
		}

	} else if (command == "CHANNEL") {
		return getChannelName(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
	} else if (command == "PING") {
		return "PONG";
	}
	return "FAIL";
}

void processUnitKilled(std::string &name, uint64 &serverConnection) {
	if (serverIdToData.count(serverConnection)) {
		CriticalSectionLock lock(&serverDataCriticalSection);
		if (serverIdToData[serverConnection].nicknameToClientData.count(name)) {
			CLIENT_DATA* clientData = serverIdToData[serverConnection].nicknameToClientData[name];
			if (clientData) {
				clientData->dataFrame = INVALID_DATA_FRAME;
			}
		}
	}
	setMuteForDeadPlayers(serverConnection, isSeriousModeEnabled(serverConnection, getMyId(serverConnection)));
}

std::string processUnitPosition(std::string &nickname, uint64 &serverConnection, TS3_VECTOR position, float viewAngle, bool canSpeak,
	bool canUseSWRadio, bool canUseLRRadio, bool canUseDDRadio, std::string vehicleID, int terrainInterception, float voiceVolume, float currentUnitDrection) {
	DWORD time = GetTickCount();
	anyID myId = getMyId(serverConnection);
	anyID playerId = anyID(-1);
	bool clientTalkingOnRadio = false;
	if (serverIdToData.count(serverConnection)) {
		TS3_VECTOR zero;
		zero.x = zero.y = zero.z = 0.0f;
		if (nickname == serverIdToData.getMyNickname(serverConnection)) {
			CLIENT_DATA* clientData = 0;
			EnterCriticalSection(&serverDataCriticalSection);
			if (serverIdToData[serverConnection].nicknameToClientData.count(nickname))
				clientData = serverIdToData[serverConnection].nicknameToClientData[nickname];

			if (clientData) {
				playerId = myId;
				clientData->clientId = myId;
				clientData->clientPosition = position;
				clientData->positionTime = time;
				clientData->canSpeak = canSpeak;
				clientData->canUseSWRadio = canUseSWRadio;
				clientData->canUseLRRadio = canUseLRRadio;
				clientData->canUseDDRadio = canUseDDRadio;
				clientData->vehicleId = vehicleID;
				clientData->terrainInterception = terrainInterception;
				clientData->dataFrame = serverIdToData[serverConnection].currentDataFrame;
				clientData->viewAngle = viewAngle;
				clientData->voiceVolumeMultiplifier = voiceVolume;
				clientTalkingOnRadio = (clientData->tangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
			}
			serverIdToData[serverConnection].myPosition = position;
			serverIdToData[serverConnection].canSpeak = canSpeak;
			LeaveCriticalSection(&serverDataCriticalSection);
			DWORD error;
			if ((error = ts3Functions.systemset3DListenerAttributes(serverConnection, &zero, NULL, NULL)) != ERROR_ok) {
				log("can't center listener", error);
			}
		} else {
			if (serverIdToData.clientDataCount(serverConnection, nickname) == 0) {
				if (isConnected(serverConnection)) updateNicknamesList(serverConnection);
			}
			EnterCriticalSection(&serverDataCriticalSection);
			if (serverIdToData[serverConnection].nicknameToClientData.count(nickname)) {
				CLIENT_DATA* clientData = serverIdToData[serverConnection].nicknameToClientData[nickname];
				if (clientData) {
					playerId = clientData->clientId;
					clientData->clientPosition = position;
					clientData->positionTime = time;
					clientData->canSpeak = canSpeak;
					clientData->canUseSWRadio = canUseSWRadio;
					clientData->canUseLRRadio = canUseLRRadio;
					clientData->canUseDDRadio = canUseDDRadio;
					clientData->vehicleId = vehicleID;
					clientData->terrainInterception = terrainInterception;
					clientData->dataFrame = serverIdToData[serverConnection].currentDataFrame;
					clientData->voiceVolumeMultiplifier = voiceVolume;
					clientTalkingOnRadio = (clientData->tangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
				}
			}
			if (serverIdToData[serverConnection].nicknameToClientData.count(serverIdToData[serverConnection].getMyNickname())) {
				CLIENT_DATA* myData = serverIdToData[serverConnection].nicknameToClientData[serverIdToData[serverConnection].getMyNickname()];
				myData->viewAngle = currentUnitDrection;
			}
			LeaveCriticalSection(&serverDataCriticalSection);
			if (isConnected(serverConnection)) {
				setGameClientMuteStatus(serverConnection, getClientId(serverConnection, nickname));
				DWORD error;
				if ((error = ts3Functions.channelset3DAttributes(serverConnection, getClientId(serverConnection, nickname), &zero)) != ERROR_ok) {
					log("can't center client", error);
				}
			}

		}
	}

	if (playerId != anyID(-1)) {
		if (isTalking(serverConnection, myId, playerId) || clientTalkingOnRadio) {
			return "SPEAKING";
		}
	}
	return "NOT_SPEAKING";
}

struct PTTDelayArguments {
	std::string commandToBroadcast;
	uint64 currentServerConnectionHandlerID;
	std::string subtype;
	enum class subtypes {
		digital_lr,
		dd,
		digital,
		airborne,
		phone,
		invalid
	};
	static subtypes subtypeToString(const std::string& type) {
		switch (type.length()) {
			case const_strlen("dd"): return subtypes::dd;
			case const_strlen("digital"): return subtypes::digital;
			case const_strlen("airborne"): return subtypes::airborne;
			case const_strlen("digital_lr"): return subtypes::digital_lr;
			case const_strlen("phone"): return subtypes::phone;
			default: return subtypes::invalid;
		}
	}
};

PTTDelayArguments ptt_arguments;

void disableVoiceAndSendCommand(std::string commandToBroadcast, uint64 currentServerConnectionHandlerID, boolean pressed) {
	log_string(commandToBroadcast, LogLevel_DEVEL);
	DWORD error;
	if ((error = ts3Functions.setClientSelfVariableAsInt(currentServerConnectionHandlerID, CLIENT_INPUT_DEACTIVATED, pressed || vadEnabled ? INPUT_ACTIVE : INPUT_DEACTIVATED)) != ERROR_ok) {
		log("Can't active talking by tangent", error);
	}
	error = ts3Functions.flushClientSelfUpdates(currentServerConnectionHandlerID, NULL);
	if (error != ERROR_ok && error != ERROR_ok_no_update) {
		log("Can't flush self updates", error);
	}
	ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, commandToBroadcast.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
}

volatile bool skip_tangent_off = false;
volatile bool waiting_tangent_off = false;

DWORD WINAPI process_tangent_off(LPVOID lpParam) {
	waiting_tangent_off = true;
	if (pttDelay) {
		Sleep(pttDelayMs);
	}
	EnterCriticalSection(&tangentCriticalSection);
	if (!skip_tangent_off) {
		if (vadEnabled)	hlp_enableVad();
		disableVoiceAndSendCommand(ptt_arguments.commandToBroadcast, ptt_arguments.currentServerConnectionHandlerID, false);
		waiting_tangent_off = false;
	} else {
		skip_tangent_off = false;
	}
	LeaveCriticalSection(&tangentCriticalSection);
	return 0;
}

void processSpeakers(std::vector<std::string> tokens, uint64 currentServerConnectionHandlerID) {
	CriticalSectionLock lock(&serverDataCriticalSection);
	serverIdToData[currentServerConnectionHandlerID].speakers.clear();
	if (tokens.size() != 2)
		return;
	std::vector<std::string> speakers = helpers::split(tokens[1], 0xB);
	for (const std::string& speaker : speakers) {
		if (speaker.length() == 0)
			continue;
		SPEAKER_DATA data;
		std::vector<std::string> parts = helpers::split(speaker, 0xA);
		data.radio_id = parts[0];
		std::vector<std::string> freqs = helpers::split(parts[1], '|');
		data.nickname = parts[2];
		std::string coordinates = parts[3];
		data.pos = helpers::coordStringToVector(coordinates);
		data.volume = helpers::parseArmaNumberToInt(parts[4]);
		data.vehicle = helpers::getVehicleDescriptor(parts[5]);
		if (parts.size() > 6)
			data.waveZ = static_cast<float>(std::atof(parts[6].c_str()));
		else
			data.waveZ = 1;
		for (const std::string & freq : freqs) {
			serverIdToData[currentServerConnectionHandlerID].speakers.insert(std::pair<std::string, SPEAKER_DATA>(freq, data));
		}
	}
}

std::string processGameCommand(std::string command) {
	uint64 currentServerConnectionHandlerID = ts3Functions.getCurrentServerConnectionHandlerID();
	std::vector<std::string> tokens = helpers::split(command, '\t'); //may not be used in nickname	
	if (tokens.size() == 2 && tokens[0] == "TS_INFO")
		return ts_info(tokens[1]);
	if (tokens.size() > 2 && tokens[0] == "KILLED") { //#async
		processUnitKilled(tokens[1], currentServerConnectionHandlerID);
		return "DONE";
	} else if (tokens.size() >= 1 && tokens[0] == "SPEAKERS") {	//#async
		processSpeakers(tokens, currentServerConnectionHandlerID);
		return "OK";
	} else if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS") {	 //#async
		ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, command.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
	}
	if (tokens.size() == 4 && tokens[0] == "VERSION") {	  //#async
		EnterCriticalSection(&serverDataCriticalSection);
		serverIdToData[currentServerConnectionHandlerID].addon_version = tokens[1];
		serverIdToData[currentServerConnectionHandlerID].serious_mod_channel_name = tokens[2];
		serverIdToData[currentServerConnectionHandlerID].serious_mod_channel_password = tokens[3];
		serverIdToData[currentServerConnectionHandlerID].currentDataFrame++;
		LeaveCriticalSection(&serverDataCriticalSection);
		return "OK";
	} else if (tokens.size() == 2 && tokens[0] == "TRACK") { //#async
		task_force_radio::trackPiwik(tokens[1]);
	} else if (tokens.size() == 14 && tokens[0] == "POS") {
		//POS nickname x y z viewangle canSpeak canUseSWRadio canUseLRRadio canUseDDRadio vehicleID terrainInterception voiceVolume currentDirection
		TS3_VECTOR position { std::stof(tokens[2]) ,std::stof(tokens[3]) ,std::stof(tokens[4]) };
		return processUnitPosition(tokens[1], currentServerConnectionHandlerID, position, std::stof(tokens[5]),
			helpers::isTrue(tokens[6]), helpers::isTrue(tokens[7]), helpers::isTrue(tokens[8]), helpers::isTrue(tokens[9]), tokens[10], std::stoi(tokens[11]), (float) std::atof(tokens[12].c_str()), (float) std::atof(tokens[13].c_str()));
	} else if (tokens.size() == 5 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" || tokens[0] == "TANGENT_DD")) {	//#async does only return OK
		bool pressed = (tokens[1] == "PRESSED");
		bool longRange = (tokens[0] == "TANGENT_LR");
		bool diverRadio = (tokens[0] == "TANGENT_DD");
		std::string subtype = tokens[4];

		bool changed = false;
		EnterCriticalSection(&serverDataCriticalSection);
		if (serverIdToData.count(currentServerConnectionHandlerID)) {
			changed = (serverIdToData[currentServerConnectionHandlerID].tangentPressed != pressed);
			serverIdToData[currentServerConnectionHandlerID].tangentPressed = pressed;
			if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(serverIdToData[currentServerConnectionHandlerID].getMyNickname())) {
				CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[serverIdToData[currentServerConnectionHandlerID].getMyNickname()];
				if (longRange) clientData->canUseLRRadio = true;
				else if (diverRadio) clientData->canUseDDRadio = true;
				else clientData->canUseSWRadio = true;
				clientData->subtype = subtype;
			}
		}
		LeaveCriticalSection(&serverDataCriticalSection);
		if (changed) {
			std::string commandToBroadcast = command + "\t" + serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].getMyNickname();
			if (pressed) {
				switch (PTTDelayArguments::subtypeToString(subtype)) {
					case PTTDelayArguments::subtypes::digital_lr: playWavFile("radio-sounds/lr/local_start"); break;
					case PTTDelayArguments::subtypes::dd: playWavFile("radio-sounds/dd/local_start"); break;
					case PTTDelayArguments::subtypes::digital: playWavFile("radio-sounds/sw/local_start"); break;
					case PTTDelayArguments::subtypes::airborne: playWavFile("radio-sounds/ab/local_start"); break;
				}
				EnterCriticalSection(&tangentCriticalSection);
				if (!waiting_tangent_off) {
					vadEnabled = hlp_checkVad();
					if (vadEnabled) hlp_disableVad();
					// broadcast info about tangent pressed over all client										
					disableVoiceAndSendCommand(commandToBroadcast, currentServerConnectionHandlerID, pressed);
				} else skip_tangent_off = true;
				LeaveCriticalSection(&tangentCriticalSection);
			} else {
				PTTDelayArguments args;
				args.commandToBroadcast = commandToBroadcast;
				args.currentServerConnectionHandlerID = currentServerConnectionHandlerID;
				args.subtype = subtype;
				ptt_arguments = args;
				switch (ptt_arguments.subtypeToString(ptt_arguments.subtype)) {
					case PTTDelayArguments::subtypes::digital_lr: playWavFile("radio-sounds/lr/local_end"); break;
					case PTTDelayArguments::subtypes::dd: playWavFile("radio-sounds/dd/local_end"); break;
					case PTTDelayArguments::subtypes::digital: playWavFile("radio-sounds/sw/local_end"); break;
					case PTTDelayArguments::subtypes::airborne: playWavFile("radio-sounds/ab/local_end"); break;
				}

				CreateThread(NULL, 0, process_tangent_off, NULL, 0, NULL);

			}
		}
		return "OK";
	} else if (tokens.size() == 14 && tokens[0] == "FREQ") { //#async
		//#async add async send to plugin to radio_pipe and sqf
		serverIdToData.setFreqInfos(currentServerConnectionHandlerID, tokens);
		std::string nickname = tokens[7];
		std::string myNickname = getMyNickname(currentServerConnectionHandlerID);
		if (myNickname != nickname && myNickname.length() > 0 && (nickname != "Error: No unit" && nickname != "Error: No vehicle" && nickname != "any")) {
			DWORD error;
			if ((error = ts3Functions.setClientSelfVariableAsString(currentServerConnectionHandlerID, CLIENT_NICKNAME, nickname.c_str())) != ERROR_ok) {
				log("Error setting client nickname", error);
			} else {
				serverIdToData[currentServerConnectionHandlerID].setMyOriginalNickname(myNickname);
			}
		}
		return "OK";
	} else if (tokens.size() == 2 && tokens[0] == "IS_SPEAKING") {
		std::string nickname = tokens[1];
		EnterCriticalSection(&serverDataCriticalSection);
		anyID playerId = anyID(-1);
		bool clientTalkingOnRadio = false;
		if (serverIdToData.count(currentServerConnectionHandlerID)) {
			if (serverIdToData[currentServerConnectionHandlerID].nicknameToClientData.count(nickname)) {
				CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];
				if (clientData) {
					playerId = clientData->clientId;
					clientTalkingOnRadio = (clientData->tangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
				}
			}
		}
		LeaveCriticalSection(&serverDataCriticalSection);

		if (playerId != anyID(-1)) {
			if (isTalking(currentServerConnectionHandlerID, getMyId(currentServerConnectionHandlerID), playerId) || clientTalkingOnRadio) {
				return "SPEAKING";
			}
		}
		return  "NOT_SPEAKING";
	}
	return "FAIL";
}

void removeExpiredPositions(uint64 serverConnectionHandlerID) {
	DWORD time = GetTickCount();

	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnectionHandlerID)) {
		serverIdToData[serverConnectionHandlerID].nicknameToClientData.removeExpiredPositions(serverIdToData[serverConnectionHandlerID].currentDataFrame);
	}
	LeaveCriticalSection(&serverDataCriticalSection);
}

volatile DWORD lastInGame = GetTickCount();
volatile DWORD lastCheckForExpire = GetTickCount();
volatile DWORD lastInfoUpdate = GetTickCount();

DWORD WINAPI ServiceThread(LPVOID lpParam) {
	while (!exitThread) {
		if (GetTickCount() - lastCheckForExpire > MILLIS_TO_EXPIRE) {
			bool isSerious = isSeriousModeEnabled(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
			removeExpiredPositions(ts3Functions.getCurrentServerConnectionHandlerID());
			if (isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) {
				if (inGame) setMuteForDeadPlayers(ts3Functions.getCurrentServerConnectionHandlerID(), isSerious);
				updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());
			}
#ifndef unmuteAllClients
			EnterCriticalSection(&serverDataCriticalSection);
			serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].sortMutedClients();//Removes duplicates from MutedClients
			LeaveCriticalSection(&serverDataCriticalSection);
#endif
			lastCheckForExpire = GetTickCount();
		}
		if (GetTickCount() - lastInGame > MILLIS_TO_EXPIRE) {
			unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
			InterlockedExchange(&lastInGame, GetTickCount());
			if (inGame) {
				playWavFile("radio-sounds/off");
				EnterCriticalSection(&serverDataCriticalSection);
				serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].alive = false;
				serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].currentDataFrame = INVALID_DATA_FRAME;
				LeaveCriticalSection(&serverDataCriticalSection);
				onGameEnd(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
			}
			inGame = false;
		}
		if (GetTickCount() - lastInfoUpdate > MILLIS_TO_EXPIRE) {
			updateUserStatusInfo(true);
			lastInfoUpdate = GetTickCount();
		}
		Sleep(100);
	}

	return NULL;
}

DWORD WINAPI PipeThread(LPVOID lpParam) {
	HANDLE pipe = INVALID_HANDLE_VALUE;

	DWORD sleep = FAILS_TO_SLEEP;
	while (!exitThread) {
		if (pipe == INVALID_HANDLE_VALUE) pipe = pipe_handler::openPipe();

		DWORD numBytesRead = 0;
		DWORD numBytesAvail = 0;

		if (PeekNamedPipe(pipe, NULL, 0, &numBytesRead, &numBytesAvail, NULL)) {
			if (numBytesAvail > 0) {
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
					if (!pipeConnected) {
						pipeConnected = true;
					}
					std::string result = processGameCommand(command);
					if (!helpers::startsWith("VERSION", command)) {
						InterlockedExchange(&lastInGame, GetTickCount());
						EnterCriticalSection(&serverDataCriticalSection);
						std::string channelName = serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].serious_mod_channel_name;
						LeaveCriticalSection(&serverDataCriticalSection);
						if (!inGame && channelName.length() > 0) {
							playWavFile("radio-sounds/on");
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
					if (pipeConnected) {
						pipeConnected = false;
					}
					Sleep(1000);
					pipe = pipe_handler::openPipe();
				}
			} else sleep--;
		} else {
			if (pipeConnected) {
				pipeConnected = false;
				updateUserStatusInfo(true);
			}
			Sleep(1000);
			pipe = pipe_handler::openPipe();
		}
		if (!sleep) {
			Sleep(1);
			sleep = FAILS_TO_SLEEP;
		}

	}
	CloseHandle(pipe);
	pipe = INVALID_HANDLE_VALUE;
	return NULL;
}

int pttCallback(void *arg, int argc, char **argv, char **azColName) {
	if (argc != 1) return 1;
	if (argv[0] != NULL) {
		std::vector<std::string> v = helpers::split(argv[0], '\n');
		for (auto i = v.begin(); i != v.end(); i++) { //#FOREACH
			if (*i == "delay_ptt=true") {
				pttDelay = true;
			}
			if (i->substr(0, strlen("delay_ptt_msecs")) == "delay_ptt_msecs") {
				std::vector<std::string> values = helpers::split(*i, '=');
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
int ts3plugin_init() {
#ifdef _WIN64
	_set_FMA3_enable(0);
#endif
	if (ts3plugin_apiVersion() > 20) {
		ts3Functions.getPluginPath(pluginPath, PATH_BUFSIZE, pluginID);
	} else {	//Compatibility hack for API version < 21
		typedef  void(*getPluginPath_20)(char* path, size_t maxLen);
		static_cast<getPluginPath_20>(static_cast<void*>(ts3Functions.getPluginPath))(pluginPath, PATH_BUFSIZE); //This is ugly but keeps compatibility
	}

	InitializeCriticalSection(&serverDataCriticalSection);
	InitializeCriticalSection(&tangentCriticalSection);

	exitThread = FALSE;
	if (isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) {
		updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());
	}

	for (int q = 0; q < MAX_CHANNELS; q++) {
		floatsSample[q] = new float[1];
	}
	threadPipeHandle = CreateThread(NULL, 0, PipeThread, NULL, 0, NULL);
	threadService = CreateThread(NULL, 0, ServiceThread, NULL, 0, NULL);
	task_force_radio::createCheckForUpdateThread();

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
	/* Your plugin cleanup code here */
	log("shutdown...");
	if (inGame)
		onGameEnd(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
	exitThread = TRUE;
	Sleep(1000);
	DWORD exitCode;
	BOOL result = GetExitCodeThread(threadPipeHandle, &exitCode);
	if (!result || exitCode == STILL_ACTIVE) {
		log("thread not terminated", LogLevel_CRITICAL);
	}

	result = GetExitCodeThread(threadService, &exitCode);
	if (!result || exitCode == STILL_ACTIVE) {
		log("service thread not terminated", LogLevel_CRITICAL);
	}

	EnterCriticalSection(&serverDataCriticalSection);
	serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].alive = false;
	LeaveCriticalSection(&serverDataCriticalSection);
	pipeConnected = inGame = false;
	updateUserStatusInfo(false);
	threadPipeHandle = threadService = INVALID_HANDLE_VALUE;
	unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
	exitThread = FALSE;

	/* Free pluginID if we registered it */
	if (pluginID) {
		free(pluginID);
		pluginID = NULL;
	}
}

/*
 * Dynamic content shown in the right column in the info frame. Memory for the data string needs to be allocated in this
 * function. The client will call ts3plugin_freeMemory once done with the string to release the allocated memory again.
 * Check the parameter "type" if you want to implement this feature only for specific item types. Set the parameter
 * "data" to NULL to have the client ignore the info data.
 */
void ts3plugin_infoData(uint64 serverConnectionHandlerID, uint64 id, enum PluginItemType type, char** data) {

	if (PLUGIN_CLIENT == type) {
		std::string metaData = getMetaData((anyID) id);
		*data = (char*) malloc(INFODATA_BUFSIZE * sizeof(char));  /* Must be allocated in the plugin! */
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
void ts3plugin_onConnectStatusChangeEvent(uint64 serverConnectionHandlerID, int newStatus, unsigned int errorNumber) {
	/* Some example code following to show how to use the information query functions. */
	unsigned int errorCode;
	if (newStatus == STATUS_CONNECTION_ESTABLISHED) {
		std::string myNickname = getMyNickname(serverConnectionHandlerID);
		serverIdToData.resetAndSetMyNickname(serverConnectionHandlerID, myNickname);

		playbackHandler.addServer(serverConnectionHandlerID);
		updateNicknamesList(serverConnectionHandlerID);

		// Set system 3d settings
		errorCode = ts3Functions.systemset3DSettings(serverConnectionHandlerID, 1.0f, 1.0f);
		if (errorCode != ERROR_ok) {
			log("Failed to set 3d settings", errorCode);
		}
	} else if (newStatus == STATUS_DISCONNECTED) {
		serverIdToData.erase(serverConnectionHandlerID);
	}
}

void ts3plugin_onNewChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 channelParentID) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onChannelMoveEvent(uint64 serverConnectionHandlerID, uint64 channelID, uint64 newChannelParentID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onUpdateChannelEvent(uint64 serverConnectionHandlerID, uint64 channelID) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onUpdateClientEvent(uint64 serverConnectionHandlerID, anyID clientID, anyID invokerID, const char* invokerName, const char* invokerUniqueIdentifier) {
	updateNicknamesList(serverConnectionHandlerID);
}

void ts3plugin_onClientMoveEvent(uint64 serverConnectionHandlerID, anyID clientID, uint64 oldChannelID, uint64 newChannelID, int visibility, const char* moveMessage) {
	updateNicknamesList(serverConnectionHandlerID);
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

bool isPluginEnabledForUser(uint64 serverConnectionHandlerID, anyID clientID) {
	std::string clientInfo = getMetaData(clientID);
	bool result = false;

	std::string shouldStartWith = getConnectionStatusInfo(true, true, false);
	std::string clientStatus = std::string(clientInfo);
	result = helpers::startsWith(shouldStartWith, clientStatus);

	DWORD currentTime = GetTickCount();
	EnterCriticalSection(&serverDataCriticalSection);
	CLIENT_DATA* data = getClientData(serverConnectionHandlerID, clientID);
	if (data) {
		if (result) {
			data->pluginEnabledCheck = currentTime;
		} else {
			if (currentTime - data->pluginEnabledCheck < 10000) {
				result = data->pluginEnabled;
			}
		}
		data->pluginEnabled = result;
	}
	LeaveCriticalSection(&serverDataCriticalSection);

	return result;
}

void processCompressor(chunkware_simple::SimpleComp* compressor, short* samples, int channels, int sampleCount)	 //#TODO move to RadioEffect
{
	if (channels >= 2) {
		for (int q = 0; q < sampleCount; q++) {
			double left = samples[channels * q];
			double right = samples[channels * q + 1];
			compressor->process(left, right);
			samples[channels * q] = static_cast<short>(left);
			samples[channels * q + 1] = static_cast<short>(right);
		}
	}
}

void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
	playbackHandler.onEditMixedPlaybackVoiceDataEvent(serverConnectionHandlerID, samples, sampleCount, channels, channelSpeakerArray, channelFillMask);
}

void ts3plugin_onEditPostProcessVoiceDataEventStereo(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels) {
	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
	static DWORD last_no_info;
	anyID myId = getMyId(serverConnectionHandlerID);
	std::string myNickname = getMyNickname(serverConnectionHandlerID);


	if (serverIdToData.count(serverConnectionHandlerID) == 0) {
		serverIdToData.resetAndSetMyNickname(serverConnectionHandlerID, myNickname);
	}
	EnterCriticalSection(&serverDataCriticalSection);
	bool alive = serverIdToData[serverConnectionHandlerID].alive;
	bool canSpeak = serverIdToData[serverConnectionHandlerID].canSpeak;

	LeaveCriticalSection(&serverDataCriticalSection);

	if (hasClientData(serverConnectionHandlerID, clientID) && hasClientData(serverConnectionHandlerID, myId) && isPluginEnabledForUser(serverConnectionHandlerID, clientID)) {
		if (isSeriousModeEnabled(serverConnectionHandlerID, clientID) && !alive) {
			helpers::applyGain(samples, channels, sampleCount, 0.0f);
		} else {
			CLIENT_DATA* data = getClientData(serverConnectionHandlerID, clientID);
			CLIENT_DATA* myData = getClientData(serverConnectionHandlerID, myId);
			float globalGain = serverIdToData[serverConnectionHandlerID].globalVolume;
			if (data && myData) {
				EnterCriticalSection(&serverDataCriticalSection);
				helpers::applyGain(samples, channels, sampleCount, data->voiceVolumeMultiplifier);
				short* original_buffer = helpers::allocatePool(sampleCount, channels, samples);

				bool shouldPlayerHear = (data->canSpeak && canSpeak);

				std::pair<std::string, float> myVehicleDesriptor = helpers::getVehicleDescriptor(myData->vehicleId);
				std::pair<std::string, float> hisVehicleDesriptor = helpers::getVehicleDescriptor(data->vehicleId);

				const float vehicleVolumeLoss = helpers::clamp(myVehicleDesriptor.second + hisVehicleDesriptor.second, 0.0f, 0.99f);
				bool vehicleCheck = (myVehicleDesriptor.first == hisVehicleDesriptor.first);
				float distanceFromClient_ = distanceFromClient(serverConnectionHandlerID, data);

				if (myId != clientID && distanceFromClient_ <= data->voiceVolume) {
					// process voice
					data->getClunk("voice_clunk")->process(samples, channels, sampleCount, data->clientPosition, myData->viewAngle);
					helpers::applyILD(samples, channels, sampleCount, data->clientPosition, myData->viewAngle);
					if (shouldPlayerHear) {
						if (vehicleVolumeLoss < 0.01 || vehicleCheck) {
							helpers::applyGain(samples, channels, sampleCount, volumeFromDistance(distanceFromClient_, shouldPlayerHear, data->voiceVolume));
						} else {
							helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, volumeFromDistance(distanceFromClient_, shouldPlayerHear, data->voiceVolume, 1.0f - vehicleVolumeLoss) * pow(1.0f - vehicleVolumeLoss, 1.2f), data->getFilterVehicle("local_vehicle", vehicleVolumeLoss));
						}
					} else {
						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, volumeFromDistance(distanceFromClient_, shouldPlayerHear, data->voiceVolume) * CANT_SPEAK_GAIN, (data->getFilterCantSpeak("local_cantspeak")));
					}

				} else {
					memset(samples, 0, channels * sampleCount * sizeof(short));
				}
				// process radio here
				processCompressor(&data->compressor, original_buffer, channels, sampleCount);

				std::vector<LISTED_INFO> listed_info = isOverRadio(serverConnectionHandlerID, data, myData, false, false, false);
				float radioDistance = effectiveDistance(serverConnectionHandlerID, data);

				for (size_t q = 0; q < listed_info.size(); q++) {
					LISTED_INFO& info = listed_info[q];
					short* radio_buffer = helpers::allocatePool(sampleCount, channels, original_buffer);
					float volumeLevel = helpers::volumeMultiplifier(static_cast<float>(info.volume));

					switch (PTTDelayArguments::subtypeToString(data->subtype)) {
						case PTTDelayArguments::subtypes::digital:
							data->getSwRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, serverConnectionHandlerID, data));
							processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, data->getSwRadioEffect(info.radio_id), info.stereoMode);
							break;
						case PTTDelayArguments::subtypes::digital_lr:
						case PTTDelayArguments::subtypes::airborne:
							data->getLrRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, serverConnectionHandlerID, data));
							processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, data->getLrRadioEffect(info.radio_id), info.stereoMode);
							break;
						case PTTDelayArguments::subtypes::dd: {
							float ddVolumeLevel = helpers::volumeMultiplifier(static_cast<float>(serverIdToData[serverConnectionHandlerID].ddVolumeLevel));
							data->getUnderwaterRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, helpers::distance(data->clientPosition, myData->clientPosition), serverConnectionHandlerID, data));
							processRadioEffect(radio_buffer, channels, sampleCount, ddVolumeLevel * 0.6f, data->getUnderwaterRadioEffect(info.radio_id), info.stereoMode);
							break; }
						case  PTTDelayArguments::subtypes::phone:
							helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, volumeLevel * 10.0f, (data->getSpeakerPhone(info.radio_id)));
							break;
						default:
							helpers::applyGain(radio_buffer, channels, sampleCount, 0.0f);
							break;
					}

					if (info.on == LISTED_ON_GROUND) {

						TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
						float distance_from_radio = helpers::distance(myPosition, info.pos);

						const float radioVehicleVolumeLoss = helpers::clamp(myVehicleDesriptor.second + info.vehicle.second, 0.0f, 0.99f);
						bool radioVehicleCheck = (myVehicleDesriptor.first == info.vehicle.first);

						helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, SPEAKER_GAIN, (data->getSpeakerFilter(info.radio_id)));

						float speakerDistance = (info.volume / 10.f) * serverIdToData[serverConnectionHandlerID].speakerDistance;
						if (radioVehicleVolumeLoss < 0.01f || radioVehicleCheck) {
							helpers::applyGain(radio_buffer, channels, sampleCount, volumeFromDistance(distance_from_radio, shouldPlayerHear, speakerDistance));
						} else {
							helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, volumeFromDistance(distance_from_radio, shouldPlayerHear, speakerDistance, 1.0f - radioVehicleVolumeLoss) * pow((1.0f - radioVehicleVolumeLoss), 1.2f), (data->getFilterVehicle(info.radio_id, radioVehicleVolumeLoss)));
						}
						if (info.waveZ < UNDERWATER_LEVEL) {
							helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, CANT_SPEAK_GAIN, (data->getFilterCantSpeak(info.radio_id)));
						}
						data->getClunk(info.radio_id)->process(radio_buffer, channels, sampleCount, info.pos, myData->viewAngle);
						helpers::applyILD(radio_buffer, channels, sampleCount, info.pos, myData->viewAngle);
					}
					helpers::mix(samples, radio_buffer, sampleCount, channels);


					delete[] radio_buffer;
				}

				delete[] original_buffer;

				helpers::applyGain(samples, channels, sampleCount, globalGain);
				LeaveCriticalSection(&serverDataCriticalSection);
			}
		}
	} else {
		if (clientID != myId) {
			if (isSeriousModeEnabled(serverConnectionHandlerID, clientID)) {
				if (alive && inGame && isPluginEnabledForUser(serverConnectionHandlerID, clientID))
					helpers::applyGain(samples, channels, sampleCount, 0.0f); // alive player hears only alive players in serious mode
			}
			if (GetTickCount() - last_no_info > MILLIS_TO_EXPIRE) {
				std::string nickname = getClientNickname(serverConnectionHandlerID, clientID);
				if (!hasClientData(serverConnectionHandlerID, clientID))
					log_string(std::string("No info about ") + std::to_string((long long) clientID) + " " + nickname, LogLevel_DEBUG);
				if (!isPluginEnabledForUser(serverConnectionHandlerID, clientID))
					log_string(std::string("No plugin enabled for ") + std::to_string((long long) clientID) + " " + nickname, LogLevel_DEBUG);
				last_no_info = GetTickCount();
			}
		} else {
			memset(samples, 0, channels * sampleCount * sizeof(short));
		}
	}
}


void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
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

void ts3plugin_onEditCapturedVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, int* edited) {
	if (!inGame)
		return;
	if (*edited & 2) {
		anyID myId = getMyId(serverConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection);

		bool alive = serverIdToData[serverConnectionHandlerID].alive;
		if (hasClientData(serverConnectionHandlerID, myId) && alive) {
			int m = 1;
			if (channels == 1) m = 2;

			short* voice = new short[sampleCount * channels * m];
			memset(voice, 0, sampleCount * channels * m * sizeof(short));
			if (m == 2) {
				for (int q = 0; q < channels * sampleCount; q++)
					for (int g = 0; g < m; g++)
						voice[q * m + g] = samples[q];
			} else {
				for (int q = 0; q < channels * sampleCount; q++)
					voice[q] = samples[q];
			}

			ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, myId, voice, sampleCount, channels * m);
			LeaveCriticalSection(&serverDataCriticalSection);
			playbackHandler.appendPlayback("my_radio_voice", serverConnectionHandlerID, voice, sampleCount, channels * m);
			delete[] voice;
		} else {
			LeaveCriticalSection(&serverDataCriticalSection);
		}
	}
}

void ts3plugin_onCustom3dRolloffCalculationClientEvent(uint64 serverConnectionHandlerID, anyID clientID, float distance, float* volume) {
	*volume = 1.0f;	// custom gain applied
}

/* Clientlib rare */
void ts3plugin_onClientSelfVariableUpdateEvent(uint64 serverConnectionHandlerID, int flag, const char* oldValue, const char* newValue) {
	if (flag == CLIENT_FLAG_TALKING && inGame) {

		std::string one = "1";
		bool start = (one == newValue);
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
		std::string myNickname = getMyNickname(serverId);
		EnterCriticalSection(&serverDataCriticalSection);
		std::string command = "VOLUME\t" + myNickname + "\t" + std::to_string(serverIdToData[serverId].myVoiceVolume) + "\t" + (start ? "true" : "false");
		LeaveCriticalSection(&serverDataCriticalSection);
		ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, command.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
	}
	if (flag == CLIENT_FLAG_TALKING && *newValue == '0' && inGame) {
		uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
		bool set_talk_to_true = false;
		EnterCriticalSection(&serverDataCriticalSection);
		if (serverIdToData[serverConnectionHandlerID].tangentPressed) {
			set_talk_to_true = true;
		}
		LeaveCriticalSection(&serverDataCriticalSection);
		if (set_talk_to_true) {
			//TODO:
			/*DWORD error;
			if ((error = ts3Functions.setClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_DEACTIVATED, INPUT_ACTIVE)) != ERROR_ok) {
				log("Can't active talking by tangent", error);
			}
			error = ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
			if (error != ERROR_ok && error != ERROR_ok_no_update) {
				log("Can't flush self updates", error);
			};*/
		}
	}
}

void processAllTangentRelease(uint64 serverId, std::vector<std::string> &tokens) {
	std::string nickname = tokens[1];
	CriticalSectionLock lock(&serverDataCriticalSection);
	if (serverIdToData.count(serverId) && serverIdToData[serverId].nicknameToClientData.count(nickname)) {
		CLIENT_DATA* clientData = serverIdToData[serverId].nicknameToClientData[nickname];
		if (clientData) {
			clientData->tangentOverType = LISTEN_TO_NONE;
		}
	}
}

void processTangentPress(uint64 serverId, std::vector<std::string> &tokens, std::string &command) {
	DWORD time = GetTickCount();
	bool pressed = (tokens[1] == "PRESSED");
	bool longRange = (tokens[0] == "TANGENT_LR");
	bool diverRadio = (tokens[0] == "TANGENT_DD");
	bool shortRange = !longRange && !diverRadio;
	std::string subtype = tokens[4];
	int range = helpers::parseArmaNumberToInt(tokens[3]);
	std::string nickname = tokens[5];
	std::string frequency = tokens[2];

	boolean playPressed = false;
	boolean playReleased = false;
	anyID myId = getMyId(serverId);
	EnterCriticalSection(&serverDataCriticalSection);
	bool alive = serverIdToData[serverId].alive;

	if (serverIdToData.count(serverId) && serverIdToData[serverId].nicknameToClientData.count(nickname)) {
		CLIENT_DATA* clientData = serverIdToData[serverId].nicknameToClientData[nickname];
		if (clientData) {
			clientData->positionTime = time;
			clientData->pluginEnabled = true;
			clientData->pluginEnabledCheck = time;
			clientData->subtype = subtype;

			if (longRange) clientData->canUseLRRadio = true;
			else if (diverRadio) clientData->canUseDDRadio = true;
			else clientData->canUseSWRadio = true;

			TS3_VECTOR myPosition = serverIdToData[serverId].myPosition;

			log_string(std::string("REMOTE COMMAND ") + command, LogLevel_DEVEL);
			if ((clientData->tangentOverType != LISTEN_TO_NONE) != pressed) {
				playPressed = pressed;
				playReleased = !pressed;
			}
			if (pressed) {
				if (longRange) clientData->tangentOverType = LISTEN_TO_LR;
				else if (diverRadio) clientData->tangentOverType = LISTEN_TO_DD;
				else clientData->tangentOverType = LISTEN_TO_SW;
			} else {
				clientData->tangentOverType = LISTEN_TO_NONE;
			}
			clientData->frequency = frequency;
			clientData->range = range;

			anyID clientId = clientData->clientId;

			if (hasClientData(serverId, clientId)) {
				std::vector<LISTED_INFO> listedInfos = isOverRadio(serverId, clientData, getClientData(serverId, myId), !longRange && !diverRadio, longRange, diverRadio);
				for (LISTED_INFO & listedInfo : listedInfos) {
					CLIENT_DATA* myData = getClientData(serverId, myId);
					std::pair<std::string, float> myVehicleDesriptor = helpers::getVehicleDescriptor(myData->vehicleId);
					const float vehicleVolumeLoss = helpers::clamp(myVehicleDesriptor.second + listedInfo.vehicle.second, 0.0f, 0.99f);
					bool vehicleCheck = (myVehicleDesriptor.first == listedInfo.vehicle.first);

					LeaveCriticalSection(&serverDataCriticalSection);
					float gain = helpers::volumeMultiplifier(static_cast<float>(listedInfo.volume)) * serverIdToData[serverId].globalVolume;
					setGameClientMuteStatus(serverId, clientId);
					if (alive && listedInfo.on != LISTED_ON_NONE) {
						switch (PTTDelayArguments::subtypeToString(subtype)) {
							case PTTDelayArguments::subtypes::digital:
								if (playPressed) playWavFile(serverId, "radio-sounds/sw/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								if (playReleased) playWavFile(serverId, "radio-sounds/sw/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								break;
							case PTTDelayArguments::subtypes::digital_lr:
								if (playPressed) playWavFile(serverId, "radio-sounds/lr/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								if (playReleased) playWavFile(serverId, "radio-sounds/lr/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								break;
							case PTTDelayArguments::subtypes::dd:
								if (playPressed) playWavFile(serverId, "radio-sounds/dd/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								if (playReleased) playWavFile(serverId, "radio-sounds/dd/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								break;
							case PTTDelayArguments::subtypes::airborne:
								if (playPressed) playWavFile(serverId, "radio-sounds/ab/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								if (playReleased) playWavFile(serverId, "radio-sounds/ab/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								break;
						}
					}
					EnterCriticalSection(&serverDataCriticalSection);
				}

				if (playReleased && alive) {
					clientData->resetRadioEffect();
				}
			} else {
				log_string(std::string("MY COMMAND ") + command, LogLevel_DEVEL);
			}
		} else {
			log_string(std::string("PLUGIN COMMAND, BUT NO CLIENT DATA ") + nickname);
		}
	} else {
		log_string(std::string("PLUGIN FROM UNKNOWN NICKNAME ") + nickname);
	}
	LeaveCriticalSection(&serverDataCriticalSection);
}

void processPluginCommand(std::string command) {
	DWORD currentTime = GetTickCount();
	std::vector<std::string> tokens = helpers::split(command, '\t'); // may not be used in nickname
	uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
	if (tokens.size() == 6 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" || tokens[0] == "TANGENT_DD")) {
		processTangentPress(serverId, tokens, command);
	} else if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS") {
		processAllTangentRelease(serverId, tokens);
	} else if (tokens.size() == 4 && tokens[0] == "VOLUME") {
		EnterCriticalSection(&serverDataCriticalSection);
		std::string nickname = tokens[1];
		std::string volume = tokens[2];
		bool start = helpers::isTrue(tokens[3]);
		bool myCommand = (nickname == serverIdToData[serverId].getMyNickname());
		if (serverIdToData.count(serverId) && serverIdToData[serverId].nicknameToClientData.count(nickname) && serverIdToData[serverId].nicknameToClientData[nickname]) {
			auto clientData = serverIdToData[serverId].nicknameToClientData[nickname];
			clientData->voiceVolume = std::stoi(volume.c_str());
			clientData->pluginEnabled = true;
			clientData->pluginEnabledCheck = currentTime;
			clientData->clientTalkingNow = start;
			LeaveCriticalSection(&serverDataCriticalSection);
			if (!myCommand && hasClientData(serverId, serverIdToData[serverId].nicknameToClientData[nickname]->clientId)) {
				setGameClientMuteStatus(serverId, serverIdToData[serverId].nicknameToClientData[nickname]->clientId);
			}
			EnterCriticalSection(&serverDataCriticalSection);
		}
		LeaveCriticalSection(&serverDataCriticalSection);
	} else {
		log_string(std::string("UNKNOWN PLUGIN COMMAND ") + command);
	}
}

void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
	log_string(std::string("ON PLUGIN COMMAND ") + pluginName + " " + pluginCommand, LogLevel_DEVEL);
	if (serverConnectionHandlerID == ts3Functions.getCurrentServerConnectionHandlerID()) {
		if (strncmp(pluginName, PLUGIN_NAME, strlen(PLUGIN_NAME)) == 0) {
			processPluginCommand(std::string(pluginCommand));
		} else {
			log("Plugin command event failure", LogLevel_ERROR);
		}
	} else {
		log("Plugin command unknown ID", LogLevel_ERROR);
	}
}
