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
#include "sqlite3\sqlite3.h"
#include "simpleSource\SimpleComp.h"
#include <wininet.h>

#include "RadioEffect.h"
#include "Clunk.h"
#include <clunk/wav_file.h>


#define RADIO_GAIN_LR 5
#define RADIO_GAIN_DD 15
#define CANT_SPEAK_GAIN 14

#define MAX_CHANNELS  8
static float* floatsSample[MAX_CHANNELS];

#define PLUGIN_API_VERSION 20
//#define PLUGIN_API_VERSION 19

#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe"
//#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe_debug"
#define PLUGIN_NAME "task_force_radio"
#define PLUGIN_NAME_x32 "task_force_radio_win32"
#define PLUGIN_NAME_x64 "task_force_radio_win64"
#define MILLIS_TO_EXPIRE 4000  // 4 seconds without updates of client position to expire

#define DD_MIN_DISTANCE 70
#define DD_MAX_DISTANCE 300

#define UNDERWATER_LEVEL -1.1f

inline float sq(float x) { return x * x; }

float distance(TS3_VECTOR from, TS3_VECTOR to)
{
	return sqrt(sq(from.x - to.x) + sq(from.y - to.y) + sq(from.z - to.z));
}

#define PLUGIN_VERSION "0.9.5gh"
#define CANT_SPEAK_DISTANCE 5

#define PIWIK_URL L"nkey.piwik.pro"
#define UPDATE_URL L"raw.github.com"
#define UPDATE_FILE L"/michail-nikolaev/task-force-arma-3-radio/master/current_version.txt"

#define INVALID_DATA_FRAME 9999

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
	LISTED_ON_NONE,
	LISTED_ON_GROUND
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

