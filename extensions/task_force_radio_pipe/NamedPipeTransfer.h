#pragma once

class NamedPipeTransfer {
public:
	NamedPipeTransfer();
	~NamedPipeTransfer();
	void open();
	void close();
	void transactMessage(char *output, int outputSize, const char *input);
private:
	void openPipe();
	void closePipe();
	HANDLE pipe = nullptr;
	HANDLE waitForDataEvent = nullptr;
};

