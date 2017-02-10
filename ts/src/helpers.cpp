#include "helpers.hpp"

#ifndef _USE_MATH_DEFINES
#define _USE_MATH_DEFINES
#endif
#include <math.h>
#include <algorithm>
#include <sstream>
#include "task_force_radio.hpp"
#include <bitset>
#include <public_errors.h>

void helpers::applyGain(short * samples, size_t sampleCount, int channels, float directTalkingVolume) {
    if (directTalkingVolume == 0.0f) {
        memset(samples, 0, sampleCount * channels * sizeof(short));
        return;
    }
    if (directTalkingVolume == 1.0f) //no change in gain
        return;
    for (size_t i = 0; i < sampleCount * channels; i++) samples[i] = static_cast<short>(samples[i] * directTalkingVolume);
}

constexpr float DegToRad(float deg) {
    return deg * (static_cast<float>(M_PI) / 180);
}
//static_assert(static_cast<AngleRadians>(190.0_deg) > 3.f, "");
void helpers::applyILD(short * samples, size_t sampleCount, int channels, Direction3D direction, AngleRadians viewAngle) {
    if (channels == 2) {
        AngleRadians dir = (direction.toPolarAngle() + viewAngle);
        float gainFrontLeft = AngleDegrees(-21.5f).toRadians() * dir.cosine() + 0.625f;
        float gainFrontRight = AngleDegrees(21.5f).toRadians() * dir.cosine() + 0.625f;
        //Use https://msdn.microsoft.com/en-us/library/windows/desktop/ee415798(v=vs.85).aspx for more than 2 channels

        for (size_t i = 0; i < sampleCount * channels; i += channels) {
            samples[i] = static_cast<short>(samples[i] * gainFrontLeft);
            samples[i + 1] = static_cast<short>(samples[i + 1] * gainFrontRight);
        }
    }
}
#define _SPEAKER_POSITIONS_
#include <X3daudio.h>
#pragma comment(lib, "x3daudio.lib")
X3DAUDIO_HANDLE x3d_handle;
bool x3d_initialized = false;

void helpers::applyILD(short * samples, size_t sampleCount, int channels, Position3D myPosition, Direction3D myViewDirection, Position3D emitterPosition, Direction3D emitterViewDirection) {
    if (!x3d_initialized) {
        X3DAudioInitialize(
            SPEAKER_FRONT_LEFT | SPEAKER_FRONT_RIGHT,
            X3DAUDIO_SPEED_OF_SOUND,
            x3d_handle
        );
        x3d_initialized = true;
    }
    //#X3DAudio cache if position didn't change.
    //#X3DAudio make player local effect so X3DAudio objects are local to every player.
    //#X3DAudio fix up vector problem
    X3DAUDIO_LISTENER listener{};
    std::tie(listener.OrientFront.x, listener.OrientFront.y, listener.OrientFront.z) = myViewDirection.get();
    listener.OrientFront.y = -listener.OrientFront.y;
    listener.OrientFront.x = -listener.OrientFront.x;
    std::tie(listener.OrientTop.x, listener.OrientTop.y, listener.OrientTop.z) = Direction3D(-std::get<0>(myViewDirection.get()), -std::get<1>(myViewDirection.get()), 1.f).get();
    std::tie(listener.Position.x, listener.Position.y, listener.Position.z) = myPosition.get();
    listener.pCone = NULL;

    X3DAUDIO_EMITTER emitter{};

    std::tie(emitter.Position.x, emitter.Position.y, emitter.Position.z) = emitterPosition.get();
    std::tie(emitter.OrientFront.x, emitter.OrientFront.y, emitter.OrientFront.z) = emitterViewDirection.get();
    //std::tie(emitter.OrientTop.x, emitter.OrientTop.y, emitter.OrientTop.z) = emitterRotation.up.get();
    emitter.ChannelCount = 1;
    emitter.CurveDistanceScaler = 1.f;
    emitter.ChannelRadius = 1.f;

    X3DAUDIO_DSP_SETTINGS output{ 0 };

    output.SrcChannelCount = 1;
    output.DstChannelCount = channels;
    float* volumeMatrix = new float[channels];	//#X3DAudio minimum 2 channels
    output.pMatrixCoefficients = volumeMatrix;



    X3DAudioCalculate(
        x3d_handle,
        &listener,
        &emitter,
        X3DAUDIO_CALCULATE_MATRIX,
        &output
    );



    float gainFrontLeft = volumeMatrix[0];
    float gainFrontRight = volumeMatrix[1];
    delete[] volumeMatrix;
    float mult = 1 / (gainFrontRight + gainFrontLeft);
    gainFrontLeft *= mult; //make sure left+right = 1.0 else it would decrease overall volume which we don't want
    gainFrontRight *= mult;


    for (size_t i = 0; i < sampleCount * channels; i += channels) {
        samples[i] = static_cast<short>(samples[i] * gainFrontLeft);
        samples[i + 1] = static_cast<short>(samples[i + 1] * gainFrontRight);
    }
}

