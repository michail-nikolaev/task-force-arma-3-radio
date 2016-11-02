#pragma once
#include "common.hpp"
#include "datatypes.hpp"
#include <map>
#include "Locks.hpp"
#include <clientlib_publicdefinitions.h>
#include <public_rare_definitions.h>

//All Teamspeak interaction should be in here as static methods.

class TeamspeakServerData {
public:
	TeamspeakServerData();
	~TeamspeakServerData();
	std::vector<dataType::TSClientID> getMutedClients();
	void setClientMuteStatus(dataType::TSClientID, bool muted);
	void clearMutedClients();
	dataType::TSClientID getMyClientID() const { return myClientID; }
	void setMyClientID(dataType::TSClientID val) { myClientID = val; }
	std::string getMyOriginalNickname();
	void setMyOriginalNickname(std::string val);
	dataType::TSChannelID getMyOriginalChannel();
	void setMyOriginalChannel(dataType::TSChannelID val);
	TSChannelID myLastKnownChannel{-1};//#TODO getter/setter
private:
	CriticalSectionLock m_criticalSection;
	std::vector<dataType::TSClientID> mutedClients;
	std::string myOriginalNickname;
	TSClientID myClientID{ -1 };//Too small to need mutex
	TSChannelID myOriginalChannel{ -1 };
};




class Teamspeak {
public:
	Teamspeak();
	~Teamspeak();
	static TSServerID getCurrentServerConnection();
	static void unmuteAll(TSServerID serverConnectionHandlerID = Teamspeak::getCurrentServerConnection());
	static void setClientMute(TSServerID serverConnectionHandlerID, TSClientID clientId, bool mute);
	static void moveToSeriousChannel(TSServerID serverConnectionHandlerID = getCurrentServerConnection());
	static void moveFromSeriousChannel(TSServerID serverConnectionHandlerID = getCurrentServerConnection());
	static void setMyNicknameToGameName(TSServerID serverConnectionHandlerID, const std::string& nickname);
	static void resetMyNickname(TSServerID serverConnectionHandlerID = getCurrentServerConnection());


	static bool isConnected(TSServerID serverConnectionHandlerID = getCurrentServerConnection());
	static TSClientID getMyId(TSServerID serverConnectionHandlerID = getCurrentServerConnection());
	static bool isInChannel(TSServerID serverConnectionHandlerID, TSClientID clientId, const char* channelToCheck);
	static std::string getChannelName(TSServerID serverConnectionHandlerID = getCurrentServerConnection(), TSClientID clientId = getMyId());
	static std::string getServerName(TSServerID serverConnectionHandlerID = getCurrentServerConnection());
	static bool isTalking(TSServerID currentServerConnectionHandlerID, TSClientID clientID);
	static std::vector<TSClientID> getChannelClients(TSServerID serverConnectionHandlerID, TSChannelID channelId);
	static TSChannelID getCurrentChannel(TSServerID serverConnectionHandlerID);
	static std::string getMyNickname(TSServerID serverConnectionHandlerID);
	static bool setMyNickname(TSServerID serverConnectionHandlerID, const std::string& nickname);

	static TSChannelID findChannelByName(TSServerID serverConnectionHandlerID, const std::string& channelName);

	static std::string getMetaData(TSServerID serverConnectionHandlerID, TSClientID clientId);
	static void setMyMetaData(const std::string & metaData);
	static std::string getClientNickname(TSServerID serverConnectionHandlerID, TSClientID clientId);
	static void setMyClient3DPosition(TSServerID serverConnectionHandlerID, Position3D pos);
	static void setClient3DPosition(TSServerID serverConnectionHandlerID, TSClientID clientId, Position3D pos);
	//#TODO onConnected onDisconnected events. Which set my ClientID


	static void sendPluginCommand(TSServerID serverConnectionHandlerID, const std::string& pluginID, const std::string& command, PluginTargetMode targetMode, std::vector<TSClientID> targets = {});
	static void playWavFile(const std::string& filePath);

	static void setVoiceDisabled(TSServerID serverConnectionHandlerID, bool disabled);


	// taken from https://github.com/MadStyleCow/A2TS_Rebuild/blob/master/src/ts3plugin.cpp#L1367
	static bool hlp_checkVad();
	static void hlp_enableVad();
	static void hlp_disableVad();

	 //#TODO hook into TFAR onInit event and check all currently connected servers


	static void log(std::string, DWORD errorCode, LogLevel level = LogLevel_INFO);


	//Internal use
	static void _onConnectStatusChangeEvent(TSServerID serverConnectionHandlerID, ConnectStatus newState);
	static void _onChannelSwitchedEvent(TSServerID serverConnectionHandlerID, TSChannelID newChannel);
	static void _onClientMoved(TSServerID serverConnectionHandlerID, TSClientID clientID, TSChannelID oldChannel, TSChannelID newChannel);
	static void _onClientJoined(TSServerID serverConnectionHandlerID, TSClientID clientID, TSChannelID channel);
	static void _onClientLeft(TSServerID serverConnectionHandlerID, TSClientID clientID);
	static void _onClientUpdated(TSServerID serverConnectionHandlerID, TSClientID clientID);
	static void _onInit();
private:
	static Teamspeak& getInstance();  //Used for accessing stored variables




	std::map<dataType::TSServerID, TeamspeakServerData> serverData;

};

