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
	wavesLevel = helpers::parseArmaNumber(tokens[8]);
	terrainIntersectionCoefficient = helpers::parseArmaNumber(tokens[9]);
	globalVolume = helpers::parseArmaNumber(tokens[10]);
	receivingDistanceMultiplicator = helpers::parseArmaNumber(tokens[12]);
	speakerDistance = helpers::parseArmaNumber(tokens[13]);
	LeaveCriticalSection(&serverDataCriticalSection);
}

