#pragma once
#include <ts3_functions.h>
#include <string>
#include <vector>
#include "server_radio_data.hpp"
#include <Windows.h>
int constexpr const_strlen(const char* str) {
	return *str ? 1 + const_strlen(str + 1) : 0;
}
class helpers {
public:
	static void applyGain(short * samples, int channels, size_t sampleCount, float directTalkingVolume);
	static void applyILD(short * samples, int channels, int sampleCount, TS3_VECTOR position, float viewAngle);
	static float sq(float x);
	static float distance(TS3_VECTOR from, TS3_VECTOR to) ;
	static float parseArmaNumber(const std::string& armaNumber);
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
	//String of format [0.123,0.123,0.123]
	static std::vector<float> coordStringToVector(const std::string& coordinateString) {
		std::vector<float> output;
		if (coordinateString.length() > 2) {
			std::vector<std::string> coords = helpers::split(coordinateString.substr(1, coordinateString.length() - 2), ',');
			for (const std::string& coord : coords)
				output.push_back(static_cast<float>(std::atof(coord.c_str())));
		}
		return output;
	}
	static float volumeFromDistance(float distance, bool shouldPlayerHear, float clientDistance, float multiplifer = 1.0f) {
		if (distance <= 1.0) return 1.0;
		float maxDistance = shouldPlayerHear ? clientDistance * multiplifer : CANT_SPEAK_DISTANCE;
		float gain = powf(distance, -0.3f) * (max(0, (maxDistance - distance)) / maxDistance);
		if (gain < 0.001f) return 0.0f; else return min(1.0f, gain);
	}
	static float volumeFromDistance(float distance, bool shouldPlayerHear, int clientDistance, float multiplifer = 1.0f) {
		if (distance <= 1.0) return 1.0;
		float maxDistance = shouldPlayerHear ? static_cast<float>(clientDistance) * multiplifer : CANT_SPEAK_DISTANCE;
		float gain = powf(distance, -0.3f) * (max(0, (maxDistance - distance)) / maxDistance);
		if (gain < 0.001f) return 0.0f; else return min(1.0f, gain);
	}

	template<class T>	  //#MAYBE audioHelpers?
	static void processFilterStereo(short * samples, int channels, int sampleCount, float gain, T* filter) {
		for (int i = 0; i < sampleCount * channels; i += channels) {
			// all channels mixed
			float mix[MAX_CHANNELS];
			for (int j = 0; j < MAX_CHANNELS; j++) mix[j] = 0.0;

			// prepare mono for radio
			short to_process[MAX_CHANNELS];
			for (int j = 0; j < MAX_CHANNELS; j++) to_process[j] = 0;

			for (int j = 0; j < channels; j++) {
				to_process[j] = samples[i + j];
			}

			// process radio filter
			EnterCriticalSection(&serverDataCriticalSection);
			for (int j = 0; j < channels; j++) {
				floatsSample[j][0] = ((float) to_process[j] / (float) SHRT_MAX);
			}
			// skip other channels
			for (int j = channels; j < MAX_CHANNELS; j++) {
				floatsSample[j][0] = 0.0;
			}
			filter->process<float>(1, floatsSample);
			for (int j = 0; j < channels; j++) {
				mix[j] = floatsSample[j][0] * gain;
			}
			LeaveCriticalSection(&serverDataCriticalSection);

			// put mixed output to stream		
			for (int j = 0; j < channels; j++) {
				float sample = mix[j];
				short newValue;
				if (sample > 1.0) newValue = SHRT_MAX;
				else if (sample < -1.0) newValue = SHRT_MIN;
				else newValue = (short) (sample * (SHRT_MAX - 1));
				samples[i + j] = newValue;
			}
		}
	}

};

class CriticalSectionLock {
	CRITICAL_SECTION* cs;
public:
	explicit CriticalSectionLock(CRITICAL_SECTION* _cs) : cs(_cs) { EnterCriticalSection(cs); }
	~CriticalSectionLock() { LeaveCriticalSection(cs); }
};