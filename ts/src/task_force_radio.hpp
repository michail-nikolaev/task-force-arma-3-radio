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
	std::string nickname;
	Position3D pos;
	int volume;
	std::pair<std::string, float> vehicle;
	float waveZ;
};

//Data from game about the local player
class gameData {
public:

	void setFreqInfos(const std::vector<std::string>& tokens) {
		mySwFrequencies = helpers::parseFrequencies(tokens[1]);
		myLrFrequencies = helpers::parseFrequencies(tokens[2]);
		myDdFrequency = tokens[3];
		alive = tokens[4] == "true";
		myVoiceVolume = helpers::parseArmaNumberToInt(tokens[5]); //#TODO if this changes while we are ingame. Tell everyone in our channel. maybe 
		ddVolumeLevel = helpers::parseArmaNumberToInt(tokens[6]);
		wavesLevel = helpers::parseArmaNumber(tokens[8]);
		terrainIntersectionCoefficient = helpers::parseArmaNumber(tokens[9]); //#TODO make setter function and PluginConfigSetting
		globalVolume = helpers::parseArmaNumber(tokens[10]);
		receivingDistanceMultiplicator = helpers::parseArmaNumber(tokens[12]);
		speakerDistance = helpers::parseArmaNumber(tokens[13]);
	}
	std::map<std::string, FREQ_SETTINGS> mySwFrequencies;
	std::map<std::string, FREQ_SETTINGS> myLrFrequencies;

	std::string myDdFrequency;
	std::multimap<std::string, SPEAKER_DATA> speakers;
	std::map<std::string, clunk::WavFile*> waves;//#TODO deprecate this is local to playback handler

	  //#TODO mutex

	int ddVolumeLevel{0};
	int myVoiceVolume{0};
	bool alive{false};
	float wavesLevel{0};
	float terrainIntersectionCoefficient{7.f};
	float globalVolume{1.f};
	float receivingDistanceMultiplicator{1.f};
	float speakerDistance{20.f};

	int currentDataFrame{ INVALID_DATA_FRAME };

	std::string currentTransmittingRadio{""};//Used for half-duplex mode
	bool tangentPressed{false};
	 //#TODO RWLock	remember no Lock for small types.. bool,float,int
};


class TFAR {
public:
	TFAR();
	~TFAR();


	static TFAR& getInstance();

	static void trackPiwik(const std::vector<std::string>& piwikData);
	static void createCheckForUpdateThread();
	static int versionNumber(std::string versionString);
	static std::shared_ptr<CommandProcessor>& getCommandProcessor();
	static std::shared_ptr<PlaybackHandler>& getPlaybackHandler();
	static std::shared_ptr<serverDataDirectory>& getServerDataDirectory();
	static settings config;//I'd like to use settings as the variable name. But... meh

	
	Signal<void()> onGameStart;
	Signal<void()> onGameEnd;

	Signal<void()> onGameConnected;//Called when Pipe connected to game
	Signal<void()> onGameDisconnected;//Called when Pipe disconnected from game

	Signal<void()> onShutdown;//#TODO clear all Signals slots so they cannot possibly be called after shutdown


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

	gameData m_gameData;//#TODO getter


private:
	std::string pluginPath;
	std::string pluginID;
	static bool isUpdateAvailable();
	std::shared_ptr<PlaybackHandler> m_playbackHandler;
	std::shared_ptr<CommandProcessor> m_commandProcessor;
	std::shared_ptr<serverDataDirectory> m_serverData;
	bool currentlyInGame;

	struct Version {   //http://stackoverflow.com/questions/14374272/how-to-parse-version-number-to-compare-it
		explicit Version(std::string versionStr) {
			major = 0; minor = 0; revision = 0; build = 0;
			sscanf(versionStr.c_str(), "%d.%d.%d.%d", &major, &minor, &revision, &build);
		}

		bool operator>(const Version &otherVersion) const {
			if (major < otherVersion.major)
				return false;
			if (minor < otherVersion.minor)
				return false;
			if (revision < otherVersion.revision)
				return false;
			if (build < otherVersion.build)
				return false;
			return false;
		}

		int major, minor, revision, build;
	};
};

