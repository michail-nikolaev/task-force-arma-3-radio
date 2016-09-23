// dllmain.cpp: Defines the entry point for the DLL application.
#include "stdafx.h"

HANDLE pipe = INVALID_HANDLE_VALUE;
HANDLE waitForDataEvent = INVALID_HANDLE_VALUE;//#Dedmen i dont know why these are defined here. They are not needed here.

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		// Create a pipe to send data
		openPipe();
		break;
	case DLL_PROCESS_DETACH:
		closePipe();
		break;
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:	
		break;
	}
	return TRUE;
}


const int TEST_OUTPUT_SIZE = 4096;

int main(int argc, char * argv []) 
{
	DllMain(0, DLL_PROCESS_ATTACH, 0);
	char output[TEST_OUTPUT_SIZE];
	while (true) 
	{
		DWORD ticks = GetTickCount();
		for (int q = 0; q < 1000; q++) 
		{
			RVExtension(output, TEST_OUTPUT_SIZE, "VERSION\ttest\test_channel\ttest_password");
			RVExtension(output, TEST_OUTPUT_SIZE, "POS\t[TF]Nkey\t0.5\t9.3\t123.5003\t236");
			RVExtension(output, TEST_OUTPUT_SIZE, "POS\t[TF]Nkey2\t5\t-0.7\t123.5003\t236");
			RVExtension(output, TEST_OUTPUT_SIZE, "TANGENT\tPRESSED");
			RVExtension(output, TEST_OUTPUT_SIZE, "TANGENT\tRELEASED");			
		}
		printf("%f\n", (float)(GetTickCount() - ticks) / 4000.0);
		//Sleep(200);
	}
	DllMain(0, DLL_PROCESS_DETACH, 0);
}

