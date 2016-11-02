#include "CommandProcessor.hpp"
#include "helpers.hpp"
#include "serverData.hpp"
#include "task_force_radio.hpp"
#include <public_errors.h>
#include "Logger.hpp"
#include "PlaybackHandler.hpp"
#include <public_rare_definitions.h>
#include "Locks.hpp"
#include "Teamspeak.hpp"


CommandProcessor::CommandProcessor() {}


CommandProcessor::~CommandProcessor() {
	stopThread();
}

void CommandProcessor::stopThread() {
	if (!myThread)
		return;
	{
		std::lock_guard<std::mutex> lock(theadMutex);
		shouldRun = false;
	}
	threadWorkCondition.notify_one();
	myThread->join();
	myThread = nullptr;
}

void CommandProcessor::queueCommand(const std::string& command) {
	if (!myThread) {
		myThread = std::make_unique<std::thread>(&CommandProcessor::threadRun, this);
	}
	{
		std::lock_guard<std::mutex> lock(theadMutex);
		commandQueue.emplace(command);
	}
	threadWorkCondition.notify_one();
}

extern std::string processUnitPosition(TSServerID serverConnection, const unitPositionPacket & packet);

DEFINE_API_PROFILER(processCommand);
std::string CommandProcessor::processCommand(const std::string& command) {
	Logger::log(LoggerTypes::gameCommands, command);
	API_PROFILER(processCommand);
	std::vector<std::string> tokens; tokens.reserve(18);
	helpers::split(command, '\t', tokens); //may not be used in nickname	

	if (tokens.size() == 2 && tokens[0] == "TS_INFO")
		return ts_info(tokens[1]);
	TSServerID currentServerConnectionHandlerID = Teamspeak::getCurrentServerConnection();

	if (tokens.size() == 12 && tokens[0] == "POS") {
		//POS nickname [x,y,z] [viewdirUnitvector(x,y,z)] canSpeak canUseSWRadio canUseLRRadio canUseDDRadio vehicleID terrainInterception voiceVolume objectInterception

		unitPositionPacket packet{
			convertNickname(tokens[1]),					//nickname
			Position3D(tokens[2]),						//position
			Direction3D(tokens[3]),						//direction
			helpers::isTrue(tokens[4]),					//canSpeak
			helpers::isTrue(tokens[5]),					//canUseSWRadio
			helpers::isTrue(tokens[6]),					//canUseLRRadio
			helpers::isTrue(tokens[7]),					//canUseDDRadio
			tokens[8],									//vehicleID
			helpers::parseArmaNumberToInt(tokens[9]),	//terrainInterception
			helpers::parseArmaNumber(tokens[10]),		//voiceVolume
			helpers::parseArmaNumberToInt(tokens[11])	//objectInterception
		};

		return processUnitPosition(currentServerConnectionHandlerID, packet);
	}
	if (tokens.size() == 2 && tokens[0] == "IS_SPEAKING") {
		std::string nickname = convertNickname(tokens[1]);
		auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(currentServerConnectionHandlerID);

		TSClientID playerId(-1);
		bool clientTalkingOnRadio = false;
		if (clientDataDir) {
			auto clientData = clientDataDir->getClientData(nickname);

			if (clientData) {
				playerId = clientData->clientId;
				clientTalkingOnRadio = (clientData->currentTransmittingTangentOverType != LISTEN_TO_NONE) || clientData->clientTalkingNow;
			}
		}

		if (playerId && (Teamspeak::isTalking(currentServerConnectionHandlerID, playerId) || clientTalkingOnRadio))
			return "SPEAKING";
		return  "NOT_SPEAKING";
	}



	return "FAIL";
}

