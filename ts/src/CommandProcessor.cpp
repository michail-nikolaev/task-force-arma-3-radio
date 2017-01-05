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

volatile bool vadEnabled = false;
volatile bool skipTangentOff = false;
volatile bool waitingForTangentOff = false;
CriticalSectionLock tangentCriticalSection;
extern void setMuteForDeadPlayers(TSServerID serverConnectionHandlerID, bool isSeriousModeEnabled);
extern bool isSeriousModeEnabled(TSServerID serverConnectionHandlerID, TSClientID clientId);
extern void setGameClientMuteStatus(TSServerID serverConnectionHandlerID, TSClientID clientID, std::pair<bool, bool> isOverRadio = { false,false });

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
    if (myThread->joinable()) //This happened once.. When something else crashed and dllDetach was called unexpectedly
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



DEFINE_API_PROFILER(processCommand);
std::string CommandProcessor::processCommand(const std::string& command) {
    Logger::log(LoggerTypes::gameCommands, command);
    API_PROFILER(processCommand);
    std::vector<std::string> tokens; tokens.reserve(18);
    helpers::split(command, '\t', tokens); //may not be used in nickname	
    auto gameCommand = toGameCommand(tokens[0], tokens.size());
    if (gameCommand == gameCommand::unknown) return "UNKNOWN COMMAND";


    switch (gameCommand) {
        case gameCommand::TS_INFO: return ts_info(tokens[1]);
        case gameCommand::POS:
            //POS nickname [x,y,z] [viewdirUnitvector(x,y,z)] canSpeak canUseSWRadio canUseLRRadio canUseDDRadio vehicleID terrainInterception voiceVolume objectInterception
            queueCommand(command);//do processing async
            //This will automatically continue to IS_SPEAKING which is what we want
        case gameCommand::IS_SPEAKING: {
            std::string nickname = convertNickname(tokens[1]);
            TSServerID currentServerConnectionHandlerID = Teamspeak::getCurrentServerConnection();
            auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(currentServerConnectionHandlerID);

            if (!clientDataDir) return  "NOT_SPEAKING";
            auto clientData = clientDataDir->getClientData(nickname);

            if (clientData) {
                bool clientTalkingOnRadio = (clientData->currentTransmittingTangentOverType != sendingRadioType::LISTEN_TO_NONE) || clientData->clientTalkingNow;
                if (clientData->clientTalkingNow || clientTalkingOnRadio)
                    return "SPEAKING";
            }

            return  "NOT_SPEAKING";
        }
    }

    return "ASYNC COMMAND SENT IN SYNC CONTEXT";
}

