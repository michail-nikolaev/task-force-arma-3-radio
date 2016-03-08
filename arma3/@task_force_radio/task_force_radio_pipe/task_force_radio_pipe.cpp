// task_force_radio_pipe.cpp: определяет экспортированные функции для приложения DLL.
//

#include "stdafx.h"

DWORD dwMessageMode = PIPE_READMODE_MESSAGE;

void closePipe()
{
	CloseHandle(pipe);
	pipe = INVALID_HANDLE_VALUE;
}

bool isDebugArmaInstance() 
{		
	std::wstring execPath(GetCommandLine());
	if (std::string::npos != execPath.find(DEBUG_PARAMETER))
	{
		return true;
	}	
	return false;
}



void openPipe() 
{
	closePipe();
	LPCWSTR pipeName = PIPE_NAME;
	if (isDebugArmaInstance()) pipeName = DEBUG_PIPE_NAME;

	SECURITY_DESCRIPTOR SD;
	InitializeSecurityDescriptor(&SD, SECURITY_DESCRIPTOR_REVISION);
	SetSecurityDescriptorDacl(&SD, TRUE, NULL, FALSE);
	SECURITY_ATTRIBUTES SA;
	SA.nLength = sizeof(SA);
	SA.lpSecurityDescriptor = &SD;
	SA.bInheritHandle = TRUE;

	pipe = CreateNamedPipe(
			pipeName, // name of the pipe
			PIPE_ACCESS_DUPLEX| FILE_FLAG_OVERLAPPED, // 1-way pipe -- send only
			PIPE_TYPE_MESSAGE, // send data as message
			1, // only allow 1 instance of this pipe
			0, // no outbound buffer
			0, // no inbound buffer
			0, // use default wait time
			&SA // use default security attributes
		);

}

void __stdcall RVExtension(char *output, int outputSize, const char *input)
{
	if(input[0] == '\0')
		return;

	if (SetNamedPipeHandleState(
		pipe,    // pipe handle 
		&dwMessageMode,  // new pipe mode 
		NULL,     // don't set maximum bytes 
		NULL)   // don't set maximum time fSuccess
		)
	{		
		DWORD written = 0;
		if (!TransactNamedPipe(pipe, (void*) input, strlen(input), output, outputSize, &written, NULL))		
		{
			DWORD errorCode = GetLastError();
			if (errorCode != ERROR_PIPE_LISTENING) openPipe();
			switch (errorCode)
			{
			case ERROR_NO_DATA:
				strncpy_s(output, outputSize, "Pipe was closed by TS", _TRUNCATE);
				break;
			case ERROR_PIPE_LISTENING:
				strncpy_s(output, outputSize, "Pipe not opened from TS plugin", _TRUNCATE);
				break;
			case 230:
				strncpy_s(output, outputSize, "Not connected to TeamSpeak", _TRUNCATE);
				break;
			default:
				char unknownError[16];
				sprintf_s(unknownError, strlen(unknownError), "Pipe error %i", errorCode);
				strncpy_s(output, outputSize, unknownError, _TRUNCATE);
				break;
			}
		}
	}
}
