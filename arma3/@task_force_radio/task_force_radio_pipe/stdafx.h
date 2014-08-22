// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN 

#include <windows.h>
#include <string>

using namespace std;

#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe"
#define DEBUG_PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe_debug"
#define DEBUG_PARAMETER L"-tfdebug"
extern HANDLE pipe;

extern "C"
{
	__declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *input); 
};

void openPipe();
void closePipe();
