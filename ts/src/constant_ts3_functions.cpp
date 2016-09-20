#include "public_errors.h"
#include "public_errors_rare.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"
#include "plugin.h"
#include "ts3_functions.h"
#include "common.h"
#include <Windows.h>
extern struct TS3Functions ts3Functions;
extern char* pluginID;
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
		case 20: return 21;
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


/****************************** Optional functions ********************************/
/*
* Following functions are optional, if not needed you don't need to implement them.
*/

/* Tell client if plugin offers a configuration window. If this function is not implemented, it's an assumed "does not offer" (PLUGIN_OFFERS_NO_CONFIGURE). */
int ts3plugin_offersConfigure() {
	 /*
	 * Return values:
	 * PLUGIN_OFFERS_NO_CONFIGURE         - Plugin does not implement ts3plugin_configure
	 * PLUGIN_OFFERS_CONFIGURE_NEW_THREAD - Plugin does implement ts3plugin_configure and requests to run this function in an own thread
	 * PLUGIN_OFFERS_CONFIGURE_QT_THREAD  - Plugin does implement ts3plugin_configure and requests to run this function in the Qt GUI thread
	 */
	return PLUGIN_OFFERS_NO_CONFIGURE;  /* In this case ts3plugin_configure does not need to be implemented */
}
/*
* If the plugin wants to use error return codes, plugin commands, hotkeys or menu items, it needs to register a command ID. This function will be
* automatically called after the plugin was initialized. This function is optional. If you don't use these features, this function can be omitted.
* Note the passed pluginID parameter is no longer valid after calling this function, so you must copy it and store it in the plugin.
*/
void ts3plugin_registerPluginID(const char* id) {
	const size_t sz = strlen(id) + 1;
	pluginID = (char*) malloc(sz * sizeof(char));
	_strcpy(pluginID, sz, id);  /* The id buffer will invalidate after exiting this function */
	std::string message = std::string("registerPluginID: ") + std::string(pluginID);
	log(message.c_str(), LogLevel_INFO);
}

/* Plugin command keyword. Return NULL or "" if not used. */
const char* ts3plugin_commandKeyword() {
	return "";
}

/* Plugin processes console command. Return 0 if plugin handled the command, 1 if not handled. */
int ts3plugin_processCommand(uint64 serverConnectionHandlerID, const char* command) {
	return 0;  /* Plugin handled command */
}

/* Client changed current server connection handler */
void ts3plugin_currentServerConnectionChanged(uint64 serverConnectionHandlerID) {
}

/*
* Implement the following three functions when the plugin should display a line in the server/channel/client info.
* If any of ts3plugin_infoTitle, ts3plugin_infoData or ts3plugin_freeMemory is missing, the info text will not be displayed.
*/

/* Static title shown in the left column in the info frame */
const char* ts3plugin_infoTitle() {
	std::string info = std::string("Task Force Radio Status (") + PLUGIN_VERSION + ")";
	size_t maxLen = info.length() + 1;
	char* result = (char*) malloc(maxLen * sizeof(char));
	memset(result, 0, maxLen);
	strncpy_s(result, maxLen, info.c_str(), info.length());
	return (const char*) result;
}

/* Required to release the memory for parameter "data" allocated in ts3plugin_infoData and ts3plugin_initMenus */
void ts3plugin_freeMemory(void* data) {
	free(data);
}

/*
* Plugin requests to be always automatically loaded by the TeamSpeak 3 client unless
* the user manually disabled it in the plugin dialog.
* This function is optional. If missing, no autoload is assumed.
*/
int ts3plugin_requestAutoload() {
	return 1;  /* 1 = request autoloaded, 0 = do not request autoload */
}

int ts3plugin_onServerErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, const char* extraMessage) {
	if (returnCode) {
		/* A plugin could now check the returnCode with previously (when calling a function) remembered returnCodes and react accordingly */
		/* In case of using a a plugin return code, the plugin can return:
		* 0: Client will continue handling this error (print to chat tab)
		* 1: Client will ignore this error, the plugin announces it has handled it */
		return 1;
	}
	return 0;  /* If no plugin return code was used, the return value of this function is ignored */
}

int ts3plugin_onServerPermissionErrorEvent(uint64 serverConnectionHandlerID, const char* errorMessage, unsigned int error, const char* returnCode, unsigned int failedPermissionID) {
	return 0;  /* See onServerErrorEvent for return code description */
}