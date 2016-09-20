#include "task_force_radio.hpp"
#include <Windows.h>
#include <wininet.h>
#include "common.h"
task_force_radio::task_force_radio() {}


task_force_radio::~task_force_radio() {}

bool task_force_radio::isUpdateAvailable() {
	DWORD dwBytes;
	char ch;
	std::string pluginVersion;

	DWORD r = 0;
	if (!InternetGetConnectedState(&r, 0)) return false;
	if (r & INTERNET_CONNECTION_OFFLINE) return false;

	HINTERNET Initialize = InternetOpen(L"TFAR", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
	HINTERNET Connection = InternetConnect(Initialize, UPDATE_URL, INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
	HINTERNET File = HttpOpenRequest(Connection, NULL, UPDATE_FILE, NULL, NULL, NULL, 0, 0);

	if (HttpSendRequest(File, NULL, 0, NULL, 0)) {
		while (InternetReadFile(File, &ch, 1, &dwBytes)) {
			if (dwBytes != 1)break;
			pluginVersion += ch;
		}
	}
	InternetCloseHandle(File);
	InternetCloseHandle(Connection);
	InternetCloseHandle(Initialize);
	std::string currentVersion = PLUGIN_VERSION;
	if (pluginVersion.length() < 10) {
		return Version(pluginVersion) > Version(currentVersion);
	} else {
		return false;
	}
}

DWORD WINAPI UpdateThread(LPVOID lpParam) {
	if (task_force_radio::isUpdateAvailable()) {
		MessageBox(NULL, L"New version of Task Force Arrowhead Radio is available. Check radio.task-force.ru/en", L"Task Force Arrowhead Radio Update", MB_OK);
	}
	return 0;
}

std::string piwikUrl;

DWORD WINAPI trackPiwikThread(LPVOID lpParam) {
	DWORD dwBytes;
	DWORD r = 0;
	char ch;
	if (!InternetGetConnectedState(&r, 0)) return -1;
	if (r & INTERNET_CONNECTION_OFFLINE) return -1;

	HINTERNET Initialize = InternetOpen(L"TFAR", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
	HINTERNET Connection = InternetConnect(Initialize, PIWIK_URL, INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
	HINTERNET File = HttpOpenRequestA(Connection, NULL, piwikUrl.c_str(), NULL, NULL, NULL, 0, 0);
	if (HttpSendRequest(File, NULL, 0, NULL, 0)) {
		while (InternetReadFile(File, &ch, 1, &dwBytes)) {
			if (dwBytes != 1) break;
		}
	}
	InternetCloseHandle(File);
	InternetCloseHandle(Connection);
	InternetCloseHandle(Initialize);
	return 0;
}

void task_force_radio::trackPiwik(std::string url) {
	piwikUrl = url;
	CreateThread(NULL, 0, trackPiwikThread, NULL, 0, NULL);
}

void task_force_radio::createCheckForUpdateThread() {
	CreateThread(NULL, 0, UpdateThread, NULL, 0, NULL);
}

int task_force_radio::versionNumber(std::string versionString) {
	int number = 0;
	for (unsigned int q = 0; q < versionString.length(); q++) {
		char ch = versionString.at(q);
		if (isdigit(ch)) {
			number += (ch - 48);
		}
		if (ch == '.') {
			number *= 10;
		}
	}
	return number;
}

