#include "task_force_radio.hpp"
#include <Windows.h>
#include <wininet.h>
#include "common.hpp"
#include <thread>
#include <locale>
#include "CommandProcessor.hpp"
#include "PlaybackHandler.hpp"
#include "serverData.hpp"
#include "Teamspeak.hpp"
#include "Logger.hpp"

extern struct TS3Functions ts3Functions;


TFAR::TFAR() {
	onGameDisconnected.connect([this]() {
		Logger::log(LoggerTypes::profiler, "On Game Disconnected", LogLevel_DEVEL);
		Teamspeak::unmuteAll(ts3Functions.getCurrentServerConnectionHandlerID());
		if (getCurrentlyInGame()) {
			TFAR::getInstance().getPlaybackHandler()->playWavFile("radio-sounds/off");
			onGameEnd();
			TFAR::config.setRefresh();
		}
		setCurrentlyInGame(false);
	});

	onGameConnected.connect([this]() {
		Logger::log(LoggerTypes::profiler, "On Game Connected", LogLevel_DEVEL);
		std::string channelName = TFAR::config.get<std::string>(Setting::serious_channelName);
		if (!getCurrentlyInGame() && channelName.length() > 0) {
			getPlaybackHandler()->playWavFile("radio-sounds/on");
			setCurrentlyInGame(true);
			onGameStart();
			m_gameData.currentDataFrame = 0;
		}
		
	});

	onGameStart.connect([this]() {
		Logger::log(LoggerTypes::profiler, "On Respawn", LogLevel_DEVEL);
		if (!Teamspeak::isConnected())
			return;

		Teamspeak::moveToSeriousChannel();
	});
	
	onGameEnd.connect([this]()
	{
        Logger::log(LoggerTypes::profiler, "On Game End", LogLevel_DEVEL);
		TSServerID currentServer = ts3Functions.getCurrentServerConnectionHandlerID();
		TSClientID myClientID = Teamspeak::getMyId(currentServer);
		Teamspeak::moveFromSeriousChannel(currentServer);
		Teamspeak::resetMyNickname(currentServer);
		Teamspeak::unmuteAll(currentServer); //this may be called twice. If End was caused by PluginDisconnect. But will return immediatly if there are no muted clients
	});

	onShutdown.connect([this]() {

		onGameStart.removeAllSlots(); //clear all Signals slots so they cannot possibly be called after shutdown
		onGameEnd.removeAllSlots();
		onGameConnected.removeAllSlots();
		onGameDisconnected.removeAllSlots();
		onTeamspeakServerConnect.removeAllSlots();
		onTeamspeakClientJoined.removeAllSlots();
		onTeamspeakClientLeft.removeAllSlots();
		onTeamspeakClientUpdated.removeAllSlots();

		if (getCurrentlyInGame())
			onGameEnd();
		if (m_commandProcessor)
			m_commandProcessor->stopThread();
	});
    config.configValueSet.connect([](const Setting& setting) {
		if (setting == Setting::serious_channelName || setting == Setting::serious_channelPassword)
        Teamspeak::moveToSeriousChannel();
    });
}


TFAR::~TFAR() {}

TFAR& TFAR::getInstance() {
	static TFAR tfarSingleton;
	return tfarSingleton;
}

settings TFAR::config;//declaring the static config

