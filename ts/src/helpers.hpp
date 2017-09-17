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
#include <functional>
#include <emmintrin.h>

constexpr int const_strlen(const char* str) {
    if (str == 0)
        return -1;
    uint32_t length = 0;
    while (str[length] != 0) ++length;
    return length;
}
static_assert(const_strlen("hello") == 5, "const_strlen no workerino");

//from MSVC std library just in constexpr
constexpr size_t _Hash_bytes(const char *_First, size_t _Count) _NOEXCEPT {	// FNV-1a hash function for bytes in [_First, _First + _Count)
#if defined(_WIN64)
    static_assert(sizeof(size_t) == 8, "This code is for 64-bit size_t.");
    const size_t _FNV_offset_basis = 14695981039346656037ULL;
    const size_t _FNV_prime = 1099511628211ULL;

#else /* defined(_WIN64) */
    static_assert(sizeof(size_t) == 4, "This code is for 32-bit size_t.");
    const size_t _FNV_offset_basis = 2166136261U;
    const size_t _FNV_prime = 16777619U;
#endif /* defined(_WIN64) */

    size_t _Val = _FNV_offset_basis;
    for (size_t _Next = 0; _Next < _Count; ++_Next) {	// fold in another byte
    #pragma warning( disable : 4307 )
        _Val ^= (size_t) _First[_Next];
        _Val *= _FNV_prime;
    }
    return (_Val);
    }

using strHashType = size_t;

constexpr strHashType const_strhash(const char* str) {
    return _Hash_bytes(str, const_strlen(str));
}
constexpr strHashType const_strhash(const char* str, size_t length) {
    return _Hash_bytes(str, length);
}

#ifdef X64BUILD
static_assert(const_strhash("SETCFG") == 0x9ca67405fc197a4f, "const_strhash no workerino");
#else
static_assert(const_strhash("SETCFG") == 0xb3f7090f, "const_strhash no workerino");
#endif

#define FORCE_COMPILETIME(e) (std::integral_constant<decltype(e), e>::value)

struct FREQ_SETTINGS;

struct vehicleDescriptor {
    std::string vehicleName;
    float vehicleIsolation;
    enum class vehiclePosition {
        driver,
        commander,
        gunner,
        cargo
    } /*slot*/;
    int16_t intercomSlot{ -1 };//If this is -1 then vehicle doesn't have intercom
    static vehiclePosition stringToVehiclePosition(const std::string& pos) {
        if (pos == "driver") return vehiclePosition::driver;
        if (pos == "commander") return vehiclePosition::commander;
        if (pos == "gunner") return vehiclePosition::gunner;
        return vehiclePosition::cargo;
    }
};


class helpers {
public:
    static void applyGain(short * samples, size_t sampleCount, int channels, float directTalkingVolume);
    static void applyILD(short * samples, size_t sampleCount, int channels, Direction3D direction, AngleRadians viewAngle); //interaural level difference

    static void applyILD(short * samples, size_t sampleCount, int channels, Position3D myPosition, Direction3D myViewDirection, Position3D emitterPosition, Direction3D emitterViewDirection); //interaural level difference

    static void shortFloatMultEx(short* data, size_t elementCount, __m128 multPack);

    static float parseArmaNumber(const std::string& armaNumber);
    static float parseArmaNumber(const char* armaNumber);
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
        float gain = powf(10.0f, ((distance / (maxDistance * 2)) * -60.0f) / 20.0f);//originally powf(10.0f, ((distance / (maxDistance*2)) * -60.0f) / 20.0f);  but that would half maxDist

        //Old thingy
        //float gain = powf(distFromRadio, -0.3f) * (std::max(0.f, (maxDistance - distFromRadio)) / maxDistance);

        if (gain < 0.001f) return 0.0f;
        return std::min(1.0f, gain);//Don't go over 100%
    }
    static float volumeAttenuation(float distance, bool shouldPlayerHear, int maxAudible, float multiplifer = 1.0f) {
        return volumeAttenuation(distance, shouldPlayerHear, static_cast<float>(maxAudible), multiplifer);
    }

    template<class T>
    static void processFilterStereo(short * samples, int channels, size_t sampleCount, float gain, T* filter) {
        static thread_local size_t allocatedFloatsSample = 0;
        static thread_local std::array<std::vector<float>, MAX_CHANNELS> floatsSample;
        if (allocatedFloatsSample != floatsSample[0].size())
            allocatedFloatsSample = 0; //It happened that allocatedFloatsSample==960 and floatsSample[0] was of size 0...

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



class execAtReturn {
public:
    explicit execAtReturn(std::function<void()> func) :function(func) {}
    ~execAtReturn() { function(); }
private:
    std::function<void()> function;
};
