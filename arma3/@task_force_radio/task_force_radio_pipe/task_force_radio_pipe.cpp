// task_force_radio_pipe.cpp: определяет экспортированные функции для приложения DLL.
//

#include "stdafx.h"

void closePipe()
{
	CloseHandle(pipe);
	pipe = INVALID_HANDLE_VALUE;
}

#ifdef _DEBUG
bool isDebugArmaInstance() 
{		
	std::wstring execPath(GetCommandLine());
	if (std::string::npos != execPath.find(DEBUG_PARAMETER))
	{
		return true;
	}	
	return false;
}
#endif

void openPipe() 
{
	closePipe();
	LPCWSTR pipeName = PIPE_NAME;
#ifdef _DEBUG
	if (isDebugArmaInstance()) pipeName = DEBUG_PIPE_NAME;
#endif
	pipe = CreateNamedPipe(
			pipeName, // name of the pipe
			PIPE_ACCESS_OUTBOUND | FILE_FLAG_OVERLAPPED, // 1-way pipe -- send only
			PIPE_TYPE_MESSAGE, // send data as message
			1, // only allow 1 instance of this pipe
			0, // no outbound buffer
			0, // no inbound buffer
			0, // use default wait time
			NULL // use default security attributes
		);
}

void __stdcall RVExtension(char *output, int outputSize, const char *input)
{
	DWORD written = 0;	
	string answer;
	if (WriteFile(pipe, input, strlen(input), &written, NULL)) 
	{		
		answer = "OK";
	} else {
		DWORD error = GetLastError();		
		if (error == ERROR_NO_DATA) 
		{
			openPipe();
			answer = "Pipe was closed by TS";
		} 
		else if (error == ERROR_PIPE_LISTENING)
		{
			answer = "Pipe not opened from TS plugin";
		}
		else 
		{
			answer = string("Pipe error ") + to_string((long long)error);
			openPipe();
		}
	}
	outputSize -= 1;
	strncpy(output, answer.c_str(), outputSize);
}