#pragma once
#include "version.h"
#include "public_definitions.h"
#include <string>
#include <algorithm>

#define RADIO_GAIN_LR 5
#define RADIO_GAIN_DD 15
#define CANT_SPEAK_GAIN 14

#define MAX_CHANNELS  8

#define PLUGIN_API_VERSION 21
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

#define CANT_SPEAK_DISTANCE 5
#define SPEAKER_GAIN 4

#define PIWIK_URL L"nkey.piwik.pro"
#define UPDATE_URL L"raw.github.com"
#define UPDATE_FILE L"/michail-nikolaev/task-force-arma-3-radio/master/current_version.txt"

#define INVALID_DATA_FRAME std::numeric_limits<int>::max()
#define FAILS_TO_SLEEP 50 //PipeThread

#define START_DATA "<TFAR>"
#define END_DATA "</TFAR>"

#ifdef _WIN32
#define _strcpy(dest, destSize, src) strcpy_s(dest, destSize, src)
#define snprintf sprintf_s
#else
#define _strcpy(dest, destSize, src) { strncpy(dest, src, destSize-1); (dest)[destSize-1] = '\0'; }
#endif

#define INFODATA_BUFSIZE 512
extern void log_string(std::string message, LogLevel level = LogLevel_DEVEL);
extern void log(const char* message, LogLevel level = LogLevel_DEVEL);

enum class stereoMode {//#TODO move to a real header
	stereo = 0,
	leftOnly = 1,
	rightOnly = 2
};