void CommandProcessor::threadRun() {

	while (shouldRun) {
		std::unique_lock<std::mutex> lock(theadMutex);
		threadWorkCondition.wait(lock, [this] {return !commandQueue.empty() || !shouldRun; });
		if (!shouldRun) return;
		std::string command = commandQueue.front(); commandQueue.pop();
		lock.unlock();
		processAsynchronousCommand(command);




	}
}
#include "ts3_functions.h"
extern CriticalSectionLock tangentCriticalSection;
extern volatile bool vadEnabled;
extern volatile bool skip_tangent_off;
extern volatile bool waiting_tangent_off;
extern volatile DWORD lastInGame;//#TODO rework timeout system
PTTDelayArguments ptt_arguments;
DEFINE_API_PROFILER(processAsynchronousCommand);
void CommandProcessor::processAsynchronousCommand(const std::string& command) {
	Logger::log(LoggerTypes::gameCommands, command);
	API_PROFILER(processAsynchronousCommand);
	std::vector<std::string> tokens; tokens.reserve(18);
	helpers::split(command, '\t', tokens); //may not be used in nickname	
	TSServerID currentServerConnectionHandlerID = Teamspeak::getCurrentServerConnection();
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(currentServerConnectionHandlerID);
	if (!clientDataDir) return;

	if (tokens.size() == 14 && tokens[0] == "FREQ") {//async
		//FREQ, str(_freq), str(_freq_lr), _freq_dd, _alive, speakVolume, TF_dd_volume_level, _nickname, waves, TF_terrain_interception_coefficient, _globalVolume, _voiceVolume, _receivingDistanceMultiplicator, TF_speakerDistance
		API_PROFILER(processFreq);

		TFAR::getInstance().m_gameData.setFreqInfos(tokens);

		if (!clientDataDir->myClientData) return;//shouldn't be possible.. but safety first
		const std::string& nickname = convertNickname(tokens[7]);
		std::string myNickname = Teamspeak::getMyNickname(currentServerConnectionHandlerID);
		if (!myNickname.empty() && myNickname != nickname && (nickname != "Error: No unit" && nickname != "Error: No vehicle" && nickname != "any")) {
			if (Teamspeak::setMyNickname(currentServerConnectionHandlerID, nickname)) {
				clientDataDir->myClientData->setNickname(nickname);
			}
		}
		return;
	}
	if (tokens.size() > 2 && tokens[0] == "KILLED") {//async
		processUnitKilled(convertNickname(tokens[1]), currentServerConnectionHandlerID);
		return;
	}
	if (tokens.size() == 4 && tokens[0] == "TRACK") {//async
		TFAR::trackPiwik(tokens);
		return;
	}
	if (tokens.size() == 1 && tokens[0] == "DFRAME") {//async
		TFAR::getInstance().m_gameData.currentDataFrame++;
		return;
	}
	if (tokens.size() >= 1 && tokens[0] == "SPEAKERS") {//async
		processSpeakers(tokens);
		return;
	}
	if (tokens.size() >= 5 && tokens[0].substr(0, const_strlen("TANGENT")) == "TANGENT") {//async
		//TANGENT, PRESSED/RELEASED, _freq+Radiocode, Range inclusive transmittingdist Multiplicator, Subtype, classname
		bool pressed = (tokens[1] == "PRESSED");
		bool longRange = (tokens[0] == "TANGENT_LR");
		bool diverRadio = (tokens[0] == "TANGENT_DD");
		std::string subtype = tokens[4];

		bool changed = (TFAR::getInstance().m_gameData.tangentPressed != pressed);
		TFAR::getInstance().m_gameData.tangentPressed = pressed;

		auto myClientData = clientDataDir->myClientData;
		if (!myClientData) return; //safety first

		if (longRange) myClientData->canUseLRRadio = true;
		else if (diverRadio) myClientData->canUseDDRadio = true;
		else myClientData->canUseSWRadio = true;
		myClientData->setCurrentTransmittingSubtype(subtype);





		float globalVolume = TFAR::getInstance().m_gameData.globalVolume;//used for playing radio sounds

		if (!changed) //If nothing changed there is nothing to do.
			return;
		std::string commandToBroadcast = command + "\t" + myClientData->getNickname();
		std::string frequency = tokens[2];
		//convenience function to remove duplicate code
		auto playRadioSound = [currentServerConnectionHandlerID, globalVolume, frequency](const char* fileNameWithoutExtension,
			const std::map<std::string, FREQ_SETTINGS>& frequencyMap) {
			auto found = frequencyMap.find(frequency);
			if (found != frequencyMap.end()) {
				const FREQ_SETTINGS& freq = found->second;
				TFAR::getInstance().getPlaybackHandler()->playWavFile(currentServerConnectionHandlerID, fileNameWithoutExtension, helpers::volumeMultiplifier(static_cast<float>(freq.volume)) * globalVolume, freq.stereoMode);
			} else {
				TFAR::getInstance().getPlaybackHandler()->playWavFile(fileNameWithoutExtension);
			}
		};

		if (pressed) {
			switch (PTTDelayArguments::stringToSubtype(subtype)) {
				case PTTDelayArguments::subtypes::digital_lr:
					playRadioSound("radio-sounds/lr/local_start", TFAR::getInstance().m_gameData.myLrFrequencies);
					break;
				case PTTDelayArguments::subtypes::dd:
					TFAR::getInstance().getPlaybackHandler()->playWavFile("radio-sounds/dd/local_start"); break;
				case PTTDelayArguments::subtypes::digital:
					playRadioSound("radio-sounds/sw/local_start", TFAR::getInstance().m_gameData.mySwFrequencies);
					break;
				case PTTDelayArguments::subtypes::airborne:
					playRadioSound("radio-sounds/ab/local_start", TFAR::getInstance().m_gameData.myLrFrequencies);
					break;
				default: break;
			}
			if (!TFAR::config.get<bool>(Setting::full_duplex) && tokens.size() == 6) {
				TFAR::getInstance().m_gameData.currentTransmittingRadio = tokens[5];
			}
			//Force enable PTT
			LockGuard_exclusive<CriticalSectionLock> lock(&tangentCriticalSection);
			if (!waiting_tangent_off) {
				vadEnabled = Teamspeak::hlp_checkVad();
				if (vadEnabled) Teamspeak::hlp_disableVad();
				// broadcast info about tangent pressed over all client										
				disableVoiceAndSendCommand(commandToBroadcast, currentServerConnectionHandlerID, pressed);
			} else skip_tangent_off = true;
		} else {
			PTTDelayArguments args;
			args.commandToBroadcast = commandToBroadcast;
			args.currentServerConnectionHandlerID = currentServerConnectionHandlerID;
			args.subtype = subtype;
			ptt_arguments = args;
			std::thread(&CommandProcessor::process_tangent_off).detach();

			switch (PTTDelayArguments::stringToSubtype(subtype)) {
				case PTTDelayArguments::subtypes::digital_lr:
					playRadioSound("radio-sounds/lr/local_end", TFAR::getInstance().m_gameData.myLrFrequencies);
					break;
				case PTTDelayArguments::subtypes::dd:
					TFAR::getInstance().getPlaybackHandler()->playWavFile("radio-sounds/dd/local_end"); break;
				case PTTDelayArguments::subtypes::digital:
					playRadioSound("radio-sounds/sw/local_end", TFAR::getInstance().m_gameData.mySwFrequencies);
					break;
				case PTTDelayArguments::subtypes::airborne:
					playRadioSound("radio-sounds/ab/local_end", TFAR::getInstance().m_gameData.myLrFrequencies);
					break;
				default: break;
			}
			if (!TFAR::config.get<bool>(Setting::full_duplex)) {
				TFAR::getInstance().m_gameData.currentTransmittingRadio = "";
			}
		}
		return;
	}
	if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS") {//async
		std::string commandToSend = "RELEASE_ALL_TANGENTS\t" + convertNickname(tokens[1]);
		Teamspeak::sendPluginCommand(Teamspeak::getCurrentServerConnection(), TFAR::getInstance().getPluginID(), commandToSend, PluginCommandTarget_CURRENT_CHANNEL);
		return;
	}
	if (tokens.size() >= 3 && tokens[0] == "SETCFG") {//async
		std::string key = tokens[1];
		std::string value = tokens[2];
		if (tokens.size() == 4) {
			std::string type = tokens[3];
			if (type == "BOOL") {
				TFAR::config.set(key, value == "true" || value == "TRUE");
			} else if (type == "SCALAR") {
				TFAR::config.set(key, helpers::parseArmaNumber(value));
			} else {//unsupported type or STRING
				TFAR::config.set(key, value);
			}
		} else {
			TFAR::config.set(key, value);
		}
		return;
	}
	if (tokens.size() == 1 && tokens[0] == "MISSIONEND") {//async
		TFAR::getInstance().onGameEnd();
		return;
	}
}

