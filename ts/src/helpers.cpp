#include "helpers.h"

#ifndef _USE_MATH_DEFINES
#define _USE_MATH_DEFINES
#endif
#include <math.h>
#include <algorithm>
#include <sstream>
   //#TODO swap channels and sampleCount parameters. Everywhere else sampleCount*channels is used.
void helpers::applyGain(short * samples, int channels, size_t sampleCount, float directTalkingVolume) {
	if (directTalkingVolume == 0.0f) {
		memset(samples, 0, sampleCount * channels * sizeof(short));
		return;
	}
	if (directTalkingVolume == 1.0f) //no change in gain
		return;
	for (int i = 0; i < sampleCount * channels; i++) samples[i] = (short) (samples[i] * directTalkingVolume);
}
//#TODO swap channels and sampleCount parameters. Everywhere else sampleCount*channels is used.
void helpers::applyILD(short * samples, int channels, int sampleCount, TS3_VECTOR position, float viewAngle) {
	if (channels == 2) {
		viewAngle = viewAngle * static_cast<float>((M_PI)) / 180.0f;
		float dir = atan2(position.y, position.x) + viewAngle;
		while (dir > static_cast<float>((M_PI))) {
			dir = dir - 2 * static_cast<float>((M_PI));
		}

		float gainLeft = 1.0;
		float gainRight = 1.0;

		gainLeft = -0.375f * cos(dir) + 0.625f;
		gainRight = 0.375f * cos(dir) + 0.625f;

		for (int i = 0; i < sampleCount * channels; i++) {
			if (i % 2 == 0) {
				samples[i] = static_cast<short>(samples[i] * gainLeft);
			} else {
				samples[i] = static_cast<short>(samples[i] * gainRight);
			}
		}
	}
}

inline float helpers::sq(float x) {
	return x * x;
}

float helpers::distance(TS3_VECTOR from, TS3_VECTOR to) {
	return sqrt(sq(from.x - to.x) + sq(from.y - to.y) + sq(from.z - to.z));
}

inline float helpers::parseArmaNumber(const std::string& armaNumber) {
	return static_cast<float>(std::atof(armaNumber.c_str()));
}

inline int helpers::parseArmaNumberToInt(const std::string& armaNumber) {
	return static_cast<int>(std::round(parseArmaNumber(armaNumber)));
}

bool helpers::startsWith(const std::string& shouldStartWith, const  std::string& startIn) {
	if (startIn.size() > shouldStartWith.size()) {
		auto res = std::mismatch(shouldStartWith.begin(), shouldStartWith.end(), startIn.begin());
		return (res.first == shouldStartWith.end());
	} else {
		return false;
	}
}

std::vector<std::string>& helpers::split(const std::string& s, char delim, std::vector<std::string>& elems) {
	std::stringstream ss(s);
	std::string item;
	while (std::getline(ss, item, delim)) {
		elems.push_back(item);
	}
	return elems;
}

std::vector<std::string> helpers::split(const std::string& s, char delim) {
	std::vector<std::string> elems;
	split(s, delim, elems);
	return elems;
}

bool helpers::isTrue(std::string& string) {
	if (string.length() != 4)	//small speed optimization
		return false;
	return string == "true";
}

short* helpers::allocatePool(int sampleCount, int channels, short* samples) {
	short* result = new short[sampleCount * channels];
	memcpy(result, samples, sampleCount * channels * sizeof(short));
	return result;
}

void helpers::mix(short* to, short* from, int sampleCount, int channels) {
	for (int q = 0; q < sampleCount * channels; q++) {
		int sum = to[q] + from[q];
		if (sum > SHRT_MAX) sum = SHRT_MAX;
		else if (sum < SHRT_MIN) sum = SHRT_MIN;
		to[q] = sum;
	}
}

float helpers::volumeMultiplifier(const float volumeValue) {
	float normalized = (volumeValue + 1) / 10.0f;
	return pow(normalized, 4);
}

std::map<std::string, FREQ_SETTINGS> helpers::parseFrequencies(std::string string) {
	std::map<std::string, FREQ_SETTINGS> result;
	std::string sub = string.substr(1, string.length() - 2);
	std::vector<std::string> v = split(sub, ',');
	for (auto i = v.begin(); i != v.end(); i++) { //#FOREACH
		std::string xs = *i;
		xs = xs.substr(1, xs.length() - 2);
		std::vector<std::string> parts = split(xs, '|');
		if (parts.size() == 3) {
			FREQ_SETTINGS settings;
			settings.volume = parseArmaNumberToInt(parts[1]);
			settings.stereoMode = parseArmaNumberToInt(parts[2]);
			result[parts[0]] = settings;
		}
	}
	return result;
}

float helpers::clamp(float x, float a, float b) {
	return x < a ? a : (x > b ? b : x);
}

std::pair<std::string, float> helpers::getVehicleDescriptor(std::string vechicleId) {
	std::pair<std::string, float> result;
	result.first == ""; // hear vehicle
	result.second = 0.0f; // hear 

	if (vechicleId.find("_turnout") != std::string::npos) {
		result.first = vechicleId.substr(0, vechicleId.find("_turnout"));
	} else {
		if (vechicleId.find_last_of("_") != std::string::npos) {
			result.first = vechicleId.substr(0, vechicleId.find_last_of("_"));
			result.second = std::stof(vechicleId.substr(vechicleId.find_last_of("_") + 1));
		} else {
			result.first = vechicleId;
		}
	}
	return result;
}
