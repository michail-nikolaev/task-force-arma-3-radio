// task_force_radio_pipe.cpp: определяет экспортированные функции для приложения DLL.
//

#include "stdafx.h"

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
	if (pipe == INVALID_HANDLE_VALUE) 
	{
		DWORD error = GetLastError();
		int a = 3;
	}

}

void __stdcall RVExtension(char *output, int outputSize, const char *input)
{
	if(input[0] == '\0')
		return;
	DWORD written = 0;	
	string answer;
	
	DWORD dwMode = PIPE_READMODE_MESSAGE; 
	bool fSuccess= SetNamedPipeHandleState( 
		pipe,    // pipe handle 
		&dwMode,  // new pipe mode 
		NULL,     // don't set maximum bytes 
		NULL);    // don't set maximum time 
	if (fSuccess) 
	{					
		if (TransactNamedPipe(pipe, (void*) input, strlen(input), output, outputSize, &written, NULL))
		{		
			int a = 3;
		} else {
			printf("error");
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
				if (error == 230) 
				{
					answer = "Not connected to TeamSpeak";
				} else {
					answer = string("Pipe error ") + to_string((long long)error);
				}
				openPipe();
			}
		}
	} else {
		answer = "SetNamedPipeHandleState failed.\n"; 
	}	
	if (answer.length() > 0) {
		strncpy(output, answer.c_str(), outputSize);
	}
}
