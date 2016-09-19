#pragma once
#include <ts3_functions.h>
#include <string>
#include <vector>
#include "server_radio_data.hpp"

int constexpr const_strlen(const char* str) {
	return *str ? 1 + const_strlen(str + 1) : 0;
}
class helpers {
public:
	static void applyGain(short * samples, int channels, int sampleCount, float directTalkingVolume);
	static void applyILD(short * samples, int channels, int sampleCount, TS3_VECTOR position, float viewAngle);
	static float sq(float x);
	static float distance(TS3_VECTOR from, TS3_VECTOR to) ;
	static double parseArmaNumber(const std::string& armaNumber);
	static int parseArmaNumberToInt(const std::string& armaNumber);
	static bool startsWith(const std::string& shouldStartWith, const std::string& startIn);
	static std::vector<std::string>& split(const std::string& s, char delim, std::vector<std::string>& elems);
	static std::vector<std::string> split(const std::string& s, char delim);
	static bool isTrue(std::string& string);
	static short* allocatePool(int sampleCount, int channels, short* samples);
	static void mix(short* to, short* from, int sampleCount, int channels);
	static float volumeMultiplifier(const float volumeValue);
	static std::map<std::string, FREQ_SETTINGS> parseFrequencies(std::string string);
	static float clamp(float x, float a, float b);
	static std::pair<std::string, float> getVehicleDescriptor(std::string vechicleId);

};

