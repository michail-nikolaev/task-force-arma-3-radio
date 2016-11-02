#pragma once
#include "clientData.hpp"
#include <Windows.h>
#include "Locks.hpp"



class serverData {
	friend class serverDataDirectory;
public:
	


	bool hasClientData(TSClientID clientID);
	std::shared_ptr<clientData> getClientData(const std::string& nickname);
	std::shared_ptr<clientData> getClientData(TSClientID clientID);





	std::shared_ptr<clientData> myClientData;//No lock needed. Its only changed once on serverconnect


	void removeExpiredPositions(const int &curDataFrame);

	serverData()
	{

	}
private:
	void clientJoined(TSClientID clientID, const std::string& clientNickname);
	void clientLeft(TSClientID clientID);
	void clientUpdated(TSClientID clientID, const std::string& clientNickname);

	std::map<TSClientID, std::shared_ptr<clientData>> clientIDToClientData;
	std::unordered_map<std::string, std::shared_ptr<clientData>> nicknameToClientData;
	//STRING_TO_CLIENT_DATA_MAP nicknameToClientData;
	ReadWriteLock m_lock;
};



class serverDataDirectory {
public:
	serverDataDirectory();

	std::shared_ptr<serverData> getClientDataDirectory(TSServerID serverID);
	bool hasDirectory(TSServerID serverConnectionHandlerID);





	//size_t count(const uint64_t &serverConnectionHandlerID) const; use hasDirectory
	//serverData& operator[](const uint64_t &serverConnectionHandlerID);
	//auto erase(const uint64_t &serverConnectionHandlerID) {  //onServerDisconnected
	//	return data.erase(serverConnectionHandlerID);
	//}




	//void setMyNickname(const uint64_t &serverConnectionHandlerID, const std::string& nickname);
	//std::string getMyNickname(const uint64_t &serverConnectionHandlerID);
	////convenience function to keep CriticalSection interaction low
	//void resetAndSetMyNickname(const uint64_t &serverConnectionHandlerID, const std::string& nickname);


	 //#TODO rewrite that func.
	std::vector<std::shared_ptr<clientData>> getClientDataByClientID(const uint64_t &serverConnectionHandlerID, anyID clientID);




	float getWavesLevel(uint64_t const& serverConnectionHandlerID);	//config
	//convenience function for serverIdToData[serverConnectionHandlerID].nicknameToClientData.count(nickname) with LockGuard_exclusive<CRITICAL_SECTION>
	size_t clientDataCount(const uint64_t &serverConnectionHandlerID, const std::string & nickname);
	void setFreqInfos(const uint64_t &serverConnectionHandlerID, const std::vector<std::string> &tokens);
private:

	std::map<TSServerID, std::shared_ptr<serverData>> data;
	ReadWriteLock m_lock;
};












