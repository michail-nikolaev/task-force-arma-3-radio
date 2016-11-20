#include "stdafx.h"
#include "NamedPipeTransfer.h"


NamedPipeTransfer::NamedPipeTransfer() {

	SECURITY_DESCRIPTOR SD;
	InitializeSecurityDescriptor(&SD, SECURITY_DESCRIPTOR_REVISION);
	SetSecurityDescriptorDacl(&SD, TRUE, NULL, FALSE);
	SECURITY_ATTRIBUTES SA;
	SA.nLength = sizeof(SA);
	SA.lpSecurityDescriptor = &SD;
	SA.bInheritHandle = TRUE;
	waitForDataEvent = CreateEvent(
		&SA,    // default security attribute 
		TRUE,    // manual-reset event 
		TRUE,    // initial state = signaled 
		NULL);   // unnamed event object 
   //No error handling here
}


NamedPipeTransfer::~NamedPipeTransfer() {
	CloseHandle(waitForDataEvent);
	waitForDataEvent = nullptr;
}

void NamedPipeTransfer::open() {
	openPipe();
}

void NamedPipeTransfer::close() {
	closePipe();
}

void NamedPipeTransfer::transactMessage(char* output, int outputSize, const char* input) {
	//if !pipe call openPipe. If still not open throw error and tell user what failed

	DWORD written = 0;
	OVERLAPPED pipeOverlap{ 0 };
	pipeOverlap.hEvent = waitForDataEvent;
	DWORD errorCode = ERROR_SUCCESS;
	if (!TransactNamedPipe(pipe, (void*) input, strlen(input), output, outputSize, &written, &pipeOverlap)) {
		errorCode = GetLastError();
		if (errorCode == ERROR_IO_PENDING)//Handle overlapped datatransfer
		{
			DWORD waitResult = WaitForSingleObject(waitForDataEvent, PIPE_TIMEOUT);
			errorCode = GetLastError();
			if (waitResult == WAIT_TIMEOUT) {
				errorCode = WAIT_TIMEOUT;
			} else {
				GetOverlappedResult(
					pipe, // handle to pipe 
					&pipeOverlap, // OVERLAPPED structure 
					&written,            // bytes transferred 
					FALSE);            // do not wait
				errorCode = GetLastError();
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

void NamedPipeTransfer::openPipe() {
	closePipe();

	SECURITY_DESCRIPTOR SD;
	InitializeSecurityDescriptor(&SD, SECURITY_DESCRIPTOR_REVISION);
	SetSecurityDescriptorDacl(&SD, TRUE, NULL, FALSE);
	SECURITY_ATTRIBUTES SA;
	SA.nLength = sizeof(SA);
	SA.lpSecurityDescriptor = &SD;
	SA.bInheritHandle = TRUE;

	pipe = CreateNamedPipe(
		pipeName, // name of the pipe
		PIPE_ACCESS_DUPLEX | FILE_FLAG_OVERLAPPED, // 1-way pipe -- send only
		PIPE_TYPE_MESSAGE | PIPE_READMODE_MESSAGE | PIPE_WAIT, // send data as message
		1, // only allow 1 instance of this pipe
		0, // no outbound buffer
		0, // no inbound buffer
		0, // use default wait time
		&SA // use default security attributes
	);
}

void NamedPipeTransfer::closePipe() {
	if (!pipe) return;
	CloseHandle(pipe);
	pipe = nullptr;
}
