#include "client_data.hpp"
#include <Windows.h>

std::unordered_map<std::string, std::shared_ptr<CLIENT_DATA>>::iterator STRING_TO_CLIENT_DATA_MAP::end() {
	return data.end();
}


std::unordered_map<std::string, std::shared_ptr<CLIENT_DATA>>::iterator STRING_TO_CLIENT_DATA_MAP::find(const std::string& key) {
	return data.find(key);
}

std::vector<std::shared_ptr<CLIENT_DATA>> STRING_TO_CLIENT_DATA_MAP::getClientDataByClientID(anyID clientID) {
	std::vector<std::shared_ptr<CLIENT_DATA>> output;
	for (auto & it : data) {
		if (it.second->clientId == clientID)
			output.push_back(it.second);
	}
	return output;
}

size_t STRING_TO_CLIENT_DATA_MAP::count(std::string const& key) const {
	return data.count(CLIENT_DATA::convertNickname(key));
}

std::shared_ptr<CLIENT_DATA>& STRING_TO_CLIENT_DATA_MAP::operator[](std::string const& key) {
	const std::string convertedNickname = CLIENT_DATA::convertNickname(key);
	auto found = data.find(convertedNickname);
	//if not exists, insert
	 if (found == data.end()) {
		 found = data.insert(data.end(), { convertedNickname , std::make_shared<CLIENT_DATA>()});
	 }
	return found->second;
}

void STRING_TO_CLIENT_DATA_MAP::removeExpiredPositions(const int &curDataFrame) {
	DWORD time = GetTickCount();
	std::vector<std::string> toRemove;
	for (auto it = data.begin(); it != data.end(); ++it) {
		if (it->second && (time - it->second->positionTime > (MILLIS_TO_EXPIRE * 5) || (abs(curDataFrame - it->second->dataFrame) > 1))) {
			toRemove.push_back(it->first);
		}
	}
	for (const std::string & it : toRemove) {
		log_string(std::string("Expire position of ") + it + " time:" + std::to_string(time - data[it]->positionTime), LogLevel_DEBUG);
		data.erase(it);
	}
}

STRING_TO_CLIENT_DATA_MAP::~STRING_TO_CLIENT_DATA_MAP() {}

std::unordered_map<std::string, std::shared_ptr<CLIENT_DATA>>::iterator STRING_TO_CLIENT_DATA_MAP::begin() {
	return data.begin();
}