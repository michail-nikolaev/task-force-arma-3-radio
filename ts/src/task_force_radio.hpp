#pragma once
#include <stdint.h>
#include <string>
#include "settings.hpp"
#include "SignalSlot.hpp"
#include "serverData.hpp"

class PlaybackHandler;
class CommandProcessor;



struct FREQ_SETTINGS {
	int volume;
	stereoMode stereoMode;
	std::string radioClassname;
};

struct SPEAKER_DATA {
	std::string radio_id;
	std::weak_ptr<clientData> client;
	Position3D pos;
	int volume;
	vehicleDescriptor vehicle;
	float waveZ;
};

//Data from game about the local player
class gameData {
public:

	void setFreqInfos(const std::vector<std::string>& tokens) {
		LockGuard_exclusive<ReadWriteLock> lock(&m_lock);
		mySwFrequencies = helpers::parseFrequencies(tokens[1]);
		myLrFrequencies = helpers::parseFrequencies(tokens[2]);
		myDdFrequency = tokens[3];
		alive = tokens[4] == "true";
	

		//auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
		//if (clientDataDir && clientDataDir->myClientData && clientDataDir->myClientData->clientTalkingNow) {
		//#TODO resend teamspeak VOLUME command if myVoiceVolume changed while talking
		//}

		myVoiceVolume = helpers::parseArmaNumberToInt(tokens[5]); 
		ddVolumeLevel = helpers::parseArmaNumberToInt(tokens[6]);
		wavesLevel = helpers::parseArmaNumber(tokens[8]);
		terrainIntersectionCoefficient = helpers::parseArmaNumber(tokens[9]);
		globalVolume = helpers::parseArmaNumber(tokens[10]);
		receivingDistanceMultiplicator = helpers::parseArmaNumber(tokens[12]);
		speakerDistance = helpers::parseArmaNumber(tokens[13]);
	}
	mutable ReadWriteLock m_lock;
	std::map<std::string, FREQ_SETTINGS> mySwFrequencies;
	std::map<std::string, FREQ_SETTINGS> myLrFrequencies;

	std::string myDdFrequency;
	std::multimap<std::string, SPEAKER_DATA> speakers;

	int ddVolumeLevel{0};
	int myVoiceVolume{0};
	bool alive{false};
	float wavesLevel{0};
	float terrainIntersectionCoefficient{7.f};
	float globalVolume{1.f};
	float receivingDistanceMultiplicator{1.f};
	float speakerDistance{20.f};

	int currentDataFrame{ INVALID_DATA_FRAME };


	std::string getCurrentTransmittingRadio() const { LockGuard_shared<ReadWriteLock> lock(&m_lock); return currentTransmittingRadio; }
	void setCurrentTransmittingRadio(std::string val) { LockGuard_exclusive<ReadWriteLock> lock(&m_lock); currentTransmittingRadio = val; }
	bool tangentPressed{ false };
	std::chrono::milliseconds pttDelay {0ms};
private:
	std::string currentTransmittingRadio{ "" };//Used for half-duplex mode
};


class TFAR {
public:
	TFAR();
	~TFAR();


	static TFAR& getInstance();

	static void trackPiwik(const std::vector<std::string>& piwikData);
	static void createCheckForUpdateThread();
	static std::shared_ptr<CommandProcessor>& getCommandProcessor();
	static std::shared_ptr<PlaybackHandler>& getPlaybackHandler();
	static std::shared_ptr<serverDataDirectory>& getServerDataDirectory();
    static settings config;//I'd like to use settings as the variable name. But... meh

	
	Signal<void()> onGameStart;
	Signal<void()> onGameEnd;

	Signal<void()> onGameConnected;//Called when Pipe connected to game
	Signal<void()> onGameDisconnected;//Called when Pipe disconnected from game

	Signal<void()> onShutdown;


   //Teamspeak events. They are here because Teamspeak class is fully static
	Signal<void(TSServerID serverID)> onTeamspeakServerConnect;
	Signal<void(TSServerID serverID)> onTeamspeakServerDisconnect;
	Signal<void(TSServerID serverID, TSClientID clientID, const std::string& clientNickname)> onTeamspeakClientJoined;
	Signal<void(TSServerID serverID, TSClientID clientID)> onTeamspeakClientLeft; //If clientID == -2 all clients Left (aka channel switched)
	Signal<void(TSServerID serverID, TSClientID clientID, const std::string& clientNickname)> onTeamspeakClientUpdated; //Some variable about him updated. Probably his nickname

	//Variable accessors
	std::string getPluginPath() const { return pluginPath; }
	void setPluginPath(const std::string& val) { pluginPath = val; }
	std::string getPluginID() const { return pluginID; }
	void setPluginID(const std::string& val) { pluginID = val; }
	bool getCurrentlyInGame() const { return currentlyInGame; }
	void setCurrentlyInGame(bool val) { currentlyInGame = val; }

	gameData m_gameData;
	
	
	struct Version {
		explicit Version(std::string versionStr) {
			auto split = helpers::split(versionStr, '.');
			for (auto& it : split) {
				versionNumbers.push_back(std::stoi(it));
			}
		}

		bool operator>(const Version &otherVersion) const {
			for (size_t i = 0; i < std::min(versionNumbers.size(), otherVersion.versionNumbers.size()); ++i) {
				if (versionNumbers[i] < otherVersion.versionNumbers[i])
					return false;
			}
			return true;
		}
		std::vector<int> versionNumbers;
	};

private:
	std::string pluginPath;
	std::string pluginID;
	static bool isUpdateAvailable();
	std::shared_ptr<PlaybackHandler> m_playbackHandler;
	std::shared_ptr<CommandProcessor> m_commandProcessor;
	std::shared_ptr<serverDataDirectory> m_serverData;
	bool currentlyInGame;


};

