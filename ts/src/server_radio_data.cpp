#include "server_radio_data.hpp"
#include "helpers.h"


void SERVER_RADIO_DATA::setFreqInfos(const std::vector<std::string>& tokens) {
	EnterCriticalSection(&serverDataCriticalSection);
	mySwFrequencies = helpers::parseFrequencies(tokens[1]);
	myLrFrequencies = helpers::parseFrequencies(tokens[2]);
	myDdFrequency = tokens[3];
	alive = tokens[4] == "true";
	myVoiceVolume = helpers::parseArmaNumberToInt(tokens[5]);
	ddVolumeLevel = static_cast<int>(std::atof(tokens[6].c_str()));
	wavesLevel = std::atof(tokens[8].c_str());
	terrainIntersectionCoefficient = std::atof(tokens[9].c_str());
	globalVolume = std::atof(tokens[10].c_str());
	receivingDistanceMultiplicator = std::atof(tokens[12].c_str());
	speakerDistance = std::atof(tokens[13].c_str());
	LeaveCriticalSection(&serverDataCriticalSection);
}

