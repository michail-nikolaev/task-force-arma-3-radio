#pragma once
#include "client_data.hpp"
struct FREQ_SETTINGS {
	int volume;
	int stereoMode;
};

struct SPEAKER_DATA {
	std::string radio_id;
	std::string nickname;
	std::vector<float> pos;
	int volume;
	std::pair<std::string, float> vehicle;
	float waveZ;
};

struct SERVER_RADIO_DATA
{
	std::string getMyNickname() const { return myNickname; }
	void setMyNickname(std::string val) { myNickname = CLIENT_DATA::convertNickname(val); }
	std::string myOriginalNickname;
	bool tangentPressed;
	TS3_VECTOR myPosition;
	STRING_TO_CLIENT_DATA_MAP nicknameToClientData;

	std::map<std::string, FREQ_SETTINGS> mySwFrequencies;
	std::map<std::string, FREQ_SETTINGS> myLrFrequencies;
	
	std::string myDdFrequency;
	std::multimap<std::string, SPEAKER_DATA> speakers;
	std::map<std::string, clunk::WavFile*> waves;

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
private:
	std::string myNickname;
};
typedef std::map<uint64, SERVER_RADIO_DATA> SERVER_ID_TO_SERVER_DATA;