void CommandProcessor::processSpeakers(std::vector<std::string>& tokens) {
	//#TODO we don't really need to send Speakers every time.. Their pos is always static. Either on a person or on ground
	TFAR::getInstance().m_gameData.speakers.clear();
	if (tokens.size() != 2)
		return;
	std::vector<std::string> speakers = helpers::split(tokens[1], 0xB);
	for (const std::string& speaker : speakers) {
		if (speaker.length() == 0)
			continue;
		SPEAKER_DATA data;
		std::vector<std::string> parts = helpers::split(speaker, 0xA);
		if (parts.size() < 6)
			return;
		data.radio_id = parts[0];
		std::vector<std::string> freqs = helpers::split(parts[1], '|');
		data.nickname = convertNickname(parts[2]);
		data.pos = Position3D(parts[3]);
		data.volume = helpers::parseArmaNumberToInt(parts[4]);
		data.vehicle = helpers::getVehicleDescriptor(parts[5]);
		if (parts.size() > 6)
			data.waveZ = helpers::parseArmaNumber(parts[6]);
		else
			data.waveZ = 1;
		for (const std::string & freq : freqs) {
			TFAR::getInstance().m_gameData.speakers.insert(std::pair<std::string, SPEAKER_DATA>(freq, data));
		}
	}
}
extern void setMuteForDeadPlayers(uint64 serverConnectionHandlerID, bool isSeriousModeEnabled);
extern bool isSeriousModeEnabled(uint64 serverConnectionHandlerID, anyID clientId);
void CommandProcessor::processUnitKilled(std::string &name, TSServerID serverConnection) {
	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnection);
	if (clientDataDir) {
		auto clientData = clientDataDir->getClientData(name);
		if (clientData) {
			clientData->dataFrame = INVALID_DATA_FRAME;
		}
	}
	setMuteForDeadPlayers(serverConnection, isSeriousModeEnabled(serverConnection, Teamspeak::getMyId(serverConnection)));//#TODO teamspeak function. isInSeriousChannel
}

