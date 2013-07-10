// stdafx.h: включаемый файл дл€ стандартных системных включаемых файлов
// или включаемых файлов дл€ конкретного проекта, которые часто используютс€, но
// не часто измен€ютс€
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN 

#include <windows.h>
#include <string>

using namespace std;

#define PIPE_NAME L"\\\\.\\pipe\\task_force_radio_pipe"
extern HANDLE pipe;

extern "C"
{
	__declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *input); 
};

void openPipe();
void closePipe();