#include "public_errors.h"
#include "public_errors_rare.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"
#include "plugin.h"
#include "ts3_functions.h"
#include "common.h"
#include <Windows.h>
extern struct TS3Functions ts3Functions;
/*********************************** Required functions ************************************/
/*
* If any of these required functions is not implemented, TS3 will refuse to load the plugin
*/

/* Unique name identifying this plugin */
const char* ts3plugin_name() {
	return "Task Force Arma 3 Radio";
}

/* Plugin version */
const char* ts3plugin_version() {
	return PLUGIN_VERSION;
}

/* Plugin API version. Must be the same as the clients API major version, else the plugin fails to load. */
#pragma comment (lib, "version.lib")
int ts3plugin_apiVersion() {

	WCHAR fileName[_MAX_PATH];
	DWORD size = GetModuleFileName(0, fileName, _MAX_PATH);
	fileName[size] = NULL;
	DWORD handle = 0;
	size = GetFileVersionInfoSize(fileName, &handle);
	BYTE* versionInfo = new BYTE[size];
	if (!GetFileVersionInfo(fileName, handle, size, versionInfo)) {
		delete[] versionInfo;
		return PLUGIN_API_VERSION;
	}
	UINT    			len = 0;
	VS_FIXEDFILEINFO*   vsfi = NULL;
	VerQueryValue(versionInfo, L"\\", (void**) &vsfi, &len);
	short version = HIWORD(vsfi->dwFileVersionLS);
	delete[] versionInfo;
	switch (version) {
		case 9: return 19;
		case 10: return 19;
		case 11: return 19;
		case 12: return 19;
		case 13: return 19;
		case 14: return 20;
		case 15: return 20;
		case 16: return 20;
		case 17: return 20;
		case 18: return 20;
		case 19: return 20;
		default: return PLUGIN_API_VERSION;
	}
}

/* Plugin author */
const char* ts3plugin_author() {
	/* If you want to use wchar_t, see ts3plugin_name() on how to use */
	return "[TF]Nkey";
}

/* Plugin description */
const char* ts3plugin_description() {
	/* If you want to use wchar_t, see ts3plugin_name() on how to use */
	return "Radio Addon for Arma 3";
}

/* Set TeamSpeak 3 callback functions */
void ts3plugin_setFunctionPointers(const struct TS3Functions funcs) {
	ts3Functions = funcs;
}