const std::string constTangent("TANGENT");
gameCommand CommandProcessor::toGameCommand(const std::string & textCommand, size_t tokenCount) {
    if (textCommand.length() < 3) return gameCommand::unknown;
#ifdef VS15
    auto hash = const_strhash(textCommand.c_str());
    switch (hash) {
        case FORCE_COMPILETIME(const_strhash("POS")):
            return gameCommand::POS;
            break;
        case FORCE_COMPILETIME(const_strhash("IS_SPEAKING")):
            return gameCommand::IS_SPEAKING;
            break;
        case FORCE_COMPILETIME(const_strhash("TS_INFO")):
            return gameCommand::TS_INFO;
            break;
        case FORCE_COMPILETIME(const_strhash("FREQ")):
            return gameCommand::FREQ;
            break;
        case FORCE_COMPILETIME(const_strhash("KILLED")):
            return gameCommand::KILLED;
            break;
        case FORCE_COMPILETIME(const_strhash("DFRAME")):
            return gameCommand::DFRAME;
            break;
        case FORCE_COMPILETIME(const_strhash("TRACK")):
            return gameCommand::TRACK;
            break;
        case FORCE_COMPILETIME(const_strhash("SPEAKERS")):
            return gameCommand::SPEAKERS;
            break;
        case FORCE_COMPILETIME(const_strhash("RELEASE_ALL_TANGENTS")):
            return gameCommand::RELEASE_ALL_TANGENTS;
            break;
        case FORCE_COMPILETIME(const_strhash("MISSIONEND")):
            return gameCommand::MISSIONEND;
            break;
        case FORCE_COMPILETIME(const_strhash("SETCFG")):
            return gameCommand::SETCFG;
            break;
        case FORCE_COMPILETIME(const_strhash("TANGENT")):
        case FORCE_COMPILETIME(const_strhash("TANGENT_LR")):
        case FORCE_COMPILETIME(const_strhash("TANGENT_DD")):
            return gameCommand::TANGENT;
            break;
    };
#else
    if (tokenCount == 14 && textCommand == "POS")
        return gameCommand::POS;
    if (tokenCount == 2 && textCommand == "IS_SPEAKING")
        return gameCommand::IS_SPEAKING;
    if (tokenCount == 2 && textCommand == "TS_INFO")
        return gameCommand::TS_INFO;
    if (tokenCount == 11 && textCommand == "FREQ")//async
        return gameCommand::FREQ;
    if (tokenCount > 2 && textCommand == "KILLED")//async
        return gameCommand::KILLED;
    if (tokenCount == 4 && textCommand == "TRACK")//async
        return gameCommand::TRACK;
    if (tokenCount == 1 && textCommand == "DFRAME")//async
        return gameCommand::DFRAME;
    if (tokenCount >= 1 && textCommand == "SPEAKERS")//async
        return gameCommand::SPEAKERS;
    if (tokenCount >= 5 && textCommand.substr(0, FORCE_COMPILETIME(const_strlen("TANGENT"))) == constTangent)//async
        return gameCommand::TANGENT;
    if (tokenCount == 2 && textCommand == "RELEASE_ALL_TANGENTS")//async
        return gameCommand::RELEASE_ALL_TANGENTS;
    if (tokenCount >= 3 && textCommand == "SETCFG")//async
        return gameCommand::SETCFG;
    if (tokenCount == 1 && textCommand == "MISSIONEND")//async
        return gameCommand::MISSIONEND;
#endif
    return gameCommand::unknown;
    }

void CommandProcessor::threadRun() {

    while (shouldRun) {
        std::unique_lock<std::mutex> lock(theadMutex);
        threadWorkCondition.wait(lock, [this] {return !commandQueue.empty() || !shouldRun; });
        if (!shouldRun) return;
        std::string command(std::move(commandQueue.front())); commandQueue.pop();
        lock.unlock();
        processAsynchronousCommand(command);

    }
}


