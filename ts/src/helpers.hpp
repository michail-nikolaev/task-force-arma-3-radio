#pragma once
#include <ts3_functions.h>
#include <string>
#include <vector>
#include <Windows.h>
#include "common.hpp"
#include <map>
#include "profilers.hpp"
#include "string_ref.hpp"
#include <array>

constexpr int const_strlen(const char* str) {
#ifndef VS15
	return *str ? 1 + const_strlen(str + 1) : 0;
#else
	if (str == 0)
		return -1;
	uint32_t length = 0;
	while (str[length] != 0) ++length;
	return length;
#endif
}
static_assert(const_strlen("hello") == 5, "const_strlen no workerino");

#ifdef VS15
#ifdef X64BUILD
typedef uint64_t strHashType;
#else
typedef uint32_t strHashType;
#endif
constexpr strHashType const_strhash(const char* str) {
	strHashType hash = 1337;
	auto length = 0u;
	while (str[length] != 0) {
#pragma warning( disable : 4307 ) // integer overflow
		hash *= str[length];
		++length;
	}
	return hash;
}
constexpr strHashType const_strhash(const char* str,size_t length) {
	strHashType hash = 1337;
	for (auto i = 0u; i < length; ++i){
#pragma warning( disable : 4307 ) // integer overflow
		hash *= str[i];
	}
	return hash;
}
#ifdef X64BUILD
static_assert(const_strhash("SETCFG") == 0x0000c2ca8962ff68, "const_strhash no workerino");
#else
static_assert(const_strhash("SETCFG") == 0x8962ff68, "const_strhash no workerino");
#endif

#endif
#define FORCE_COMPILETIME(e) (std::integral_constant<decltype(e), e>::value)

struct FREQ_SETTINGS;

struct vehicleDescriptor {
	std::string vehicleName;
	float vehicleIsolation;
};


class helpers {
public:
	static void applyGain(short * samples, size_t sampleCount, int channels, float directTalkingVolume);
	static void applyILD(short * samples, size_t sampleCount, int channels, Direction3D direction, AngleRadians viewAngle); //interaural level difference

	static void applyILD(short * samples, size_t sampleCount, int channels, Position3D myPosition, Direction3D myViewDirection, Position3D emitterPosition, Direction3D emitterViewDirection); //interaural level difference

	static float parseArmaNumber(const std::string& armaNumber);
	static int parseArmaNumberToInt(const std::string& armaNumber);
	static bool startsWith(const std::string& shouldStartWith, const std::string& startIn);
	static std::vector<std::string>& split(const std::string& s, char delim, std::vector<std::string>& elems);
	static std::vector<boost::string_ref>& split(boost::string_ref s, char delim, std::vector<boost::string_ref>& elems);
	static std::vector<std::string> split(const std::string& s, char delim);
	static bool isTrue(std::string& string);
	static short* allocatePool(int sampleCount, int channels, short* samples);
	static void mix(short* to, short* from, int sampleCount, int channels);
	static float volumeMultiplifier(const float volumeValue);
	static std::map<std::string, FREQ_SETTINGS> parseFrequencies(const std::string& string);
	static vehicleDescriptor getVehicleDescriptor(const std::string& vechicleId);
	//String of format [0.123,0.123,0.123]
	static std::vector<float> coordStringToVector(const std::string& coordinateString) {
		std::vector<float> output;
		if (coordinateString.length() > 2) {
			std::vector<std::string> coords(4);
			split(coordinateString.substr(1, coordinateString.length() - 2), ',', coords);
			for (const std::string& coord : coords)
				output.push_back(parseArmaNumber(coord));
		}
		return output;
	}
	static float volumeAttenuation(float distance, bool shouldPlayerHear, float maxAudible, float multiplifer = 1.0f) {
		if (distance <= 1.0) return 1.0;
		float maxDistance = shouldPlayerHear ? maxAudible * multiplifer : CANT_SPEAK_DISTANCE;

		//linear:
			//float gain = 1.0f - (distance / maxDistance);

	   //logarithmic
			//float gain = 0.5f *logf(distance / maxDistance);

	   //inverse:
			//float gain = 0.02f / (distance / maxDistance);

	   //Reverse Logarithmic
			//float gain = 1.0f + 0.5f *logf(1.0f - (distance / maxDistance));

	   //Unreal Engine NaturalSound	https://docs.unrealengine.com/latest/INT/Engine/Audio/DistanceModelAttenuation/index.html
		float gain = powf(10.0f, ((distance / maxDistance) * -60.0f) / 20.0f);

		//Old thingy
		//float gain = powf(distFromRadio, -0.3f) * (std::max(0.f, (maxDistance - distFromRadio)) / maxDistance);

		if (gain < 0.001f) return 0.0f;
		return std::min(1.0f, gain);//Don't go over 100%
	}
	static float volumeAttenuation(float distance, bool shouldPlayerHear, int maxAudible, float multiplifer = 1.0f) {
		return volumeAttenuation(distance, shouldPlayerHear, static_cast<float>(maxAudible), multiplifer);
	}

	template<class T>	  //#MAYBE audioHelpers?
	static void processFilterStereo(short * samples, int channels, size_t sampleCount, float gain, T* filter) {
		static thread_local size_t allocatedFloatsSample = 0;
		static thread_local std::array<std::vector<float>,MAX_CHANNELS> floatsSample;

		if (allocatedFloatsSample < sampleCount)  //Not enough buffer, create new one
		{
			for (int j = 0; j < MAX_CHANNELS; j++) {
				floatsSample[j].resize(sampleCount);
			}
			allocatedFloatsSample = sampleCount;
		}

		//Split channels into separate arrays
		for (size_t i = 0; i < sampleCount * channels; i += channels) {
			for (int j = 0; j < channels; j++) {
				floatsSample[j][i / channels] = ((float) samples[i + j] / (float) SHRT_MAX);
			}
		};

		filter->process<float>(static_cast<int>(sampleCount), floatsSample);

		// put mixed output to stream
		for (size_t i = 0; i < sampleCount * channels; i += channels) {
			for (int j = 0; j < channels; j++) {
				float sample = floatsSample[j][i / channels] * gain;
				short newValue;
				if (sample > 1.0) newValue = SHRT_MAX;
				else if (sample < -1.0) newValue = SHRT_MIN;
				else newValue = (short) (sample * (SHRT_MAX - 1));
				samples[i + j] = newValue;
			}
		}
	}

	static float distanceForDiverRadio();




};
