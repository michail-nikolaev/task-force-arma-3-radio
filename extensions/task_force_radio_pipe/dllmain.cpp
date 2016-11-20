// dllmain.cpp: Defines the entry point for the DLL application.
#include "stdafx.h"
#include "NamedPipeTransfer.h"
#include "SharedMemoryTransfer.h"

const wchar_t* pipeName = PIPE_NAME;
//NamedPipeTransfer transfer;
SharedMemoryTransfer transfer;

bool isDebugArmaInstance() {
	std::wstring execPath(GetCommandLine());
	if (std::string::npos != execPath.find(DEBUG_PARAMETER)) {
		return true;
	}
	return false;
}

BOOL APIENTRY DllMain(HMODULE hModule,
	DWORD  ul_reason_for_call,
	LPVOID lpReserved
) {
	switch (ul_reason_for_call) {
		case DLL_PROCESS_ATTACH:
			// Create a pipe to send data
			if (isDebugArmaInstance()) pipeName = DEBUG_PIPE_NAME;
			transfer.open();
			break;
		case DLL_PROCESS_DETACH:
			transfer.close();
			break;
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
			break;
	}
	return TRUE;
}


const int TEST_OUTPUT_SIZE = 4096;
class speedTest {
public:
	explicit speedTest(const std::string & name_, bool willPrintOnDestruct_ = true) :start(std::chrono::high_resolution_clock::now()), name(name_), willPrintOnDestruct(willPrintOnDestruct_) {}
	~speedTest() { if (willPrintOnDestruct) log(); }
	void log() const {
		std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(now - start).count();
		printf("%s %llu\n", name.c_str(), duration / 10000);
	}
	void reset() {
		start = std::chrono::high_resolution_clock::now();
	}
	std::chrono::microseconds getCurrentElapsedTime() const {
		std::chrono::high_resolution_clock::time_point now = std::chrono::high_resolution_clock::now();
		return std::chrono::duration_cast<std::chrono::microseconds>(now - start);
	}
	std::chrono::high_resolution_clock::time_point start;
	std::string name;
	bool willPrintOnDestruct;
};
int main(int argc, char * argv[]) {
	DllMain(0, DLL_PROCESS_ATTACH, 0);
	char output[TEST_OUTPUT_SIZE];
	while (true) {
		{
			speedTest test("");
			//DWORD ticks = GetTickCount();
			for (int q = 0; q < 10000; q++) {
				//RVExtension(output, TEST_OUTPUT_SIZE, "VERSION\ttest\test_channel\ttest_password~");
				RVExtension(output, TEST_OUTPUT_SIZE, "POS\tdedmen\t[0,0,0]\t243\ttrue\ttrue\ttrue\tfalse\tno\t0\t1\t243\t0");
				//RVExtension(output, TEST_OUTPUT_SIZE, "IS_SPEAKING\tdedmen");
				//RVExtension(output, TEST_OUTPUT_SIZE, "POS\t[TF]Nkey2\t5\t-0.7\t123.5003\t236~");
				//RVExtension(output, TEST_OUTPUT_SIZE, "TANGENT\tPRESSED~");
				//RVExtension(output, TEST_OUTPUT_SIZE, "TANGENT\tRELEASED~");
				//printf("%lli\n", time.time_since_epoch().count());
			}
			//printf("%f\n", (float)(GetTickCount() - ticks) / 4000.0);
		}
		//Sleep(200);
	}
	DllMain(0, DLL_PROCESS_DETACH, 0);
}

