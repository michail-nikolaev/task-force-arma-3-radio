#pragma once
#include <thread>
#include <queue>
#include <mutex>
#include "common.hpp"

struct unitPositionPacket;

enum class gameCommand {
    TS_INFO,//Synchronous
    POS,//Synchronous
    IS_SPEAKING,//Synchronous
    FREQ,	 //Async
    KILLED,	 //Async
    TRACK,	 //Async
    DFRAME,	 //Async
    SPEAKERS,//Async
    TANGENT, //Async //TANGENT or TANGENT_LR or TANGENT_DD
    RELEASE_ALL_TANGENTS, //Async
    SETCFG,	//Async
    MISSIONEND,	//Async
	unknown
};

class CommandProcessor {
public:
	CommandProcessor();
	~CommandProcessor();
	void stopThread();
	void queueCommand(const std::string& command);
	std::string processCommand(const std::string& command);

    static gameCommand toGameCommand(const std::string& textCommand,size_t tokenCount);
private:
	void threadRun();
	void processAsynchronousCommand(const std::string& command);//Called inside thread

	void processSpeakers(std::vector<std::string>& tokens);
	void processUnitKilled(std::string &&name, TSServerID serverConnection);

	std::string processUnitPosition(TSServerID serverConnection, unitPositionPacket & packet);
	static std::string ts_info(std::string &command);

	static void process_tangent_off(PTTDelayArguments arguments);

	static void disableVoiceAndSendCommand(std::string commandToBroadcast, dataType::TSServerID currentServerConnectionHandlerID, bool pressed);

	static std::string convertNickname(const std::string& nickname);


	std::queue<std::string> commandQueue;
	std::unique_ptr<std::thread> myThread;
	std::condition_variable threadWorkCondition;
	std::mutex theadMutex;
	bool shouldRun = true;//don't need atomic here. believe me.
};