DEFINE_API_PROFILER(processAsynchronousCommand);
void CommandProcessor::processAsynchronousCommand(const std::string& command) {
    Logger::log(LoggerTypes::gameCommands, command);
    API_PROFILER(processAsynchronousCommand);
    std::vector<std::string> tokens; tokens.reserve(18);
    helpers::split(command, '\t', tokens); //may not be used in nickname	
    auto gameCommand = toGameCommand(tokens[0], tokens.size());
    if (gameCommand == gameCommand::unknown) return;
    TSServerID currentServerConnectionHandlerID = Teamspeak::getCurrentServerConnection();
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(currentServerConnectionHandlerID);
    if (!clientDataDir) return;


    switch (gameCommand) {

        case gameCommand::FREQ: {//async
                                 //FREQ, str(_freq), str(_freq_lr)
                                //_alive, speakVolume, _nickname, 
                                //waves, TF_terrain_interception_coefficient, _globalVolume,
                                //_receivingDistanceMultiplicator, TF_speakerDistance

            TFAR::getInstance().m_gameData.setFreqInfos(tokens);

            if (!clientDataDir->myClientData) return;//shouldn't be possible.. but safety first

            //Rename to ingame name. This is okey here as long as we always get FREQ commands. Even if now having any Radios
            //Could be replaced by telling everyone in channel our ingame name.. So they can assign it to clientID. If we really want to remove renaming in TS
            const std::string& nickname = convertNickname(tokens[5]);
            std::string myNickname = Teamspeak::getMyNickname(currentServerConnectionHandlerID);
            if (!myNickname.empty() && myNickname != nickname && (nickname != "Error: No unit" && nickname != "Error: No vehicle" && nickname != "any")) {
                if (Teamspeak::setMyNicknameToGameName(currentServerConnectionHandlerID, nickname)) {
                    TFAR::getInstance().onTeamspeakClientLeft(currentServerConnectionHandlerID, clientDataDir->myClientData->clientId);
                    TFAR::getInstance().onTeamspeakClientJoined(currentServerConnectionHandlerID, clientDataDir->myClientData->clientId, nickname);
                }
            }
        }; return;
        case gameCommand::POS: {
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
                helpers::parseArmaNumberToInt(tokens[11]),	//objectInterception
                helpers::isTrue(tokens[12]),
                helpers::isTrue(tokens[13])
            };

            processUnitPosition(currentServerConnectionHandlerID, packet);
        }; return;
        case gameCommand::KILLED:
            processUnitKilled(convertNickname(tokens[1]), currentServerConnectionHandlerID);
            return;
        case gameCommand::TRACK:
            TFAR::trackPiwik(tokens);
            return;
        case gameCommand::DFRAME:
            TFAR::getInstance().m_gameData.currentDataFrame++;
            return;;
        case gameCommand::SPEAKERS:
            processSpeakers(tokens);
            return;
        case gameCommand::TANGENT: {//async
                                    //TANGENT, PRESSED/RELEASED, _freq+Radiocode, Range inclusive transmittingdist Multiplicator, Subtype, classname
            auto myClientData = clientDataDir->myClientData;
            if (!myClientData) return; //safety first

            bool pressed = (tokens[1] == "PRESSED");

            std::string subtype = tokens[4];

            bool changed = (TFAR::getInstance().m_gameData.tangentPressed != pressed);
            TFAR::getInstance().m_gameData.tangentPressed = pressed;

            myClientData->setCurrentTransmittingSubtype(subtype);

            float globalVolume = TFAR::getInstance().m_gameData.globalVolume;//used for playing radio sounds

            if (!changed) //If nothing changed there is nothing to do.
                return;
            std::string commandToBroadcast = command + "\t" + (myClientData->canUseSWRadio ? "1\t":"0\t") + (myClientData->canUseDDRadio ? "1\t" : "0\t") + myClientData->getNickname();
            std::string frequency = tokens[2];
            //convenience function to remove duplicate code
            auto playRadioSound = [currentServerConnectionHandlerID, globalVolume, &frequency](const char* fileNameWithoutExtension,
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
                LockGuard_shared<ReadWriteLock> frequencyLock(&TFAR::getInstance().m_gameData.m_lock);
                switch (PTTDelayArguments::stringToSubtype(subtype)) {
                    case PTTDelayArguments::subtypes::digital_lr:
                        playRadioSound("radio-sounds/lr/local_start", TFAR::getInstance().m_gameData.myLrFrequencies);
                        break;
                    case PTTDelayArguments::subtypes::digital:
                        playRadioSound("radio-sounds/sw/local_start", TFAR::getInstance().m_gameData.mySwFrequencies);
                        break;
                    case PTTDelayArguments::subtypes::airborne:
                        playRadioSound("radio-sounds/ab/local_start", TFAR::getInstance().m_gameData.myLrFrequencies);
                        break;
                    default: break;
                }
                frequencyLock.unlock();
                if (!TFAR::config.get<bool>(Setting::full_duplex) && tokens.size() == 6) {
                    TFAR::getInstance().m_gameData.setCurrentTransmittingRadio(tokens[5]);
                }
                //Force enable PTT
                LockGuard_exclusive<CriticalSectionLock> lock(&tangentCriticalSection);
                if (!waitingForTangentOff) {
                    vadEnabled = Teamspeak::hlp_checkVad();
                    if (vadEnabled) Teamspeak::hlp_disableVad();
                    // broadcast info about tangent pressed over all client										
                    disableVoiceAndSendCommand(commandToBroadcast, currentServerConnectionHandlerID, pressed);
                } else skipTangentOff = true;
            } else {
                PTTDelayArguments args;
                args.commandToBroadcast = commandToBroadcast;
                args.currentServerConnectionHandlerID = currentServerConnectionHandlerID;
                args.subtype = subtype;
                args.pttDelay = TFAR::getInstance().m_gameData.pttDelay;
                std::thread([this, args]() {process_tangent_off(args); }).detach();
                LockGuard_shared<ReadWriteLock> frequencyLock(&TFAR::getInstance().m_gameData.m_lock);
                switch (PTTDelayArguments::stringToSubtype(subtype)) {
                    case PTTDelayArguments::subtypes::digital_lr:
                        playRadioSound("radio-sounds/lr/local_end", TFAR::getInstance().m_gameData.myLrFrequencies);
                        break;
                    case PTTDelayArguments::subtypes::digital:
                        playRadioSound("radio-sounds/sw/local_end", TFAR::getInstance().m_gameData.mySwFrequencies);
                        break;
                    case PTTDelayArguments::subtypes::airborne:
                        playRadioSound("radio-sounds/ab/local_end", TFAR::getInstance().m_gameData.myLrFrequencies);
                        break;
                    default: break;
                }
                frequencyLock.unlock(); //setCurTransRadio aquires lock. This can deadlock if we don't unlock here
                if (!TFAR::config.get<bool>(Setting::full_duplex)) {
                    TFAR::getInstance().m_gameData.setCurrentTransmittingRadio("");
                }
            }
        }; return;
        case gameCommand::RELEASE_ALL_TANGENTS: {
            std::string commandToSend = "RELEASE_ALL_TANGENTS\t" + convertNickname(tokens[1]);
            Teamspeak::sendPluginCommand(Teamspeak::getCurrentServerConnection(), TFAR::getInstance().getPluginID(), commandToSend, PluginCommandTarget_CURRENT_CHANNEL);
        };	return;
        case gameCommand::SETCFG: {//async
            std::string key = tokens[1];
            std::string value = tokens[2];
            Setting keyEnum(key);
            if (!TFAR::config.isValidKey(keyEnum)) {
                MessageBoxA(0, ("Used invalid config key: " + key).c_str(), "Task Force Radio", MB_OK);
                return;
            }
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
                TFAR::config.set(key, std::string(""));
            }
        }; return;
        case gameCommand::MISSIONEND: //Handled by pipe extension. That sets last GameTick to 0 so SharedMemoryHandler::onDisconnected will fire
            //TFAR::getInstance().onGameDisconnected();
            return;
    }
}