bool TFAR::isUpdateAvailable() {
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
#include <sstream>
void TFAR::trackPiwik(const std::vector<std::string>& piwikData) {

	/*
	piwikData
	 {
		 0 "TRACK",
		 1 string actiontype,
		 2 string uid,
		 3 array customVariables	[1,"name","value"]
	 }

	*/


	std::thread([piwikData]() {

		struct trackerCustomVariable {
			unsigned int customVarID;
			std::string name;
			std::string value;
		};
		auto parseCustomVariables = [](const std::string& customVarArray) -> std::vector<trackerCustomVariable> {
			std::vector<trackerCustomVariable> out;
			std::istringstream inStream(customVarArray);
			char curChar;
			//   [[1,"name","value"], [2, "name2", "value2"]]
			inStream >> curChar;//should be [
			//  [[1,"name","value"], [2, "name2", "value2"]]
			while (curChar != '[') inStream >> curChar;	//but we still wait till [ in case input starts with whitespace
			//[1,"name","value"], [2, "name2", "value2"]]


			//http://stackoverflow.com/a/17976541
			auto trimWhitespaceColon = [](const std::string &s) -> std::string {
				auto wsfront = std::find_if_not(s.begin(), s.end(), [](char c) {return c == ' ' || c == '"'; });
				auto wsback = std::find_if_not(s.rbegin(), s.rend(), [](char c) {return c == ' ' || c == '"'; }).base();
				return (wsback <= wsfront ? std::string() : std::string(wsfront, wsback));
			};


			bool firstBracket = true; //Used to skip first [ of [[
			while (!inStream.eof()) {
				if (curChar == '[') {  //new custom Variable
					if (firstBracket) {
						firstBracket = false;
						inStream >> curChar;
						continue;
					}
					//[1,"name","value"], [2, "name2", "value2"]]
					trackerCustomVariable newCustomVar;
					std::string id;
					inStream >> curChar; //curChar has ID now
					while (curChar != ',') {
						id.push_back(curChar);
						inStream >> curChar;
					}
					try {
						newCustomVar.customVarID = std::stoi(id);
					}
					catch (...) { return std::vector<trackerCustomVariable>(); }

					inStream >> curChar;//curChar has first char of name
					//"name","value"], [2, "name2", 22]]
					while (curChar != ',') {
						newCustomVar.name.push_back(curChar);
						inStream >> curChar;
					}
					//newCustomVar.name can be '  "name"  ' or '  223  ' so need to trim " and whitespace
					newCustomVar.name = trimWhitespaceColon(newCustomVar.name);

					//"value"], [2, "name2", "value2"]]
					inStream >> curChar;//curChar has "
					while (curChar != ']') {
						newCustomVar.value.push_back(curChar);
						inStream >> curChar;
					}
					newCustomVar.value = trimWhitespaceColon(newCustomVar.value);

					out.push_back(newCustomVar);
					//], [2, "name2", "value2"]]
				}
				inStream >> curChar;
			}
			return out;
		};

		std::vector<trackerCustomVariable> customVariables = parseCustomVariables(piwikData[3]);
		if (customVariables.empty()) return;
		std::stringstream request;
		if (piwikData[1] == "beta")		 //#Release remove on release
			request << "piwik.php?idsite=2&rec=1&url=\"piwik.dedmen.de\"";
		else
			request << "piwik.php?idsite=2&rec=1&url=\"radio.task-force.ru\"";
		request << "&action_name=" << piwikData[1];
		request << "&rand=" << rand();
		request << "&uid=" << piwikData[2];
		request << "&cvar={";
		bool firstVar = true;
		for (trackerCustomVariable& customVar : customVariables) {
			if (!firstVar) request << ',';
			firstVar = false;
			request << '"' << customVar.customVarID << "\":";//"1":
			request << '[';
			request << '"' << customVar.name << "\",";//"name",
			request << '"' << customVar.value << '"';//"value"
			request << ']';
			//"1":["name","value"]
		}
		request << "}";//closing cvar again
		std::string requestString = request.str();

		DWORD dwBytes;
		DWORD r = 0;
		char ch;
		if (!InternetGetConnectedState(&r, 0)) return;
		if (r & INTERNET_CONNECTION_OFFLINE) return;

		HINTERNET Initialize = InternetOpen(L"TFAR", INTERNET_OPEN_TYPE_PRECONFIG, NULL, NULL, 0);
		HINTERNET Connection;
		if (piwikData[1] == "beta")
			Connection = InternetConnect(Initialize, L"piwik.dedmen.de", INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
		else
			Connection = InternetConnect(Initialize, PIWIK_URL, INTERNET_DEFAULT_HTTP_PORT, NULL, NULL, INTERNET_SERVICE_HTTP, 0, 0);
		HINTERNET File = HttpOpenRequestA(Connection, NULL, requestString.c_str(), NULL, NULL, NULL, 0, 0);
		if (HttpSendRequest(File, NULL, 0, NULL, 0)) {
			while (InternetReadFile(File, &ch, 1, &dwBytes)) {
				if (dwBytes != 1) break;
			}
		}
		InternetCloseHandle(File);
		InternetCloseHandle(Connection);
		InternetCloseHandle(Initialize);
	}).detach();
}

void TFAR::createCheckForUpdateThread() {
	std::thread([]() {
		if (isUpdateAvailable()) {
			MessageBox(NULL, L"New version of Task Force Arrowhead Radio is available. Check radio.task-force.ru/en", L"Task Force Arrowhead Radio Update", MB_OK);
		}
	}).detach();
}

std::shared_ptr<CommandProcessor>& TFAR::getCommandProcessor() {
	if (!getInstance().m_commandProcessor)
		getInstance().m_commandProcessor = std::make_shared<CommandProcessor>();
	return getInstance().m_commandProcessor;
}

std::shared_ptr<PlaybackHandler>& TFAR::getPlaybackHandler() {
	if (!getInstance().m_playbackHandler)
		getInstance().m_playbackHandler = std::make_shared<PlaybackHandler>();
	return getInstance().m_playbackHandler;
}

std::shared_ptr<serverDataDirectory>& TFAR::getServerDataDirectory() {
	if (!getInstance().m_serverData)
		getInstance().m_serverData = std::make_shared<serverDataDirectory>();
	return getInstance().m_serverData;
}