inline float helpers::parseArmaNumber(const std::string& armaNumber) {
    return parseArmaNumber(armaNumber.c_str());
}

inline float helpers::parseArmaNumber(const char* armaNumber) {
    return static_cast<float>(std::atof(armaNumber));
}

inline int helpers::parseArmaNumberToInt(const std::string& armaNumber) {
    return static_cast<int>(std::round(parseArmaNumber(armaNumber)));
}

bool helpers::startsWith(const std::string& shouldStartWith, const  std::string& startIn) {
    if (startIn.size() >= shouldStartWith.size()) {
        auto res = std::mismatch(shouldStartWith.begin(), shouldStartWith.end(), startIn.begin());
        return (res.first == shouldStartWith.end());
    } else {
        return false;
    }
}

//http://stackoverflow.com/a/5506223
std::vector<std::string>& helpers::split(const std::string& s, char delim, std::vector<std::string>& elems) {
    std::string::size_type pos, lastPos = 0, length = s.length();

    while (lastPos < length + 1) {
        pos = s.find_first_of(delim, lastPos);
        if (pos == std::string::npos) {
            pos = length;
        }

        //if (pos != lastPos || !trimEmpty)
        elems.emplace_back(s.data() + lastPos, pos - lastPos);

        lastPos = pos + 1;
    }

    return elems;
}

std::vector<boost::string_ref>& helpers::split(boost::string_ref s, char delim, std::vector<boost::string_ref>& elems) {
    std::string::size_type pos, lastPos = 0, length = s.length();

    while (lastPos < length + 1) {
        pos = s.substr(lastPos).find_first_of(delim);
        if (pos == std::string::npos) {
            pos = length;
        }

       // if (pos != lastPos /*|| !trimEmpty*/)
            elems.push_back(s.substr(lastPos, lastPos + pos - lastPos));

        lastPos += pos + 1;
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

        to[q] = std::clamp(sum, SHRT_MIN, SHRT_MAX);
    }
}

float helpers::volumeMultiplifier(const float volumeValue) {
    float normalized = (volumeValue + 1) / 10.0f;
    return pow(normalized, 4);
}

std::map<std::string, FREQ_SETTINGS> helpers::parseFrequencies(const std::string& string) {
    std::map<std::string, FREQ_SETTINGS> result;
    std::string sub = string.substr(1, string.length() - 2);
    if (sub.empty()) return result;
    std::vector<std::string> v = split(sub, ',');
    for (const std::string& xs : v) {
        std::vector<std::string> parts = split(xs.substr(1, xs.length() - 2), '|');
        if (parts.size() == 3 || parts.size() == 4) {
            FREQ_SETTINGS settings;
            settings.volume = parseArmaNumberToInt(parts[1]);
            settings.stereoMode = static_cast<stereoMode>(parseArmaNumberToInt(parts[2]));
            if (parts.size() == 4)
                settings.radioClassname = parts[3];
            result[parts[0]] = settings;
        }
    }
    return result;
}

vehicleDescriptor helpers::getVehicleDescriptor(const std::string& vehicleID) {
    vehicleDescriptor result;
    result.vehicleName == ""; // hear vehicle
    result.vehicleIsolation = 0.0f; // hear 
    if (vehicleID.find("_turnout") != std::string::npos) {
        result.vehicleName = vehicleID.substr(0, vehicleID.find("_turnout"));
    } else {
        if (vehicleID.find_last_of("_") != std::string::npos) {
            result.vehicleName = vehicleID.substr(0, vehicleID.find_last_of("_"));
            result.vehicleIsolation = std::stof(vehicleID.substr(vehicleID.find_last_of("_") + 1));
        } else {
            result.vehicleName = vehicleID;
        }
    }
    return result;
}

float helpers::distanceForDiverRadio() {
    return DD_MIN_DISTANCE + (DD_MAX_DISTANCE - DD_MIN_DISTANCE) * (1.0f - TFAR::getInstance().m_gameData.wavesLevel); //#TODO WTF?! underwater range is influenced by wave intensity?
}