std::string CommandProcessor::ts_info(std::string &command) {
	if (command == "SERVER") {
		return Teamspeak::getServerName();
	} else if (command == "CHANNEL") {
		return Teamspeak::getChannelName();
	} else if (command == "PING") {
		return "PONG";
	}
	return "FAIL";
}
extern volatile bool pttDelay;
extern volatile long pttDelayMs;
volatile bool skip_tangent_off = false;
volatile bool waiting_tangent_off = false;
void CommandProcessor::process_tangent_off() {
	waiting_tangent_off = true;
	if (pttDelay) {
		Sleep(pttDelayMs);
	}
	LockGuard_exclusive<CriticalSectionLock> lock(&tangentCriticalSection);
	if (!skip_tangent_off) {
		if (vadEnabled)	Teamspeak::hlp_enableVad();
		disableVoiceAndSendCommand(ptt_arguments.commandToBroadcast, ptt_arguments.currentServerConnectionHandlerID, false);
		waiting_tangent_off = false;
	} else {
		skip_tangent_off = false;
	}
}

void CommandProcessor::disableVoiceAndSendCommand(std::string commandToBroadcast, TSServerID currentServerConnectionHandlerID, bool pressed) {
	Teamspeak::setVoiceDisabled(currentServerConnectionHandlerID, pressed || vadEnabled ? false : true);
	Teamspeak::sendPluginCommand(Teamspeak::getCurrentServerConnection(), TFAR::getInstance().getPluginID(), commandToBroadcast, PluginCommandTarget_CURRENT_CHANNEL);
}

std::string CommandProcessor::convertNickname(const std::string& nickname) {
	if (!nickname.empty() && (nickname.front() == ' ' || nickname.back() == ' ')) {
		std::string newName(nickname);
		if (nickname.front() == ' ') {
			newName.replace(0, nickname.find_first_not_of(' '), nickname.find_first_not_of(' '), '_');
		}
		if (nickname.back() == ' ') {
			newName.replace(nickname.find_last_not_of(' ') + 1, newName.length() - nickname.find_last_not_of(' ') - 1, newName.length() - nickname.find_last_not_of(' ') - 1, '_');
		}
		return std::move(newName);
	}
	return nickname;
}
