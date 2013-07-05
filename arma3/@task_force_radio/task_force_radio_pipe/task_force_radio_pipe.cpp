// task_force_radio_pipe.cpp: определяет экспортированные функции для приложения DLL.
//

#include "stdafx.h"

extern "C"
{
	__declspec(dllexport) void __stdcall RVExtension(char *output, int outputSize, const char *input); 
};

void __stdcall RVExtension(char *output, int outputSize, const char *input)
{
	outputSize -= 1;
	std::string answer = "answer " + std::string(input);
	strncpy(output, answer.c_str(), outputSize);
}