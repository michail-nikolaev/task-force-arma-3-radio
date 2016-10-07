// task_force_radio_pipe.cpp: Defines the exported functions for the DLL application.
//
#include "stdafx.h"

DWORD dwMessageMode = PIPE_READMODE_MESSAGE;

void closePipe()
{
	CloseHandle(pipe);
	CloseHandle(waitForDataEvent);
	pipe = INVALID_HANDLE_VALUE;
	waitForDataEvent = INVALID_HANDLE_VALUE;
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
			PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE, // send data as message
			1, // only allow 1 instance of this pipe
			0, // no outbound buffer
			0, // no inbound buffer
			0, // use default wait time
			&SA // use default security attributes
		);
	waitForDataEvent = CreateEvent(
		&SA,    // default security attribute 
		TRUE,    // manual-reset event 
		TRUE,    // initial state = signaled 
		NULL);   // unnamed event object 
}

void __stdcall RVExtension(char *output, int outputSize, const char *input)
{
	if(input[0] == '\0')
		return;

	DWORD written = 0;
	OVERLAPPED pipeOverlap;
	pipeOverlap.hEvent = waitForDataEvent;
	DWORD errorCode = ERROR_SUCCESS;
	if (!TransactNamedPipe(pipe, (void*) input, strlen(input), output, outputSize, &written, &pipeOverlap)) {
		errorCode = GetLastError();
		if (errorCode == ERROR_IO_PENDING)//Handle overlapped datatransfer
		{
			DWORD waitResult = WaitForSingleObject(waitForDataEvent, PIPE_TIMEOUT);
			if (waitResult == WAIT_TIMEOUT) {
				errorCode = WAIT_TIMEOUT;
			} else {
				GetOverlappedResult(
					pipe, // handle to pipe 
					&pipeOverlap, // OVERLAPPED structure 
					&written,            // bytes transferred 
					FALSE);            // do not wait

				if (written == 0)
					errorCode = ERROR_NO_DATA;
				else
					return;	 //successful read. We dont need to handle any errors
			}
		}

		//When WAIT_TIMEOUT happens teamspeak is likely unresponsive or crashed so we still reopen the pipe
		if (errorCode != ERROR_PIPE_LISTENING) openPipe();
		printf("ERROR: %d\n", errorCode);
		switch (errorCode) {
			case ERROR_NO_DATA:
			case WAIT_TIMEOUT:
				strncpy_s(output, outputSize, "Pipe was closed by TS", _TRUNCATE);
				break;
			case ERROR_PIPE_LISTENING:
				strncpy_s(output, outputSize, "Pipe not opened from TS plugin", _TRUNCATE);
				break;
			case ERROR_BAD_PIPE:
				strncpy_s(output, outputSize, "Not connected to TeamSpeak", _TRUNCATE);
				break;
			default:
				char unknownError[16];
				sprintf_s(unknownError, 16, "Pipe error %i", errorCode);
				strncpy_s(output, outputSize, unknownError, _TRUNCATE);
				break;
		}
	}
}