void CommandProcessor::processSpeakers(std::vector<std::string>& tokens) {
    //#TODO we don't really need to send Speakers every time.. Their pos is always static. Either on a person or on ground
    LockGuard_exclusive<ReadWriteLock> lock(&TFAR::getInstance().m_gameData.m_lock);
    TFAR::getInstance().m_gameData.speakers.clear();
    if (tokens.size() != 2)
        return;

    //if you switch TS tab... You don't get to get speakers bro!
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(Teamspeak::getCurrentServerConnection());
    if (!clientDataDir) return;

    for (const std::string& speaker : helpers::split(tokens[1], 0xB)) {
        if (speaker.empty()) continue;

        std::vector<std::string> parts; parts.reserve(7);
        helpers::split(speaker, 0xA, parts);
        if (parts.size() < 6) return;
        //parts radio_id,nickname,pos,volume,vehicle,(waveZ)
        auto clientData = clientDataDir->getClientData(convertNickname(parts[2]));

        SPEAKER_DATA data;
        data.radio_id = parts[0];
        data.client = clientData;
        data.pos = Position3D(parts[3]);
        data.volume = helpers::parseArmaNumberToInt(parts[4]);
        data.vehicle = helpers::getVehicleDescriptor(parts[5]);
        if (parts.size() > 6)
            data.waveZ = helpers::parseArmaNumber(parts[6]);
        else
            data.waveZ = 1;

        for (const std::string & freq : helpers::split(parts[1], '|')) {
            TFAR::getInstance().m_gameData.speakers.insert(std::pair<std::string, SPEAKER_DATA>(freq, data));
        }
    }
}

