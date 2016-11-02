#include "serverData.hpp"
#include "helpers.hpp"
#include "Locks.hpp"
#include <mutex>
#include "task_force_radio.hpp"
#include "Logger.hpp"
#include "Teamspeak.hpp"


serverDataDirectory::serverDataDirectory() {
	TFAR::getInstance().onTeamspeakClientJoined.connect([this](TSServerID serverID, TSClientID clientID, const std::string& clientNickname) {
		Logger::log(LoggerTypes::pluginCommands, "clientJoined" + std::to_string(clientID) +" "+ clientNickname);
		LockGuard_shared<ReadWriteLock> lock(&m_lock);
		data.at(serverID)->clientJoined(clientID, clientNickname);
	});
	TFAR::getInstance().onTeamspeakClientLeft.connect([this](TSServerID serverID, TSClientID clientID) {
		Logger::log(LoggerTypes::pluginCommands, "clientLeft" + std::to_string(clientID));
		LockGuard_shared<ReadWriteLock> lock(&m_lock);
		data.at(serverID)->clientLeft(clientID);
	});
	TFAR::getInstance().onTeamspeakClientUpdated.connect([this](TSServerID serverID, TSClientID clientID, const std::string& clientNickname) {
		Logger::log(LoggerTypes::pluginCommands, "clientUpdated" + std::to_string(clientID) + " " + clientNickname);
		LockGuard_shared<ReadWriteLock> lock(&m_lock);
		data.at(serverID)->clientUpdated(clientID, clientNickname);
	});
	TFAR::getInstance().onTeamspeakServerConnect.connect([this](TSServerID serverID) {
		Logger::log(LoggerTypes::pluginCommands, "serverConnect" + std::to_string(serverID));
		LockGuard_exclusive<ReadWriteLock> lock(&m_lock);
		data.insert({ serverID,std::make_shared<serverData>() });
	});
	TFAR::getInstance().onTeamspeakServerDisconnect.connect([this](TSServerID serverID) {
		Logger::log(LoggerTypes::pluginCommands, "serverConnect" + std::to_string(serverID));
		LockGuard_exclusive<ReadWriteLock> lock(&m_lock);
		data.erase(serverID);
	});
}

std::shared_ptr<serverData> serverDataDirectory::getClientDataDirectory(TSServerID serverID) {
	LockGuard_shared<ReadWriteLock> lock(&m_lock);
	if (!data.count(serverID)) {
		Logger::log(LoggerTypes::pluginCommands, "invalid getClientDataDirectory" + std::to_string(serverID));
		return std::shared_ptr<serverData>();
	}
	return data.at(serverID);
}

bool serverDataDirectory::hasDirectory(TSServerID serverConnectionHandlerID) {
	LockGuard_shared<ReadWriteLock> lock(&m_lock);
	return data.count(serverConnectionHandlerID) > 0;
}

bool serverData::hasClientData(TSClientID clientID) {
	auto clientData = getClientData(clientID);
	if (!clientData) return false;
	if (abs(TFAR::getInstance().m_gameData.currentDataFrame - clientData->dataFrame) <= 1) {
		return true;
	}
	return false;
}

std::shared_ptr<clientData> serverData::getClientData(TSClientID clientID) {
	LockGuard_shared<ReadWriteLock> lock(&m_lock);
	auto found = clientIDToClientData.find(clientID);
	if (found != clientIDToClientData.end()) return found->second;
	return std::shared_ptr<clientData>();
}

std::shared_ptr<clientData> serverData::getClientData(const std::string& nickname) {
	LockGuard_shared<ReadWriteLock> lock(&m_lock);
	auto found = nicknameToClientData.find(nickname);
	if (found != nicknameToClientData.end()) return found->second;
	return std::shared_ptr<clientData>();
}

void serverData::removeExpiredPositions(const int &curDataFrame) {
	LockGuard_exclusive<ReadWriteLock> lock(&m_lock);
	DWORD time = GetTickCount();
	std::vector<TSClientID> toRemove;
	for (auto it = clientIDToClientData.begin(); it != clientIDToClientData.end(); ++it) {
		if (!it->second || (time - it->second->getLastPositionUpdateTime() > (MILLIS_TO_EXPIRE * 5) || (abs(curDataFrame - it->second->dataFrame) > 1))) {
			toRemove.push_back(it->first);
		}
	}
	lock.unlock();//clientLeft will want to lock it again and RWLock is not recursive
	for (TSClientID it : toRemove) {
		std::string nickname = clientIDToClientData.at(it)->getNickname();
		Logger::log(LoggerTypes::pluginCommands, "expire" + nickname); //#TODO remove on release and swap log_string for Logger call
		log_string(std::string("Expire position of ") + nickname + " time:" + std::to_string(time - clientIDToClientData.at(it)->getLastPositionUpdateTime()), LogLevel_DEBUG);
		clientLeft(it);
	}
}

void serverData::clientJoined(TSClientID clientID, const std::string& clientNickname) {
	LockGuard_exclusive<ReadWriteLock> lock(&m_lock);
	if (clientIDToClientData.count(clientID)) {
		if (!clientIDToClientData.at(clientID)) {
			clientIDToClientData.erase(clientID);
			clientIDToClientData.insert({ clientID,std::make_shared<clientData>(clientID) });
		}
		return; //client already exists and is valid
	}
	auto newClientData = std::make_shared<clientData>(clientID);
	clientIDToClientData.insert({ clientID,newClientData });
	nicknameToClientData.insert({ clientNickname,newClientData });
	newClientData->setNickname(clientNickname);
}

void serverData::clientLeft(TSClientID clientID) {
	LockGuard_exclusive<ReadWriteLock> lock(&m_lock);
	if (clientID == -2) {	 //handle -2 clientID to remove all clients
		nicknameToClientData.clear();
		clientIDToClientData.clear();
		if (myClientData) {
			clientIDToClientData.insert({ myClientData->clientId,myClientData });	//We will always stay on server unless we disconnect
			nicknameToClientData.insert({ myClientData->getNickname(),myClientData });
		}
		return;
	}
	if (!clientIDToClientData.count(clientID))
		return;
	nicknameToClientData.erase(clientIDToClientData.at(clientID)->getNickname());
	clientIDToClientData.erase(clientID);
}

void serverData::clientUpdated(TSClientID clientID, const std::string& clientNickname) {
	LockGuard_shared<ReadWriteLock> lock_shared(&m_lock);
	if (!clientIDToClientData.count(clientID))
		return;
	auto clientData = clientIDToClientData.at(clientID);

	if (clientData->getNickname() == clientNickname)
		return;
	lock_shared.unlock();
	LockGuard_exclusive<ReadWriteLock> lock_exclusive(&m_lock);
	//Don't need to care about duplicate nicknames. Teamspeak takes care of that
	nicknameToClientData.erase(clientData->getNickname());
	nicknameToClientData.insert({ clientNickname,clientData });

	clientData->setNickname(clientNickname);
}
