#pragma once
#include <thread>
#include <queue>
#include <mutex>
#include "common.hpp"

class CommandProcessor {
public:
	CommandProcessor();
	~CommandProcessor();
	void stopThread();
	void queueCommand(const std::string& command);
	std::string processCommand(const std::string& command);


private:
	void threadRun();
	void processAsynchronousCommand(const std::string& command);//Called inside thread

	void processSpeakers(std::vector<std::string>& tokens);
	void processUnitKilled(std::string &name, TSServerID serverConnection);
	static std::string ts_info(std::string &command);

	static void process_tangent_off();

	static void disableVoiceAndSendCommand(std::string commandToBroadcast, dataType::TSServerID currentServerConnectionHandlerID, bool pressed);

	static std::string convertNickname(const std::string& nickname);


	std::queue<std::string> commandQueue;
	std::unique_ptr<std::thread> myThread;
	std::condition_variable threadWorkCondition;
	std::mutex theadMutex;
	bool shouldRun = true;//don't need atomic here. believe me.
};