void CommandProcessor::processUnitKilled(std::string &&name, TSServerID serverConnection) {
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnection);
    if (clientDataDir) {
        auto clientData = clientDataDir->getClientData(name);
        if (clientData) {
            clientData->dataFrame = INVALID_DATA_FRAME;
        }
    }

    if (!clientDataDir)
        return;

    bool isSeriousMode = isSeriousModeEnabled(serverConnection, Teamspeak::getMyId(serverConnection));

    if (clientDataDir->myClientData) {
        if (clientDataDir->myClientData->dataFrame == INVALID_DATA_FRAME)
            TFAR::getInstance().m_gameData.alive = false;
    }

    std::vector<TSClientID> clientsIds = Teamspeak::getChannelClients(serverConnection, Teamspeak::getChannelOfClient(serverConnection));

    if (!isSeriousMode && !TFAR::getInstance().m_gameData.alive) {
        //If not seriousMode we can hear everyone when Dead
        Teamspeak::setClientMute(serverConnection, clientsIds, false);
        return;
    }

    auto myId = Teamspeak::getMyId(serverConnection);
    std::vector<TSClientID> aliveClients; aliveClients.reserve(clientsIds.size());
    std::vector<TSClientID> deadClients;  deadClients.reserve(clientsIds.size());
    for (auto & Id : clientsIds) {
        if (Id == myId) continue;
        auto clientData = clientDataDir->getClientData(Id);
        if (clientData && clientData->isAlive()) {
            aliveClients.push_back(Id);
        } else {
            deadClients.push_back(Id);
        }
    }
    /*
    serious mode:
    dead can hear dead.
    alive can hear alive
    alive cant hear dead
    dead cant hear alive

    non-serious mode:
    dead can hear dead.
    alive can hear alive
    alive can hear dead
    dead can hear alive
    */


    Teamspeak::setClientMute(serverConnection, deadClients, TFAR::getInstance().m_gameData.alive && isSeriousMode); //Mute dead people if seriousMode
    Teamspeak::setClientMute(serverConnection, aliveClients, !TFAR::getInstance().m_gameData.alive && isSeriousMode);//Mute alive people if seriousMode

}


DEFINE_API_PROFILER(processUnitPosition);
std::string CommandProcessor::processUnitPosition(TSServerID serverConnection, unitPositionPacket & packet) {
    API_PROFILER(processUnitPosition);
              //#TODO remove all that speaking stuff. Its not handled here anymore
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnection);
    if (!clientDataDir)
        return "NOT_SPEAKING";

    auto clientData = clientDataDir->getClientData(packet.nickname);
    if (!clientData)
        return "NOT_SPEAKING";

    packet.myData = clientData == clientDataDir->myClientData;

    clientData->updatePosition(packet);
    bool clientTalkingOnRadio = (clientData->currentTransmittingTangentOverType != sendingRadioType::LISTEN_TO_NONE) || clientData->clientTalkingNow;

    if (clientData == clientDataDir->myClientData) {
        Teamspeak::setMyClient3DPosition(serverConnection, Position3D());
    } else {
        setGameClientMuteStatus(serverConnection, clientData->clientId);
        Teamspeak::setClient3DPosition(serverConnection, clientData->clientId, Position3D());
    }

    if (clientTalkingOnRadio || clientData->clientTalkingNow) {
        return "SPEAKING";
    }
    return "NOT_SPEAKING";
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

void CommandProcessor::process_tangent_off(PTTDelayArguments arguments) {
    waitingForTangentOff = true;
    if (arguments.pttDelay > 0ms)
        std::this_thread::sleep_for(arguments.pttDelay);

    LockGuard_exclusive<CriticalSectionLock> lock(&tangentCriticalSection);
    if (!skipTangentOff) {
        if (vadEnabled)	Teamspeak::hlp_enableVad();
        disableVoiceAndSendCommand(arguments.commandToBroadcast, arguments.currentServerConnectionHandlerID, false);
        waitingForTangentOff = false;
    } else {
        skipTangentOff = false;
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
