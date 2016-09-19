#pragma once
#include <Windows.h>
#include "common.h"
class pipe_handler {
public:
	pipe_handler();
	~pipe_handler();

	static HANDLE openPipe() {
		HANDLE pipe = CreateFile(
			PIPE_NAME,
			GENERIC_READ | GENERIC_WRITE,
			FILE_SHARE_READ | FILE_SHARE_WRITE,
			NULL,
			OPEN_EXISTING,
			FILE_ATTRIBUTE_NORMAL,
			NULL
		);
		DWORD error = GetLastError();
		DWORD dwMode = PIPE_READMODE_MESSAGE;
		SetNamedPipeHandleState(
			pipe,    // pipe handle 
			&dwMode,  // new pipe mode 
			NULL,     // don't set maximum bytes 
			NULL);    // don't set maximum time 
		return pipe;
	}





};

