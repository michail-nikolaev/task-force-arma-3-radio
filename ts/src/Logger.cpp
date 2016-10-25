#include "Logger.h"
#include "ts3_functions.h"
extern struct TS3Functions ts3Functions;
FileLogger::FileLogger(std::string filePath) : file(filePath) {}

FileLogger::~FileLogger() {}

void FileLogger::log(const std::string& message) {
	 if (file.is_open())	
		file << message;
}

TeamspeakLogger::TeamspeakLogger(enum LogLevel _loglevel) : level(_loglevel) {}

void TeamspeakLogger::log(const std::string& message) {
	ts3Functions.logMessage(message.c_str(), level,"task_force_radio", 141);
}

void Logger::registerLogger(LoggerTypes type, std::shared_ptr<ILogger> logger) {
	getInstance()._registerLogger(type, logger);
}

void Logger::log(LoggerTypes type, const std::string& message) {
	getInstance()._log(type, message);
}

void Logger::_registerLogger(LoggerTypes type, std::shared_ptr<ILogger> logger) {
	registeredLoggers[type].push_back(logger);
}

void Logger::_log(LoggerTypes type, const std::string& message) const {
	auto found = registeredLoggers.find(type);
	if (found != registeredLoggers.end()) {
	   for(const std::shared_ptr<ILogger>& it : registeredLoggers.at(type)) {
		   it->log(message);
	   }
	}
	//If not found exit silently
}

Logger::Logger() {}


Logger::~Logger() {}
