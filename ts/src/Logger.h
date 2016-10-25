#pragma once
#include <string>
#include <fstream>
#include <sstream>
#include <map>
#include <vector>
#include <memory>

class ILogger {
protected:
	~ILogger() {}

public:
	virtual void log(const std::string& message) = 0;
	template<typename T>
	void operator<< (const T& data){
		std::stringstream str;
		str << data;
		log(str.str());
	};
};

class FileLogger : public ILogger {
public:
	explicit FileLogger(std::string filePath);
	virtual ~FileLogger();

	void log(const std::string& message) override;
private:
	std::ofstream file;
};
class TeamspeakLogger: public ILogger {
public:
	explicit TeamspeakLogger(enum LogLevel _loglevel);
	virtual ~TeamspeakLogger() {}

	void log(const std::string& message) override;
private:
	LogLevel level;
};

enum class LoggerTypes {
	profiler,
	gameCommands,
	pluginCommands
};

//this stuff is missing a lot of features.. Especially Loglevels. I just made this for debugging purposes
class Logger {
public:
	static void registerLogger(LoggerTypes type, std::shared_ptr<ILogger> logger);
	static void log(LoggerTypes type, const std::string& message);


private:
	Logger();
	~Logger();
	void _registerLogger(LoggerTypes type, std::shared_ptr<ILogger> logger);
	void _log(LoggerTypes type, const std::string& message) const;
	static Logger& getInstance() { static Logger log; return log; }
	std::map<LoggerTypes, std::vector<std::shared_ptr<ILogger>>> registeredLoggers;
};

