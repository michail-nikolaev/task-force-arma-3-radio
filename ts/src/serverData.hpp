#pragma once
#include "clientData.hpp"
#include <Windows.h>
#include "Locks.hpp"



class serverData {
	friend class serverDataDirectory;
public:
	


	bool hasClientData(TSClientID clientID) const;
	std::shared_ptr<clientData> getClientData(const std::string& nickname) const;
	std::shared_ptr<clientData> getClientData(TSClientID clientID) const;





	std::shared_ptr<clientData> myClientData;//No lock needed. Its only changed once on serverconnect

	serverData()
	{

	}
private:
	using LockGuard_shared = LockGuard_shared<ReadWriteLock>;
	using LockGuard_exclusive = LockGuard_exclusive<ReadWriteLock>;
	mutable ReadWriteLock m_lock;
	void clientJoined(TSClientID clientID, const std::string& clientNickname);
	void clientLeft(TSClientID clientID);
	void clientUpdated(TSClientID clientID, const std::string& clientNickname);

	std::map<TSClientID, std::shared_ptr<clientData>> clientIDToClientData;
	std::unordered_map<std::string, std::shared_ptr<clientData>> nicknameToClientData;
	//STRING_TO_CLIENT_DATA_MAP nicknameToClientData;
};



class serverDataDirectory {
public:
	serverDataDirectory();

	std::shared_ptr<serverData> getClientDataDirectory(TSServerID serverID) const;
	bool hasDirectory(TSServerID serverConnectionHandlerID) const;
private:
	using LockGuard_shared = LockGuard_shared<ReadWriteLock>;
	using LockGuard_exclusive = LockGuard_exclusive<ReadWriteLock>;
	mutable ReadWriteLock m_lock;
	std::map<TSServerID, std::shared_ptr<serverData>> data;
	
};












