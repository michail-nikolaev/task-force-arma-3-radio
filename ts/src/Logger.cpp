#include "Logger.hpp"
#include "ts3_functions.h"
#include <windows.h>
extern struct TS3Functions ts3Functions;
FileLogger::FileLogger(std::string filePath) : file(filePath) {}

FileLogger::~FileLogger() {}

void FileLogger::log(const std::string& message) {
    if (file.is_open()) {
        file << message;
        file.flush();
    }

}

void FileLogger::log(const std::string& message, LogLevel _loglevel) {
    log(message); //#TODO add prefix according to loglevel
}

TeamspeakLogger::TeamspeakLogger(enum LogLevel _loglevel) : level(_loglevel) {}

void TeamspeakLogger::log(const std::string& message) {
    ts3Functions.logMessage(message.c_str(), level, "task_force_radio", 141);
}

void TeamspeakLogger::log(const std::string& message, LogLevel _loglevel) {
    ts3Functions.logMessage(message.c_str(), _loglevel, "task_force_radio", 141);
}

void Logger::registerLogger(LoggerTypes type, std::shared_ptr<ILogger> logger) {
    getInstance()._registerLogger(type, logger);
}

void Logger::log(LoggerTypes type, const std::string& message) {
    getInstance()._log(type, message);
}

void Logger::log(LoggerTypes type, const std::string & message, LogLevel _loglevel) {
#if DEBUG_MOD_ENABLED || !isCI
    if (_loglevel != LogLevel_DEVEL && _loglevel != LogLevel_DEBUG)
#endif
        getInstance()._log(type, message, _loglevel);
}

void Logger::_registerLogger(LoggerTypes type, std::shared_ptr<ILogger> logger) {
    registeredLoggers[type].push_back(logger);
}

void Logger::_log(LoggerTypes type, const std::string& message) const {
    auto found = registeredLoggers.find(type);
    if (found != registeredLoggers.end()) {
        for (const std::shared_ptr<ILogger>& it : registeredLoggers.at(type)) {
            it->log(message.back() == '\n' ? message : message + '\n');
        }
    }
    //If not found exit silently
}

void Logger::_log(LoggerTypes type, const std::string& message, LogLevel _loglevel) const {
    auto found = registeredLoggers.find(type);
    if (found != registeredLoggers.end()) {
        for (const std::shared_ptr<ILogger>& it : registeredLoggers.at(type)) {
            it->log(message.back() == '\n' ? message : message + '\n', _loglevel);
        }
    }
    //If not found exit silently
}

Logger::Logger() {}


Logger::~Logger() {}

void DebugStringLogger::log(const std::string & message) { OutputDebugStringA(message.c_str()); printf("%s", message.c_str()); }

void DebugStringLogger::log(const std::string & message, LogLevel _loglevel) { OutputDebugStringA(message.c_str()); printf("%s", message.c_str()); }