std::string piwikUrl;
DWORD WINAPI trackPiwikThread(LPVOID lpParam)
{
	DWORD dwBytes;
	DWORD r = 0;	
	char ch;
	if (!InternetGetConnectedState(&r, 0)) return -1;
	if (r & INTERNET_CONNECTION_OFFLINE) return -1;

	HINTERNET Initialize = InternetOpen(L"TFAR", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
	HINTERNET Connection = InternetConnect(Initialize, PIWIK_URL, INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
	HINTERNET File = HttpOpenRequestA(Connection, NULL, piwikUrl.c_str(), NULL, NULL, NULL, 0, 0);
	if (HttpSendRequest(File, NULL, 0, NULL, 0))
	{
		while (InternetReadFile(File, &ch, 1, &dwBytes))
		{
			if (dwBytes != 1) break;
		}
	}
	InternetCloseHandle(File);
	InternetCloseHandle(Connection);
	InternetCloseHandle(Initialize);
	return 0;
}

void trackPiwik(std::string url)
{
	piwikUrl = url;
	CreateThread(NULL, 0, trackPiwikThread, NULL, 0, NULL);
}


bool isUpdateAvaible() {
	DWORD dwBytes;
	char ch;
	std::string pluginVersion;

	DWORD r = 0;
	if (!InternetGetConnectedState(&r, 0)) return false;
	if (r & INTERNET_CONNECTION_OFFLINE) return false;

	HINTERNET Initialize = InternetOpen(L"TFAR", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
	HINTERNET Connection = InternetConnect(Initialize, UPDATE_URL, INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
	HINTERNET File = HttpOpenRequest(Connection, NULL, UPDATE_FILE, NULL, NULL, NULL, 0, 0);

	if (HttpSendRequest(File, NULL, 0, NULL, 0))
	{
		while (InternetReadFile(File, &ch, 1, &dwBytes))
		{
			if (dwBytes != 1)break;
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
		return pluginVersionI > currentVersionI;
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

	std::map<std::string, PersonalRadioEffect*> swEffects;
	std::map<std::string, LongRangeRadioffect*> lrEffects;
	std::map<std::string, UnderWaterRadioEffect*> ddEffects;
	std::map<std::string, Clunk*> clunks;

	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>*> filtersCantSpeak;
	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>*> filtersVehicle;
	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>*> filtersSpeakers;
	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>*> filtersPhone;
	
	float viewAngle;

	float voiceVolumeMultiplifier;

	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>* getSpeakerPhone(std::string key)
	{
		if (!filtersPhone.count(key))
		{
			filtersPhone[key] = new Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>();
			filtersPhone[key]->setup(2, 48000, 1850, 1550);
		}
		return filtersPhone[key];
	}

	
	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>* getSpeakerFilter(std::string key)
	{
		if (!filtersSpeakers.count(key))
		{
			filtersSpeakers[key] = new Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>();
			filtersSpeakers[key]->setup(2, 48000, 3000, 1500);
		}
		return filtersSpeakers[key];
	}

	PersonalRadioEffect* getSwRadioEffect(std::string key)
	{
		if (!swEffects.count(key))
		{
			swEffects[key] = new PersonalRadioEffect();
		}
		return swEffects[key];
	}

	LongRangeRadioffect* getLrRadioEffect(std::string key)
	{
		if (!lrEffects.count(key))
		{
			lrEffects[key] = new LongRangeRadioffect();
		}
		return lrEffects[key];
	}

	UnderWaterRadioEffect* getUnderwaterRadioEffect(std::string key)
	{
		if (!ddEffects.count(key))
		{
			ddEffects[key] = new UnderWaterRadioEffect();
		}
		return ddEffects[key];
	}

	Clunk* getClunk(std::string key) {
		if (!clunks.count(key))
		{
			clunks[key] = new Clunk();
		}
		return clunks[key];
	}

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>* getFilterCantSpeak(std::string key)
	{
		if (!filtersCantSpeak.count(key)) 
		{
			filtersCantSpeak[key] = new Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>();
			filtersCantSpeak[key]->setup(4, 48000, 100);
		}
		return filtersCantSpeak[key];
	}

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>* getFilterVehicle(std::string key, float vehicleVolumeLoss)
	{
		std::string byKey = key + std::to_string(vehicleVolumeLoss);
		if (!filtersVehicle.count(byKey))
		{
			filtersVehicle[byKey] = new Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>();
			filtersVehicle[byKey]->setup(2, 48000, 20000 * (1.0 - vehicleVolumeLoss) / 4.0);
		}
		return filtersVehicle[byKey];
	}

	chunkware_simple::SimpleComp compressor;
	void resetRadioEffect()
	{
		for (auto it = swEffects.begin(); it != swEffects.end(); ++it) delete it->second;		
		swEffects.clear();
		for (auto it = lrEffects.begin(); it != lrEffects.end(); ++it) delete it->second;		
		lrEffects.clear();
		for (auto it = ddEffects.begin(); it != ddEffects.end(); ++it) delete it->second;
		ddEffects.clear();
		for (auto it = filtersSpeakers.begin(); it != filtersSpeakers.end(); ++it) delete it->second;
		filtersSpeakers.clear();
		for (auto it = filtersPhone.begin(); it != filtersPhone.end(); ++it) delete it->second;
		filtersPhone.clear();		
	}

	void resetVoices() 
	{
		for (auto it = clunks.begin(); it != clunks.end(); ++it) delete it->second;
		clunks.clear();		
		for (auto it = filtersCantSpeak.begin(); it != filtersCantSpeak.end(); ++it) delete it->second;
		filtersCantSpeak.clear();
		for (auto it = filtersVehicle.begin(); it != filtersVehicle.end(); ++it) delete it->second;
		filtersVehicle.clear();
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
		voiceVolumeMultiplifier = 1.0f;

		compressor.setSampleRate(48000);
		compressor.setThresh(65);
		compressor.setRelease(300);
		compressor.setAttack(1);
		compressor.setRatio(0.1);
		compressor.initRuntime();

		resetRadioEffect();
	}
};

typedef std::map<std::string, CLIENT_DATA*> STRING_TO_CLIENT_DATA_MAP;

struct FREQ_SETTINGS
{
	int volume;
	int stereoMode;
};
struct SPEAKER_DATA
{
	std::string radio_id;
	std::string nickname;
	std::vector<float> pos;
	int volume;
	std::pair<std::string, float> vehicle;
	float waveZ;
};

struct LISTED_INFO {
	OVER_RADIO_TYPE over;
	LISTED_ON on;
	int volume;
	int stereoMode;
	std::string radio_id;
	TS3_VECTOR pos;
	float waveZ;
	std::pair<std::string, float> vehicle;	
};


struct SERVER_PLAYBACK
{
	std::map<std::string, std::deque<short>> playback;
};

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
	std::multimap<std::string, SPEAKER_DATA> speakers;
	

	int ddVolumeLevel;
	int myVoiceVolume;
	bool alive;
	bool canSpeak;
	float wavesLevel;
	float terrainIntersectionCoefficient;
	float globalVolume;	
	float receivingDistanceMultiplicator;
	float speakerDistance;

	std::string serious_mod_channel_name;
	std::string serious_mod_channel_password;
	std::string addon_version;

	int currentDataFrame;

	SERVER_RADIO_DATA()
	{
		tangentPressed = false;
		currentDataFrame = INVALID_DATA_FRAME;
		terrainIntersectionCoefficient = 7.0f;
		globalVolume = receivingDistanceMultiplicator = 1.0f;
		speakerDistance = 20.0f;
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

volatile bool pttDelay = false;
volatile long pttDelayMs = 0;

volatile uint64 notSeriousChannelId = uint64(-1);
volatile bool vadEnabled = false;
static char* pluginID = NULL;

CRITICAL_SECTION serverDataCriticalSection;
CRITICAL_SECTION playbackCriticalSection;
SERVER_ID_TO_SERVER_DATA serverIdToData;
std::map<uint64, SERVER_PLAYBACK> serverIdToPlayback;

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
	if ((error = ts3Functions.getConnectionStatus(serverConnectionHandlerID, &result)) != ERROR_ok)
	{
		return false;
	}
	return result != 0;
}

void appendPlayback(std::string name, uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels)
{
	EnterCriticalSection(&playbackCriticalSection);
	if (serverIdToPlayback[serverConnectionHandlerID].playback.count(name) == 0)
	{
		std::deque<short> d;
		serverIdToPlayback[serverConnectionHandlerID].playback[name] = d;
	}
	if (channels == 2)
	{
		for (int q = 0; q < sampleCount * channels; q++)
		{
			serverIdToPlayback[serverConnectionHandlerID].playback[name].push_back(samples[q]);
		}
	}
	else
	{
		for (int q = 0; q < sampleCount * channels; q++)
		{
			serverIdToPlayback[serverConnectionHandlerID].playback[name].push_back(samples[q * 2]);
			serverIdToPlayback[serverConnectionHandlerID].playback[name].push_back(samples[q * 2 + 1]);
		}
	}

	LeaveCriticalSection(&playbackCriticalSection);
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

void applyGain(short * samples, int channels, int sampleCount, float directTalkingVolume)
{
	for (int i = 0; i < sampleCount * channels; i++) samples[i] = (short)(samples[i] * directTalkingVolume);
}


anyID getMyId(uint64 serverConnectionHandlerID)
{
	anyID myID = (anyID)-1;
	if (!isConnected(serverConnectionHandlerID)) return myID;
	DWORD error;
	if ((error = ts3Functions.getClientID(serverConnectionHandlerID, &myID)) != ERROR_ok)
	{
		log("Failure getting client ID", error);
	}
	return myID;
}

template<class T>
void processFilterStereo(short * samples, int channels, int sampleCount, float gain, T* filter)
{
	for (int i = 0; i < sampleCount * channels; i += channels)
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
			floatsSample[j][0] = ((float)to_process[j] / (float)SHRT_MAX);
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
			else newValue = (short)(sample * (SHRT_MAX - 1));
			samples[i + j] = newValue;
		}
	}
}

float volumeFromDistance(uint64 serverConnectionHandlerID, CLIENT_DATA* data, float d, bool shouldPlayerHear, int clientDistance, float multiplifer = 1.0f)
{
	EnterCriticalSection(&serverDataCriticalSection);
	bool canSpeak = data->canSpeak;
	LeaveCriticalSection(&serverDataCriticalSection);

	if (d <= 1.0) return 1.0;
	float maxDistance = shouldPlayerHear ? clientDistance * multiplifer : CANT_SPEAK_DISTANCE;
	float gain = powf(d, -0.3f) * (max(0, (maxDistance - d)) / maxDistance);
	if (gain < 0.001f) return 0.0f; else return min(1.0f, gain);
}


void playWavFile(uint64 serverConnectionHandlerID, const char* fileNameWithoutExtension, float gain, TS3_VECTOR position, bool onGround, int radioVolume, bool underwater, float vehicleVolumeLoss, bool vehicleCheck)
{
	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
	if (!isConnected(serverConnectionHandlerID)) return;
	std::string path = std::string(pluginPath);	
	std::string to_play = path + std::string(fileNameWithoutExtension) + ".wav";

	FILE *f = fopen(to_play.c_str(), "rb");
	if (!f) {
		return;
	}

	clunk::WavFile wav(f);
	wav.read();
	if (wav.ok() && wav._spec.channels == 2 && wav._spec.sample_rate == 48000)
	{
		short* data = (short*)wav._data.get_ptr();
		int samples = (wav._data.get_size() / sizeof(short)) / wav._spec.channels;
		short* input = new short[samples * wav._spec.channels];
		memcpy(input, data, wav._data.get_size());
		applyGain(input, wav._spec.channels, samples, gain);

		std::string id = to_play + std::to_string(rand());
		anyID me = getMyId(serverConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection);

		if (hasClientData(serverConnectionHandlerID, me)) {
			CLIENT_DATA* clientData = getClientData(serverConnectionHandlerID, me);
			if (clientData)
			{
				if (vehicleVolumeLoss > 0.01 && !vehicleCheck)
				{
					processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(input, wav._spec.channels, samples, gain * pow(1.0f - vehicleVolumeLoss, 1.2), clientData->getFilterVehicle(id + "vehicle", vehicleVolumeLoss));
				}				
				if (onGround)
				{
					float speakerDistance = (radioVolume / 10.f) * serverIdToData[serverConnectionHandlerID].speakerDistance;
					float distance_from_radio = distance(clientData->clientPosition, position);					
					applyGain(input, wav._spec.channels, samples, volumeFromDistance(serverConnectionHandlerID, clientData, distance_from_radio, true, speakerDistance));
					processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>(input, wav._spec.channels, samples, 2, (clientData->getSpeakerFilter(id)));					
					if (underwater)
					{
						processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(input, wav._spec.channels, samples, CANT_SPEAK_GAIN * 50, (clientData->getFilterCantSpeak(id)));
					}					
				}
				clientData->getClunk(id)->process(input, wav._spec.channels, samples, position, clientData->viewAngle);
			}

		}
		LeaveCriticalSection(&serverDataCriticalSection);

		appendPlayback(id, serverConnectionHandlerID, input, samples, wav._spec.channels);
		delete input;
	}	

	fclose(f);
}

void playWavFile(const char* fileNameWithoutExtension)
{
	if (!isConnected(ts3Functions.getCurrentServerConnectionHandlerID())) return;
	std::string path = std::string(pluginPath);
	DWORD error;
	std::string to_play = path + std::string(fileNameWithoutExtension) + ".wav";

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
	if ((error = ts3Functions.getPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", &vad)) == ERROR_ok)
	{
		bool result = strcmp(vad, "true") == 0;
		ts3Functions.freeMemory(vad);
		return result;
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
	if ((error = ts3Functions.setPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", "true")) != ERROR_ok)
	{
		log("Failed to set VAD value", error);
	}
}

void hlp_disableVad()
{
	DWORD error;
	if ((error = ts3Functions.setPreProcessorConfigValue(ts3Functions.getCurrentServerConnectionHandlerID(), "vad", "false")) != ERROR_ok)
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
	if (clientIds[0] <= 0)
		return;
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
	case LISTEN_TO_SW: maxD = (float)data->range; break;
	case LISTEN_TO_DD: maxD = distanceForDiverRadio(d, serverConnectionHandlerID); break;
	case LISTEN_TO_LR: maxD = (float)data->range;
	default: break;
	};
	return d / maxD;
}

float effectiveDistance(uint64 serverConnectionHandlerID, CLIENT_DATA* data)
{
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;
	float d = distance(myPosition, clientPosition);
	// (bob distance player) + (bob call TFAR_fnc_calcTerrainInterception) * 7 + (bob call TFAR_fnc_calcTerrainInterception) * 7 * ((bob distance player) / 2000.0)
	float result = d +
		+(data->terrainInterception * serverIdToData[serverConnectionHandlerID].terrainIntersectionCoefficient)
		+ (data->terrainInterception * serverIdToData[serverConnectionHandlerID].terrainIntersectionCoefficient * d / 2000.0f);
	result *= serverIdToData[serverConnectionHandlerID].receivingDistanceMultiplicator;
	return result;
}

std::pair<std::string, float> getVehicleDescriptor(std::string vechicleId) {
	std::pair<std::string, float> result;
	result.first == ""; // hear vehicle
	result.second = 0.0f; // hear 

	if (vechicleId.find("_turnout") != std::string::npos) {
		result.first = vechicleId.substr(0, vechicleId.find("_turnout"));
	}
	else {
		if (vechicleId.find_last_of("_") != std::string::npos)
		{
			result.first = vechicleId.substr(0, vechicleId.find_last_of("_"));
			result.second = std::stof(vechicleId.substr(vechicleId.find_last_of("_") + 1));
		}
		else
		{
			result.first = vechicleId;
		}
	}
	return result;
}

LISTED_INFO isOverLocalRadio(uint64 serverConnectionHandlerID, CLIENT_DATA* data, CLIENT_DATA* myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent)
{
	LISTED_INFO result;
	result.over = LISTEN_TO_NONE;
	result.volume = 0;
	result.on = LISTED_ON_NONE;	
	result.waveZ = 1.0f;
	if (data == NULL || myData == NULL) return result;

	EnterCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;

	result.pos.x = result.pos.y = result.pos.z = 0.0f;	

	result.radio_id = "local_radio";
	result.vehicle = getVehicleDescriptor(myData->vehicleId);	

	float d = effectiveDistance(serverConnectionHandlerID, data);

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
		float dUnderWater = distance(myPosition, clientPosition);
		if (data->canUseDDRadio && myData->canUseDDRadio && dUnderWater < distanceForDiverRadio(dUnderWater, serverConnectionHandlerID))
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

std::vector<LISTED_INFO> isOverRadio(uint64 serverConnectionHandlerID, CLIENT_DATA* data, CLIENT_DATA* myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent)
{
	std::vector<LISTED_INFO> result;
	if (data == NULL || myData == NULL) return result;
	if (data->clientId != myData->clientId)
	{
		LISTED_INFO local = isOverLocalRadio(serverConnectionHandlerID, data, myData, ignoreSwTangent, ignoreLrTangent, ignoreDdTangent);
		if ((local.on != LISTED_ON_NONE) && (local.on != LISTEN_TO_NONE))
		{
			result.push_back(local);
		}
	}	

	EnterCriticalSection(&serverDataCriticalSection);
	TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;
	TS3_VECTOR clientPosition = data->clientPosition;
	float d = effectiveDistance(serverConnectionHandlerID, data);
	std::string nickname = getClientNickname(serverConnectionHandlerID, data->clientId);
	
	if (d < data->range)
	{
		if ((data->canUseSWRadio && (data->tangentOverType == LISTEN_TO_SW || ignoreSwTangent)) || (data->canUseLRRadio && (data->tangentOverType == LISTEN_TO_LR || ignoreLrTangent)))
		{
			for (std::multimap<std::string, SPEAKER_DATA>::iterator itr = serverIdToData[serverConnectionHandlerID].speakers.begin(); itr != serverIdToData[serverConnectionHandlerID].speakers.end(); ++itr) {
				if ((itr->first == data->frequency) && (itr->second.nickname != nickname))
				{
					SPEAKER_DATA speaker = itr->second;
					LISTED_INFO info;
					info.on = LISTED_ON_GROUND;
					info.over = (data->tangentOverType == LISTEN_TO_SW || ignoreSwTangent) ? LISTEN_TO_SW : LISTEN_TO_LR;
					info.radio_id = speaker.radio_id;					
					info.stereoMode = 0;					
					info.vehicle = speaker.vehicle;
					info.volume = speaker.volume;	
					info.waveZ = speaker.waveZ;
					bool posSet = false;
					if (speaker.pos.size() == 3)
					{
						info.pos.x = speaker.pos[0];
						info.pos.y = speaker.pos[1];
						info.pos.z = speaker.pos[2];
						posSet = true;
					} 
					else
					{
						int currentDataFrame = serverIdToData[serverConnectionHandlerID].currentDataFrame;
						if (serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(speaker.nickname))
						{							
							CLIENT_DATA* clientData = serverIdToData[serverConnectionHandlerID].nicknameToClientData[speaker.nickname];
							if (abs(currentDataFrame - clientData->dataFrame) <= 1)
							{
								info.pos = clientData->clientPosition;
								posSet = true;
							}
						}						
					}
					if (posSet)
					{
						result.push_back(info);
					}
				}
			}
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
			std::vector<LISTED_INFO> listedInfo = isOverRadio(serverConnectionHandlerID, data, myData, false, false, false);
			if (listedInfo.size() == 0)
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
		if (mute) data->resetVoices();
		LeaveCriticalSection(&serverDataCriticalSection);
	}
	setClientMuteStatus(serverConnectionHandlerID, clientId, mute);
}

void unmuteAll(uint64 serverConnectionHandlerID)
{
	anyID* ids;
	DWORD error;
	if ((error = ts3Functions.getClientList(serverConnectionHandlerID, &ids)) != ERROR_ok)
	{
		log("Error getting all clients from server", error);
		return;
	}

	if ((error = ts3Functions.requestUnmuteClients(serverConnectionHandlerID, ids, NULL)) != ERROR_ok)
	{
		log("Can't unmute all clients", error);
	}
	ts3Functions.freeMemory(ids);
}

#define START_DATA "<TFAR>"
#define END_DATA "</TFAR>"

std::string getMetaData(anyID clientId)  {
	std::string result;
	char* clientInfo;
	DWORD error;
	if ((error = ts3Functions.getClientVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), clientId, CLIENT_META_DATA, &clientInfo)) != ERROR_ok) {
		log("Can't get client metadata", error);
		return "";
	}
	else
	{
		std::string sharedMsg = clientInfo;
		if (sharedMsg.find(START_DATA) == std::string::npos || sharedMsg.find(END_DATA) == std::string::npos)
		{
			result = "";
		}
		else
		{
			result = sharedMsg.substr(sharedMsg.find(START_DATA) + strlen(START_DATA), sharedMsg.find(END_DATA) - sharedMsg.find(START_DATA) - strlen(START_DATA));
		}
		ts3Functions.freeMemory(clientInfo);
		return result;
	}
}

void setMetaData(std::string data)
{
	char* clientInfo;
	DWORD error;
	if ((error = ts3Functions.getClientVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()), CLIENT_META_DATA, &clientInfo)) != ERROR_ok) {
		log("setMetaData - Can't get client metadata", error);
	}
	else
	{
		std::string to_set;
		std::string sharedMsg = clientInfo;
		if (sharedMsg.find(START_DATA) == std::string::npos || sharedMsg.find(END_DATA) == std::string::npos)
		{
			to_set = to_set + START_DATA + data + END_DATA;
		}
		else
		{
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
	std::string result;
	if (pluginEnabled)
		result = getConnectionStatusInfo(pipeConnected, inGame, true);
	else
		result = "[B]Task Force Radio Plugin Disabled[/B]";
	setMetaData(result);
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

std::string getMyNickname(uint64 serverConnectionHandlerID)
{
	char* bufferForNickname;
	DWORD error;
	anyID myId = getMyId(serverConnectionHandlerID);
	if (myId == (anyID)-1) return "";
	if ((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, myId, CLIENT_NICKNAME, &bufferForNickname)) != ERROR_ok) {
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

	if ((error = ts3Functions.setClientSelfVariableAsString(serverConnectionHandlerID, CLIENT_NICKNAME, revertNickname.c_str())) != ERROR_ok) {
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
		if ((error = ts3Functions.getClientVariableAsString(serverConnectionHandlerID, clientId, CLIENT_NICKNAME, &name)) != ERROR_ok) {
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

std::string ts_info(std::string &command)
{
	if (command == "SERVER")
	{
		char* name;
		DWORD error = ts3Functions.getServerVariableAsString(ts3Functions.getCurrentServerConnectionHandlerID(), VIRTUALSERVER_NAME, &name);
		if (error != ERROR_ok) {
			log("Can't get server name", error, LogLevel_ERROR);
			return "ERROR_GETTING_SERVER_NAME";
		}
		else {
			std::string result(name);
			ts3Functions.freeMemory(name);
			return result;
		}

	}
	else if (command == "CHANNEL")
	{
		return getChannelName(ts3Functions.getCurrentServerConnectionHandlerID(), getMyId(ts3Functions.getCurrentServerConnectionHandlerID()));
	}
	else if (command == "PING")
	{
		return "PONG";
	}
	return "FAIL";
}

void processUnitKilled(std::string &name, uint64 &serverConnection)
{
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverConnection))
	{
		if (serverIdToData[serverConnection].nicknameToClientData.count(name))
		{
			CLIENT_DATA* clientData = serverIdToData[serverConnection].nicknameToClientData[name];
			if (clientData)
			{
				clientData->dataFrame = INVALID_DATA_FRAME;
			}
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	setMuteForDeadPlayers(serverConnection, isSeriousModeEnabled(serverConnection, getMyId(serverConnection)));
}

std::string processUnitPosition(std::string &nickname, uint64 &serverConnection, TS3_VECTOR position, float viewAngle, bool canSpeak,
	bool canUseSWRadio, bool canUseLRRadio, bool canUseDDRadio, std::string vehicleID, int terrainInterception, float voiceVolume, float currentUnitDrection)
{
	DWORD time = GetTickCount();
	anyID myId = getMyId(serverConnection);
	EnterCriticalSection(&serverDataCriticalSection);
	anyID playerId = anyID(-1);
	bool clientTalkingOnRadio = false;
	if (serverIdToData.count(serverConnection))
	{
		TS3_VECTOR zero;
		zero.x = zero.y = zero.z = 0.0f;		
		if (nickname == serverIdToData[serverConnection].myNickname)
		{			
			CLIENT_DATA* clientData = NULL;
			if (serverIdToData[serverConnection].nicknameToClientData.count(nickname))
				clientData = serverIdToData[serverConnection].nicknameToClientData[nickname];

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
			if ((error = ts3Functions.systemset3DListenerAttributes(serverConnection, &zero, NULL, NULL)) != ERROR_ok)
			{
				log("can't center listener", error);
			}
			EnterCriticalSection(&serverDataCriticalSection);
		}
		else
		{
			if (!serverIdToData[serverConnection].nicknameToClientData.count(nickname))
			{
				LeaveCriticalSection(&serverDataCriticalSection);
				if (isConnected(serverConnection)) updateNicknamesList(serverConnection);
				EnterCriticalSection(&serverDataCriticalSection);
			}
			if (serverIdToData[serverConnection].nicknameToClientData.count(nickname))
			{
				CLIENT_DATA* clientData = serverIdToData[serverConnection].nicknameToClientData[nickname];
				if (clientData)
				{
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
			if (serverIdToData[serverConnection].nicknameToClientData.count(serverIdToData[serverConnection].myNickname))
			{
				CLIENT_DATA* myData = serverIdToData[serverConnection].nicknameToClientData[serverIdToData[serverConnection].myNickname];
				myData->viewAngle = currentUnitDrection;
			}
			LeaveCriticalSection(&serverDataCriticalSection);
			if (isConnected(serverConnection))
			{
				setGameClientMuteStatus(serverConnection, getClientId(serverConnection, nickname));
				DWORD error;
				if ((error = ts3Functions.channelset3DAttributes(serverConnection, getClientId(serverConnection, nickname), &zero)) != ERROR_ok)
				{
					log("can't center client", error);
				}
			}
			EnterCriticalSection(&serverDataCriticalSection);
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);

	if (playerId != anyID(-1)) {
		if (isTalking(serverConnection, myId, playerId) || clientTalkingOnRadio) {
			return "SPEAKING";
		}
	}
	return "NOT_SPEAKING";
}

struct PTTDelayArguments
{
	std::string commandToBroadcast;
	uint64 currentServerConnectionHandlerID;
	std::string subtype;
};

PTTDelayArguments ptt_arguments;

void disableVoiceAndSendCommand(std::string commandToBroadcast, uint64 currentServerConnectionHandlerID, boolean pressed)
{
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

DWORD WINAPI process_tangent_off(LPVOID lpParam)
{
	waiting_tangent_off = true;
	if (pttDelay) 
	{
		Sleep(pttDelayMs);
	}
	if (!skip_tangent_off)
	{
		if (vadEnabled)	hlp_enableVad();
		disableVoiceAndSendCommand(ptt_arguments.commandToBroadcast, ptt_arguments.currentServerConnectionHandlerID, false);
	}
	else
	{
		skip_tangent_off = false;
	}
	waiting_tangent_off = false;
	return 0;
}

void processSpeakers(std::vector<std::string> tokens, uint64 currentServerConnectionHandlerID)
{
	EnterCriticalSection(&serverDataCriticalSection);
	serverIdToData[currentServerConnectionHandlerID].speakers.clear();
	if (tokens.size() == 2)
	{		
		std::vector<std::string> speakers = split(tokens[1], 0xB);
		for (size_t q = 0; q < speakers.size(); q++)
		{
			if (speakers[q].length() > 0)
			{
				SPEAKER_DATA data;
				std::vector<std::string> parts = split(speakers[q], 0xA);
				data.radio_id = parts[0];
				std::vector<std::string> freqs = split(parts[1], '|');
				data.nickname = parts[2];
				std::string coordinates = parts[3];				
				if (coordinates.length() > 2)
				{
					std::vector<std::string> c = split(coordinates.substr(1, coordinates.length() - 2), ',');
					for (int q = 0; q < 3; q++)
						data.pos.push_back((float)std::atof(c[q].c_str()));
					
				}
				data.volume = std::atoi(parts[4].c_str());
				data.vehicle = getVehicleDescriptor(parts[5]);
				if (parts.size() > 6)
					data.waveZ = (float)std::atof(parts[6].c_str());
				else
					data.waveZ = 1;
				for (size_t q = 0; q < freqs.size(); q++)
				{
					serverIdToData[currentServerConnectionHandlerID].speakers.insert(std::pair<std::string, SPEAKER_DATA>(freqs[q], data));
				}
			}			
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
	
}

std::string processGameCommand(std::string command)
{
	uint64 currentServerConnectionHandlerID = ts3Functions.getCurrentServerConnectionHandlerID();
	std::vector<std::string> tokens = split(command, '\t'); //may not be used in nickname	
	if (tokens.size() == 2 && tokens[0] == "TS_INFO")
		return ts_info(tokens[0]);
	if (tokens.size() > 2 && tokens[0] == "KILLED")
	{
		processUnitKilled(tokens[1], currentServerConnectionHandlerID);
		return "DONE";
	}
	else if (tokens.size() >= 1 && tokens[0] == "SPEAKERS")
	{
		processSpeakers(tokens, currentServerConnectionHandlerID);
		return "OK";
	}
	else if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS")
	{
		ts3Functions.sendPluginCommand(ts3Functions.getCurrentServerConnectionHandlerID(), pluginID, command.c_str(), PluginCommandTarget_CURRENT_CHANNEL, NULL, NULL);
	}
	if (tokens.size() == 4 && tokens[0] == "VERSION")
	{
		EnterCriticalSection(&serverDataCriticalSection);
		serverIdToData[currentServerConnectionHandlerID].addon_version = tokens[1];
		serverIdToData[currentServerConnectionHandlerID].serious_mod_channel_name = tokens[2];
		serverIdToData[currentServerConnectionHandlerID].serious_mod_channel_password = tokens[3];
		serverIdToData[currentServerConnectionHandlerID].currentDataFrame++;
		LeaveCriticalSection(&serverDataCriticalSection);
		return "OK";
	}
	else if (tokens.size() == 2 && tokens[0] == "TRACK")
	{
		trackPiwik(tokens[1]);
	}
	else if (tokens.size() == 14 && tokens[0] == "POS")
	{
		TS3_VECTOR position;
		position.x = std::stof(tokens[2]); // x
		position.y = std::stof(tokens[3]); // y
		position.z = std::stof(tokens[4]); // z
		return processUnitPosition(tokens[1], currentServerConnectionHandlerID, position, std::stof(tokens[5]),
			isTrue(tokens[6]), isTrue(tokens[7]), isTrue(tokens[8]), isTrue(tokens[9]), tokens[10], std::stoi(tokens[11]), (float)std::atof(tokens[12].c_str()), (float)std::atof(tokens[13].c_str()));
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
			std::string commandToBroadcast = command + "\t" + serverIdToData[ts3Functions.getCurrentServerConnectionHandlerID()].myNickname;
			if (pressed)
			{
				if (subtype == "digital_lr") playWavFile("radio-sounds/lr/local_start");
				else if (subtype == "dd") playWavFile("radio-sounds/dd/local_start");
				else if (subtype == "digital") playWavFile("radio-sounds/sw/local_start");
				else if (subtype == "airborne") playWavFile("radio-sounds/ab/local_start");
				if (!waiting_tangent_off)
				{
					vadEnabled = hlp_checkVad();
					if (vadEnabled) hlp_disableVad();
					// broadcast info about tangent pressed over all client										
					disableVoiceAndSendCommand(commandToBroadcast, currentServerConnectionHandlerID, pressed);
				}
				else skip_tangent_off = true;
			}
			else
			{
				if (ptt_arguments.subtype == "digital_lr") playWavFile("radio-sounds/lr/local_end");
				else if (ptt_arguments.subtype == "dd") playWavFile("radio-sounds/dd/local_end");
				else if (ptt_arguments.subtype == "digital") playWavFile("radio-sounds/sw/local_end");
				else if (ptt_arguments.subtype == "airborne") playWavFile("radio-sounds/ab/local_end");

				PTTDelayArguments args;
				args.commandToBroadcast = commandToBroadcast;
				args.currentServerConnectionHandlerID = currentServerConnectionHandlerID;
				args.subtype = subtype;
				ptt_arguments = args;				
				CreateThread(NULL, 0, process_tangent_off, NULL, 0, NULL);
					
			}			
		}
		return "OK";
	}
	else if (tokens.size() == 14 && tokens[0] == "FREQ")
	{
		EnterCriticalSection(&serverDataCriticalSection);
		if (serverIdToData.count(currentServerConnectionHandlerID))
		{
			serverIdToData[currentServerConnectionHandlerID].mySwFrequencies = parseFrequencies(tokens[1]);
			serverIdToData[currentServerConnectionHandlerID].myLrFrequencies = parseFrequencies(tokens[2]);
			serverIdToData[currentServerConnectionHandlerID].myDdFrequency = tokens[3];
			serverIdToData[currentServerConnectionHandlerID].alive = tokens[4] == "true";
			serverIdToData[currentServerConnectionHandlerID].myVoiceVolume = std::atoi(tokens[5].c_str());
			serverIdToData[currentServerConnectionHandlerID].ddVolumeLevel = (int)std::atof(tokens[6].c_str());
			serverIdToData[currentServerConnectionHandlerID].wavesLevel = (float)std::atof(tokens[8].c_str());
			serverIdToData[currentServerConnectionHandlerID].terrainIntersectionCoefficient = (float)std::atof(tokens[9].c_str());
			serverIdToData[currentServerConnectionHandlerID].globalVolume = (float)std::atof(tokens[10].c_str());			
			serverIdToData[currentServerConnectionHandlerID].receivingDistanceMultiplicator = (float)std::atof(tokens[12].c_str());
			serverIdToData[currentServerConnectionHandlerID].speakerDistance = (float)std::atof(tokens[13].c_str());

		}
		std::string nickname = tokens[7];
		LeaveCriticalSection(&serverDataCriticalSection);
		std::string myNickname = getMyNickname(currentServerConnectionHandlerID);
		if (myNickname != nickname && myNickname.length() > 0 && (nickname != "Error: No unit" && nickname != "Error: No vehicle"))
		{
			DWORD error;
			if ((error = ts3Functions.setClientSelfVariableAsString(currentServerConnectionHandlerID, CLIENT_NICKNAME, nickname.c_str())) != ERROR_ok) {
				log("Error setting client nickname", error);
			}
			else {
				EnterCriticalSection(&serverDataCriticalSection);
				serverIdToData[currentServerConnectionHandlerID].myOriginalNickname = myNickname;
				LeaveCriticalSection(&serverDataCriticalSection);
			}
		}
		return "OK";
	}
	else if (tokens.size() == 2 && tokens[0] == "IS_SPEAKING")
	{
		std::string nickname = tokens[1];
		EnterCriticalSection(&serverDataCriticalSection);
		anyID playerId = anyID(-1);
		bool clientTalkingOnRadio = false;
		if (serverIdToData.count(currentServerConnectionHandlerID))
		{
			CLIENT_DATA* clientData = serverIdToData[currentServerConnectionHandlerID].nicknameToClientData[nickname];
			if (clientData)
			{
				playerId = clientData->clientId;
				clientTalkingOnRadio = (clientData->tangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
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

DWORD WINAPI UpdateThread(LPVOID lpParam)
{
	if (isUpdateAvaible())
	{
		MessageBox(NULL, L"New version of Task Force Arrowhead Radio is available. Check radio.task-force.ru/en", L"Task Force Arrowhead Radio Update", MB_OK);
	}
	return 0;
}

DWORD WINAPI ServiceThread(LPVOID lpParam)
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
				unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
			}
			InterlockedExchange(&lastInGame, GetTickCount());
			if (inGame)
			{
				playWavFile("radio-sounds/off");
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

#define FAILS_TO_SLEEP 50
DWORD WINAPI PipeThread(LPVOID lpParam)
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
					if (WriteFile(pipe, output, (DWORD)result.length() + 1, &written, NULL)) {
						log_string("Info to ARMA send", LogLevel_DEBUG);
					}
					else {
						log_string("Can't send info to ARMA", LogLevel_ERROR);
					}
				}
				else {
					if (pipeConnected)
					{
						pipeConnected = false;
					}
					Sleep(1000);
					pipe = openPipe();
				}
			}
			else sleep--;
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


int pttCallback(void *arg, int argc, char **argv, char **azColName)
{
	if (argc != 1) return 1;

	std::vector<std::string> v = split(argv[0], '\n');
	
	for (auto i = v.begin(); i != v.end(); i++)
	{
		if (*i == "delay_ptt=true")
		{
			pttDelay = true;
		}
		if (i->substr(0, strlen("delay_ptt_msecs")) == "delay_ptt_msecs")
		{
			std::vector<std::string> values = split(*i, '=');
			pttDelayMs = std::stoi(values[1]);
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
	ts3Functions.getPluginPath(pluginPath, PATH_BUFSIZE);

	InitializeCriticalSection(&serverDataCriticalSection);
	InitializeCriticalSection(&playbackCriticalSection);

	exitThread = FALSE;
	if (isConnected(ts3Functions.getCurrentServerConnectionHandlerID()))
	{
		updateNicknamesList(ts3Functions.getCurrentServerConnectionHandlerID());
	}

	for (int q = 0; q < MAX_CHANNELS; q++)
	{
		floatsSample[q] = new float[1];
	}
	thread = CreateThread(NULL, 0, PipeThread, NULL, 0, NULL);
	threadService = CreateThread(NULL, 0, ServiceThread, NULL, 0, NULL);
	CreateThread(NULL, 0, UpdateThread, NULL, 0, NULL);

	char path[MAX_PATH];
	ts3Functions.getConfigPath(path, MAX_PATH);
	strcat_s(path, MAX_PATH, "settings.db");		

	sqlite3 *db = 0;
	char *err = 0;
	if (!sqlite3_open(path, &db))
	{
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
	unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
	exitThread = FALSE;

	/* Free pluginID if we registered it */
	if (pluginID) {
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
	char* result = (char*)malloc(maxLen * sizeof(char));
	memset(result, 0, maxLen);
	strncpy_s(result, maxLen, info.c_str(), info.length());
	return (const char*)result;
}

/*
 * Dynamic content shown in the right column in the info frame. Memory for the data string needs to be allocated in this
 * function. The client will call ts3plugin_freeMemory once done with the string to release the allocated memory again.
 * Check the parameter "type" if you want to implement this feature only for specific item types. Set the parameter
 * "data" to NULL to have the client ignore the info data.
 */
void ts3plugin_infoData(uint64 serverConnectionHandlerID, uint64 id, enum PluginItemType type, char** data) {

	if (PLUGIN_CLIENT == type)
	{
		std::string metaData = getMetaData((anyID)id);
		*data = (char*)malloc(INFODATA_BUFSIZE * sizeof(char));  /* Must be allocated in the plugin! */
		snprintf(*data, INFODATA_BUFSIZE, "%s", metaData.c_str());  /* bbCode is supported. HTML is not supported */
	}
	else
	{
		*data = NULL;
	}
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

/************************** TeamSpeak callbacks ***************************/
/*
 * Following functions are optional, feel free to remove unused callbacks.
 * See the clientlib documentation for details on each function.
 */

/* Clientlib */
void ts3plugin_onConnectStatusChangeEvent(uint64 serverConnectionHandlerID, int newStatus, unsigned int errorNumber) {
	/* Some example code following to show how to use the information query functions. */
	unsigned int errorCode;
	if (newStatus == STATUS_CONNECTION_ESTABLISHED)
	{
		std::string myNickname = getMyNickname(serverConnectionHandlerID);
		anyID myId = getMyId(serverConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection);
		serverIdToData[serverConnectionHandlerID] = SERVER_RADIO_DATA();
		serverIdToData[serverConnectionHandlerID].myNickname = myNickname;		
		LeaveCriticalSection(&serverDataCriticalSection);
		
		EnterCriticalSection(&playbackCriticalSection);
		serverIdToPlayback[serverConnectionHandlerID] = SERVER_PLAYBACK();
		LeaveCriticalSection(&playbackCriticalSection);
		updateNicknamesList(serverConnectionHandlerID);

		// Set system 3d settings
		errorCode = ts3Functions.systemset3DSettings(serverConnectionHandlerID, 1.0f, 1.0f);
		if (errorCode != ERROR_ok)
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

int ts3plugin_onServerErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, const char* extraMessage) {
	if (returnCode) {
		/* A plugin could now check the returnCode with previously (when calling a function) remembered returnCodes and react accordingly */
		/* In case of using a a plugin return code, the plugin can return:
		 * 0: Client will continue handling this error (print to chat tab)
		 * 1: Client will ignore this error, the plugin announces it has handled it */
		return 1;
	}
	return 0;  /* If no plugin return code was used, the return value of this function is ignored */
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
	float* buffer = new float[sampleCount];
	for (int i = 0; i < sampleCount * channels; i += channels)
	{
		// prepare mono for radio						
		long long no3D = 0;
		for (int j = 0; j < channels; j++)
		{
			no3D += samples[i + j];
		}

		short to_process = (short)(no3D / channels);
		buffer[i / channels] = ((float)to_process / (float)SHRT_MAX) * gain;
	}
	EnterCriticalSection(&serverDataCriticalSection);
	effect->process(buffer, sampleCount);
	LeaveCriticalSection(&serverDataCriticalSection);
	for (int i = 0; i < sampleCount * channels; i += channels)
	{
		// put mixed output to stream			
		for (int j = 0; j < channels; j++) samples[i + j] = 0;

		for (int j = startChannel; j < endChannel; j++)
		{
			float sample = buffer[i / channels];
			short newValue;
			if (sample > 1.0) newValue = SHRT_MAX;
			else if (sample < -1.0) newValue = SHRT_MIN;
			else newValue = (short)(sample * (SHRT_MAX - 1));
			samples[i + j] = newValue;
		}
	}
	delete[] buffer;
}

bool isPluginEnabledForUser(uint64 serverConnectionHandlerID, anyID clientID)
{
	std::string clientInfo = getMetaData(clientID);
	bool result = false;

	std::string shouldStartWith = getConnectionStatusInfo(true, true, false);
	std::string clientStatus = std::string(clientInfo);
	result = startWith(shouldStartWith, clientStatus);

	DWORD currentTime = GetTickCount();
	EnterCriticalSection(&serverDataCriticalSection);
	CLIENT_DATA* data = getClientData(serverConnectionHandlerID, clientID);
	if (data)
	{
		if (result)
		{
			data->pluginEnabledCheck = currentTime;
		}
		else {
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
		int sum = to[q] + from[q];
		if (sum > SHRT_MAX) sum = SHRT_MAX; else if (sum < SHRT_MIN) sum = SHRT_MIN;
		to[q] = sum;
	}
}

float volumeMultiplifier(float volumeValue)
{
	float normalized = (volumeValue + 1) / 10.0f;
	return pow(normalized, 4);
}


void processCompressor(chunkware_simple::SimpleComp* compressor, short* samples, int channels, int sampleCount)
{
	if (channels >= 2)
	{
		for (int q = 0; q < sampleCount; q++) {
			double left = samples[channels * q];
			double right = samples[channels * q + 1];
			compressor->process(left, right);
			samples[channels * q] = (short)left;
			samples[channels * q + 1] = (short)right;
		}
	}
}

inline float clamp(float x, float a, float b)
{
	return x < a ? a : (x > b ? b : x);
}

void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {	
	EnterCriticalSection(&playbackCriticalSection);
	bool fill = false;
	std::vector<std::string> to_remove;
	if (!(*channelFillMask & 3))
	{
		memset(samples, 0, sampleCount * channels * sizeof(short));
	}
	for (auto it = serverIdToPlayback[serverConnectionHandlerID].playback.begin(); it != serverIdToPlayback[serverConnectionHandlerID].playback.end(); ++it)
	{
		int position = 0;
		while (position < sampleCount * channels && it->second.size() > 0)
		{
			for (int q = 0; q < 2; q++)
			{
				short s = it->second.at(0);
				if (samples[position] + s > SHRT_MAX)
				{
					samples[position] = SHRT_MAX;
				}
				else if (samples[position] + s < SHRT_MIN)
				{
					samples[position] = SHRT_MIN;
				}
				else
				{
					samples[position] += s;
				}
				position++;
				it->second.pop_front();
				fill = true;
			}
			for (int q = 2; q < channels; q++)
			{
				samples[position++] = 0.0f;
			}
		}
		if (it->second.size() == 0)
		{
			to_remove.push_back(it->first);
		}
	}

	for (auto it = to_remove.begin(); it != to_remove.end(); ++it)
	{
		serverIdToPlayback[serverConnectionHandlerID].playback.erase(*it);
	}

	if (fill) *channelFillMask |= 3;
	LeaveCriticalSection(&playbackCriticalSection);
	
}

void ts3plugin_onEditPostProcessVoiceDataEventStereo(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels) {
	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
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
			float globalGain = serverIdToData[serverConnectionHandlerID].globalVolume;
			if (data && myData)
			{
				EnterCriticalSection(&serverDataCriticalSection);
				applyGain(samples, channels, sampleCount, data->voiceVolumeMultiplifier);
				short* original_buffer = allocatePool(sampleCount, channels, samples);	

				bool shouldPlayerHear = (data->canSpeak && canSpeak);

				std::pair<std::string, float> myVehicleDesriptor = getVehicleDescriptor(myData->vehicleId);
				std::pair<std::string, float> hisVehicleDesriptor = getVehicleDescriptor(data->vehicleId);

				const float vehicleVolumeLoss = clamp(myVehicleDesriptor.second + hisVehicleDesriptor.second, 0.0f, 0.99f);
				bool vehicleCheck = (myVehicleDesriptor.first == hisVehicleDesriptor.first);
				float d = distanceFromClient(serverConnectionHandlerID, data);

				if (myId != clientID && d <= data->voiceVolume)
				{					
					// process voice
					data->getClunk("voice_clunk")->process(samples, channels, sampleCount, data->clientPosition, myData->viewAngle);
					if (shouldPlayerHear)
					{
						if (vehicleVolumeLoss < 0.01 || vehicleCheck)
						{
							applyGain(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear, data->voiceVolume));
						}
						else
						{
							processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear, data->voiceVolume, 1.0f - vehicleVolumeLoss) * pow(1.0f - vehicleVolumeLoss, 1.2), data->getFilterVehicle("local_vehicle", vehicleVolumeLoss));
						}
					}
					else
					{
						processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, d, shouldPlayerHear, data->voiceVolume) * CANT_SPEAK_GAIN, (data->getFilterCantSpeak("local_cantspeak")));
					}

				}
				else 
				{
					memset(samples, 0, channels * sampleCount * sizeof(short));
				}
				// process radio here
				processCompressor(&data->compressor, original_buffer, channels, sampleCount);

				std::vector<LISTED_INFO> listed_info = isOverRadio(serverConnectionHandlerID, data, myData, false, false, false);
				float radioDistance = effectiveDistance(serverConnectionHandlerID, data);

				for (size_t q = 0; q < listed_info.size(); q++)
				{
					LISTED_INFO& info = listed_info[q];
					short* radio_buffer = allocatePool(sampleCount, channels, original_buffer);
					float volumeLevel = volumeMultiplifier((float) info.volume);					
					if (data->subtype == "digital")
					{
						data->getSwRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, serverConnectionHandlerID, data));
						processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, data->getSwRadioEffect(info.radio_id), info.stereoMode);
					} 
					else if (data->subtype == "digital_lr" || data->subtype == "airborne")
					{
						data->getLrRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, serverConnectionHandlerID, data));
						processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, data->getLrRadioEffect(info.radio_id), info.stereoMode);
					}
					else if (data->subtype == "dd")
					{
						float ddVolumeLevel = volumeMultiplifier((float)serverIdToData[serverConnectionHandlerID].ddVolumeLevel);
						data->getUnderwaterRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, distance(data->clientPosition, myData->clientPosition), serverConnectionHandlerID, data));
						processRadioEffect(radio_buffer, channels, sampleCount, ddVolumeLevel * 0.6f, data->getUnderwaterRadioEffect(info.radio_id), info.stereoMode);
					}
					else if (data->subtype == "phone")
					{
						processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, volumeLevel * 10.0f, (data->getSpeakerPhone(info.radio_id)));
					}
					else
					{
						applyGain(radio_buffer, channels, sampleCount, 0.0f);
					}

					
					if (info.on == LISTED_ON_GROUND)
					{
						
						TS3_VECTOR myPosition = serverIdToData[serverConnectionHandlerID].myPosition;						
						float distance_from_radio = distance(myPosition, info.pos);

						const float radioVehicleVolumeLoss = clamp(myVehicleDesriptor.second + info.vehicle.second, 0.0f, 0.99f);
						bool radioVehicleCheck = (myVehicleDesriptor.first == info.vehicle.first);
						
						processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, 2, (data->getSpeakerFilter(info.radio_id)));

						float speakerDistance = (info.volume / 10.f) * serverIdToData[serverConnectionHandlerID].speakerDistance;
						if (radioVehicleVolumeLoss < 0.01 || radioVehicleCheck)
						{
							applyGain(radio_buffer, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, distance_from_radio, shouldPlayerHear, speakerDistance));
						}
						else
						{
							processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, volumeFromDistance(serverConnectionHandlerID, data, distance_from_radio, shouldPlayerHear, speakerDistance, 1.0f - radioVehicleVolumeLoss) * pow((1.0f - radioVehicleVolumeLoss), 1.2), (data->getFilterVehicle(info.radio_id, radioVehicleVolumeLoss)));
						}
						if (info.waveZ < UNDERWATER_LEVEL)
						{
							processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, CANT_SPEAK_GAIN * 50, (data->getFilterCantSpeak(info.radio_id)));
						}
						data->getClunk(info.radio_id)->process(radio_buffer, channels, sampleCount, info.pos, myData->viewAngle);
					}
					mix(samples, radio_buffer, sampleCount, channels);
					

					delete radio_buffer;
				}

				delete original_buffer;

				applyGain(samples, channels, sampleCount, globalGain);
				LeaveCriticalSection(&serverDataCriticalSection);
			}
		}
	}
	else
	{
		if (clientID != myId)
		{
			if (!isOtherRadioPluginEnabled(serverConnectionHandlerID, clientID))
			{
				if (isSeriousModeEnabled(serverConnectionHandlerID, clientID))
				{
					if (alive && inGame && isPluginEnabledForUser(serverConnectionHandlerID, clientID))
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
		else
		{
			memset(samples, 0, channels * sampleCount * sizeof(short));
		}
	}
}


void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
	short* stereo = new short[sampleCount * 2];
	for (int q = 0; q < sampleCount; q++)
	{
		for (int g = 0; g < 2; g++)
			stereo[q * 2 + g] = samples[q * channels + g];
	}

	ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, clientID, stereo, sampleCount, 2);

	for (int q = 0; q < sampleCount; q++)
	{
		for (int g = 0; g < 2; g++)
			samples[q * channels + g] = stereo[q * 2 + g];
		for (int g = 2; g < channels; g++)
			samples[q * channels + g] = 0.0f; 
	}

	delete stereo;
}

void ts3plugin_onEditCapturedVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, int* edited) {
	if (!inGame)
		return;
	if ((*edited & 2))
	{
 		anyID myId = getMyId(serverConnectionHandlerID);
		EnterCriticalSection(&serverDataCriticalSection);
				
		bool alive = serverIdToData[serverConnectionHandlerID].alive;
		if (hasClientData(serverConnectionHandlerID, myId) && alive)
		{
			int m = 1;
			if (channels == 1) m = 2;
							
			short* voice = new short[sampleCount * channels * m];					
			memset(voice, 0, sampleCount * channels * m * sizeof(short));
			if (m == 2)
			{
				for (int q = 0; q < channels * sampleCount; q++)
				for (int g = 0; g < m; g++)
					voice[q * m + g] = samples[q];
			}
			else
			{
				for (int q = 0; q < channels * sampleCount; q++)
					voice[q] = samples[q];
			}

			ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, myId, voice, sampleCount, channels * m);
			LeaveCriticalSection(&serverDataCriticalSection);			
			appendPlayback("my_radio_voice", serverConnectionHandlerID, voice, sampleCount, channels * m);
			delete voice;
		} 
		else 
		{
			LeaveCriticalSection(&serverDataCriticalSection);
		}
	}
}

void ts3plugin_onCustom3dRolloffCalculationClientEvent(uint64 serverConnectionHandlerID, anyID clientID, float distance, float* volume) {
	*volume = 1.0f;	// custom gain applied
}

/* Clientlib rare */
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

int ts3plugin_onServerPermissionErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, unsigned int failedPermissionID) {
	return 0;  /* See onServerErrorEvent for return code description */
}


void processAllTangentRelease(uint64 serverId, std::vector<std::string> &tokens)
{
	std::string nickname = tokens[1];
	EnterCriticalSection(&serverDataCriticalSection);
	if (serverIdToData.count(serverId) && serverIdToData[serverId].nicknameToClientData.count(nickname))
	{
		CLIENT_DATA* clientData = serverIdToData[serverId].nicknameToClientData[nickname];
		if (clientData)
		{
			clientData->tangentOverType = LISTEN_TO_NONE;
		}
	}
	LeaveCriticalSection(&serverDataCriticalSection);
}

void processTangentPress(uint64 serverId, std::vector<std::string> &tokens, std::string &command)
{
	DWORD time = GetTickCount();
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
			clientData->pluginEnabledCheck = time;
			clientData->subtype = subtype;

			if (longRange) clientData->canUseLRRadio = true;
			else if (diverRadio) clientData->canUseDDRadio = true;
			else clientData->canUseSWRadio = true;

			TS3_VECTOR myPosition = serverIdToData[serverId].myPosition;			
			
				log_string(std::string("REMOTE COMMAND ") + command, LogLevel_DEVEL);
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
				
					if (hasClientData(serverId, clientId))
					{						
						std::vector<LISTED_INFO> listedInfos = isOverRadio(serverId, clientData, getClientData(serverId, myId), !longRange && !diverRadio, longRange, diverRadio);
						for (auto it = listedInfos.begin(); it != listedInfos.end(); ++it)
						{
							LISTED_INFO listedInfo = *it;
							CLIENT_DATA* myData = getClientData(serverId, myId);
							std::pair<std::string, float> myVehicleDesriptor = getVehicleDescriptor(myData->vehicleId);
							const float vehicleVolumeLoss = clamp(myVehicleDesriptor.second + listedInfo.vehicle.second, 0.0f, 0.99f);
							bool vehicleCheck = (myVehicleDesriptor.first == listedInfo.vehicle.first);

							LeaveCriticalSection(&serverDataCriticalSection);
							float gain = volumeMultiplifier((float)listedInfo.volume) * serverIdToData[serverId].globalVolume;
							setGameClientMuteStatus(serverId, clientId);
							if (alive && listedInfo.on != LISTED_ON_NONE) {																
								if (subtype == "digital")
								{
									if (playPressed) playWavFile(serverId, "radio-sounds/sw/remote_start", gain * 0.5, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
									if (playReleased) playWavFile(serverId, "radio-sounds/sw/remote_end", gain * 0.5, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								}
								if (subtype == "digital_lr")
								{
									if (playPressed) playWavFile(serverId, "radio-sounds/lr/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
									if (playReleased) playWavFile(serverId, "radio-sounds/lr/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								}
								if (subtype == "dd")
								{
									if (playPressed) playWavFile(serverId, "radio-sounds/dd/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
									if (playReleased) playWavFile(serverId, "radio-sounds/dd/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								}
								if (subtype == "airborne")
								{
									if (playPressed) playWavFile(serverId, "radio-sounds/ab/remote_start", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
									if (playReleased) playWavFile(serverId, "radio-sounds/ab/remote_end", gain, listedInfo.pos, listedInfo.on == LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck);
								}
							}
							EnterCriticalSection(&serverDataCriticalSection);
						}
						
						if (playReleased && alive)
						{
							clientData->resetRadioEffect();
						}
					}			
			else
			{
				log_string(std::string("MY COMMAND ") + command, LogLevel_DEVEL);
			}
		}
		else
		{
			log_string(std::string("PLUGIN COMMAND, BUT NO CLIENT DATA ") + nickname);
		}
	}
	else
	{
		log_string(std::string("PLUGIN FROM UNKNOWN NICKNAME ") + nickname);
	}
	LeaveCriticalSection(&serverDataCriticalSection);
}

void processPluginCommand(std::string command)
{
	DWORD currentTime = GetTickCount();
	std::vector<std::string> tokens = split(command, '\t'); // may not be used in nickname
	uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
	if (tokens.size() == 6 && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" || tokens[0] == "TANGENT_DD"))
	{
		processTangentPress(serverId, tokens, command);
	}
	else if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS") 
	{
		processAllTangentRelease(serverId, tokens);
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
			if (!myCommand && hasClientData(serverId, serverIdToData[serverId].nicknameToClientData[nickname]->clientId))
			{
				setGameClientMuteStatus(serverId, serverIdToData[serverId].nicknameToClientData[nickname]->clientId);
			}
			EnterCriticalSection(&serverDataCriticalSection);
		}
		LeaveCriticalSection(&serverDataCriticalSection);
	}
	else
	{
		log_string(std::string("UNKNOWN PLUGIN COMMAND ") + command);
	}
}

void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
	log_string(std::string("ON PLUGIN COMMAND ") + pluginName + " " + pluginCommand, LogLevel_DEVEL);
	if (serverConnectionHandlerID == ts3Functions.getCurrentServerConnectionHandlerID())
	{
		if ((strcmp(pluginName, PLUGIN_NAME) == 0) || (strcmp(pluginName, PLUGIN_NAME_x64) == 0) || (strcmp(pluginName, PLUGIN_NAME_x32) == 0))
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