#include "client_data.hpp"
#include <Windows.h>

std::map<std::string, CLIENT_DATA*>::iterator STRING_TO_CLIENT_DATA_MAP::end() {
	return data.end();
}

std::vector<CLIENT_DATA*> STRING_TO_CLIENT_DATA_MAP::getClientDataByClientID(anyID clientID) {
	std::vector<CLIENT_DATA*> output;
	for (auto & it : data) {
		if (it.second->clientId == clientID)
			output.push_back(it.second);
	}
	return output;
}

size_t STRING_TO_CLIENT_DATA_MAP::count(std::string const& key) const {
	return data.count(CLIENT_DATA::convertNickname(key));
}

CLIENT_DATA*& STRING_TO_CLIENT_DATA_MAP::operator[](std::string const& key) {
	return data[CLIENT_DATA::convertNickname(key)];
}

void STRING_TO_CLIENT_DATA_MAP::removeExpiredPositions(const int &curDataFrame) {
	DWORD time = GetTickCount();
	std::vector<std::string> toRemove;

	for (auto it = data.begin(); it != data.end(); it++) {
		if (it->second && (time - it->second->positionTime > (MILLIS_TO_EXPIRE * 5) || (abs(curDataFrame - it->second->dataFrame) > 1))) {
			toRemove.push_back(it->first);
		}
	}
	for (auto it = toRemove.begin(); it != toRemove.end(); it++) {
		CLIENT_DATA* client_data = data[*it];
		data.erase(*it);
		log_string(std::string("Expire position of ") + *it + " time:" + std::to_string(time - client_data->positionTime), LogLevel_DEBUG);
		delete client_data;
	}
}

STRING_TO_CLIENT_DATA_MAP::~STRING_TO_CLIENT_DATA_MAP() {
	for (auto & it : data) {
		delete it.second;
	}
	data.clear();
}

std::map<std::string, CLIENT_DATA*>::iterator STRING_TO_CLIENT_DATA_MAP::begin() {
	return data.begin();
}