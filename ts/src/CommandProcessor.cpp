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
#include "antennaManager.h"
#include "version.h"
#include <iomanip>
#include <filesystem>

volatile bool vadEnabled = false;
volatile bool skipTangentOff = false;
volatile bool waitingForTangentOff = false;
CriticalSectionLock tangentCriticalSection;
extern bool isSeriousModeEnabled(TSServerID serverConnectionHandlerID, TSClientID clientId);
extern void setGameClientMuteStatus(TSServerID serverConnectionHandlerID, TSClientID clientID, std::pair<bool, bool> isOverRadio = { false,false });

CommandProcessor::CommandProcessor() {

    TFAR::getInstance().doDiagReport.connect([this](std::stringstream& diag) {
        diag << "CP:\n";
        diag << TS_INDENT << "shouldRun: " << shouldRun << "\n";
        diag << TS_INDENT << "cmdQueueBacklog: " << commandQueue.size() << "\n";
        diag << TS_INDENT << "thread: " << myThread->get_id() << "\n";
    });


}


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
    std::vector<boost::string_ref> tokens; tokens.reserve(18);
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
            std::string nickname = convertNickname(tokens[1].to_string());
            TSServerID currentServerConnectionHandlerID = Teamspeak::getCurrentServerConnection();
            auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(currentServerConnectionHandlerID);
            if (!clientDataDir) return "00";
            auto clientData = clientDataDir->getClientData(nickname);
            if (!clientData)
                return "00";
            bool receivingTransmission = clientData->receivingTransmission > 0;

            bool clientTalkingOnRadio = clientData->currentTransmittingTangentOverType != sendingRadioType::LISTEN_TO_NONE;
            if (clientData->clientTalkingNow || clientTalkingOnRadio)
                return std::string("1").append(receivingTransmission ? "1" : "0", 1);
            return  std::string("0").append(receivingTransmission ? "1" : "0", 1);
        }
        case gameCommand::RECV_FREQS: {
            TSServerID currentServerConnectionHandlerID = Teamspeak::getCurrentServerConnection();
            auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(currentServerConnectionHandlerID);
            if (!clientDataDir) return "[]";
            auto clientData = clientDataDir->myClientData;
            if (!clientData)
                return "[]";
            std::stringstream str;
            str << "[";
            for (auto& it : clientData->receivingFrequencies) {
                str << '"' << it << "\",";
            }
            str.seekg(-1, str.cur);
            str << "]";
        }
    }

    return "ASYNC COMMAND SENT IN SYNC CONTEXT";
}

const std::string constTangent("TANGENT");
gameCommand CommandProcessor::toGameCommand(const boost::string_ref & textCommand, size_t tokenCount) {
    if (textCommand.length() < 3) return gameCommand::unknown;
    auto hash = const_strhash(textCommand.data(), textCommand.length());
    switch (hash) {
        case FORCE_COMPILETIME(const_strhash("POS")):
            return gameCommand::POS;
        case FORCE_COMPILETIME(const_strhash("IS_SPEAKING")):
            return gameCommand::IS_SPEAKING;
        case FORCE_COMPILETIME(const_strhash("TS_INFO")):
            return gameCommand::TS_INFO;
        case FORCE_COMPILETIME(const_strhash("FREQ")):
            return gameCommand::FREQ;
        case FORCE_COMPILETIME(const_strhash("KILLED")):
            return gameCommand::KILLED;
        case FORCE_COMPILETIME(const_strhash("DFRAME")):
            return gameCommand::DFRAME;
        case FORCE_COMPILETIME(const_strhash("TRACK")):
            return gameCommand::TRACK;
        case FORCE_COMPILETIME(const_strhash("SPEAKERS")):
            return gameCommand::SPEAKERS;
        case FORCE_COMPILETIME(const_strhash("RELEASE_ALL_TANGENTS")):
            return gameCommand::RELEASE_ALL_TANGENTS;
        case FORCE_COMPILETIME(const_strhash("MISSIONEND")):
            return gameCommand::MISSIONEND;
        case FORCE_COMPILETIME(const_strhash("SETCFG")):
            return gameCommand::SETCFG;
        case FORCE_COMPILETIME(const_strhash("TANGENT")):
        case FORCE_COMPILETIME(const_strhash("TANGENT_LR")):
        case FORCE_COMPILETIME(const_strhash("TANGENT_DD")):
            return gameCommand::TANGENT;
        case FORCE_COMPILETIME(const_strhash("RadioTwrAdd")):
            return gameCommand::AddRadioTower;
        case FORCE_COMPILETIME(const_strhash("RadioTwrDel")):
            return gameCommand::DeleteRadioTower;
        case FORCE_COMPILETIME(const_strhash("collectDebugInfo")):
            return gameCommand::collectDebugInfo;
    };
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
    if (command.substr(0,3) != "POS") //else double log as POS is also logged in sync processing
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
                    TFAR::getInstance().onTeamspeakClientUpdated(currentServerConnectionHandlerID, clientDataDir->myClientData->clientId, nickname);
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
                helpers::isTrue(tokens[12]),                //isSpectating
                helpers::isTrue(tokens[13])                 //isEnemyToPlayer
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
            std::string commandToBroadcast = command + "\t" + (myClientData->canUseSWRadio ? "1\t" : "0\t") + (myClientData->canUseDDRadio ? "1\t" : "0\t") + myClientData->getNickname();
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
                args.tangentReleaseDelay = std::chrono::milliseconds(static_cast<int>(TFAR::config.get<float>(Setting::tangentReleaseDelay)));
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
                frequencyLock.unlock(); //setCurTransRadio acquires lock. This can deadlock if we don't unlock here
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
        case gameCommand::AddRadioTower: {
            auto data = helpers::split(tokens[1], 0xA);
            for (auto& element : data) {
                auto antennaData = helpers::split(element, ';');
                TFAR::getAntennaManager()->addAntenna(Antenna(NetID(antennaData[0]), Position3D(antennaData[2]), helpers::parseArmaNumber(antennaData[1])));
            }
            return;

        }

        case gameCommand::DeleteRadioTower: {
            auto data = helpers::split(tokens[1], 0xA);
            for (auto& element : data) {
                TFAR::getAntennaManager()->removeAntenna(element);
            }
            return;

        }
        case gameCommand::collectDebugInfo: {
            std::stringstream date;
            auto now = std::chrono::system_clock::now();
            auto in_time_t = std::chrono::system_clock::to_time_t(now);
            date << std::put_time(std::localtime(&in_time_t), "%d-%m_%H-%M-%S");
            auto dateString = date.str();

            auto basePath = std::string(getenv("appdata")) + "\\TS3Client\\logs\\" + dateString + "\\";
            std::error_code err;

            std::experimental::filesystem::create_directories(basePath,err);

            std::experimental::filesystem::copy(std::string(getenv("appdata")) + "\\TS3Client\\TFAR_pluginCommands.log", basePath + "TFAR_pluginCommands.log",err);
            std::experimental::filesystem::copy(std::string(getenv("appdata")) + "\\TS3Client\\TFAR_gameCommands.log", basePath + "TFAR_gameCommands.log", err);

            clientDataDir->forEachClient([&basePath](const std::shared_ptr<clientData>& cli) {
                auto messages = std::move(cli->messages);
                cli->offset = 0;
                std::string nick = cli->getNickname();
                std::string illegalChars = "\\/:?\"<>|";
                for (auto it = nick.begin(); it < nick.end(); ++it) {
                    bool found = illegalChars.find(*it) != std::string::npos;
                    if (found) {
                        *it = ' ';
                    }
                }

                std::ofstream fs(basePath + "CL_" + nick + ".log");
                for (auto& msg : messages) {
                    fs << msg << '\n';
                }

                std::ofstream vdl(basePath + "VDL_" + nick + ".log");
                cli->verboseDataLog(vdl);
            });


            std::stringstream diag;
            diag << "diag from " << dateString << "\n";
            TFAR::getInstance().doDiagReport(diag);

            std::ofstream fsd(basePath + "diag.log");
            fsd << diag.str();

            std::stringstream pos;
            TFAR::getInstance().doTypeDiagReport("pos", diag);
            std::ofstream fsp(basePath + "pos.log");
            fsp << diag.str();
            Teamspeak::printMessageToCurrentTab((std::string("logged to ") + basePath).c_str());

        }
    }
}

void CommandProcessor::processSpeakers(std::vector<std::string>& tokens) {
    //#TODO we don't really need to send Speakers every time.. Their pos is always static. Either on a person or on ground
    LockGuard_exclusive<ReadWriteLock> lock(&TFAR::getInstance().m_gameData.m_lock);
    TFAR::getInstance().m_gameData.speakers.clear();
    if (tokens.size() != 2)
        return;

    //if you switch TS tab... You don't get speakers bro!
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
            data.waveZ = data.pos.isNull() ? 1 : std::get<2>(data.pos.get());

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

void CommandProcessor::processUnitPosition(TSServerID serverConnection, unitPositionPacket& packet) const {
    API_PROFILER(processUnitPosition);
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnection);
    if (!clientDataDir) return;

    auto clientData = clientDataDir->getClientData(packet.nickname);
    if (!clientData) return;

    packet.myData = clientData == clientDataDir->myClientData;

    clientData->updatePosition(packet);
    //bool clientTalkingOnRadio = (clientData->currentTransmittingTangentOverType != sendingRadioType::LISTEN_TO_NONE) || clientData->clientTalkingNow;

    if (packet.myData) {
        Teamspeak::setMyClient3DPosition(serverConnection, Position3D());
    } else {
        setGameClientMuteStatus(serverConnection, clientData->clientId);
        Teamspeak::setClient3DPosition(serverConnection, clientData->clientId, Position3D());
    }
}

std::string CommandProcessor::ts_info(const boost::string_ref &command) {
    if (command == "SERVER") {
        return Teamspeak::getServerName();
    } else if (command == "CHANNEL") {
        return Teamspeak::getChannelName();
    } else if (command == "PING") {
        return "PONG";
    } else if (command == "VERSION") {
        return PLUGIN_VERSION;
    }
    return "FAIL";
}

void CommandProcessor::process_tangent_off(PTTDelayArguments arguments) {
    waitingForTangentOff = true;
    if (arguments.pttDelay > 0ms)
        std::this_thread::sleep_for(arguments.pttDelay);
    if (arguments.tangentReleaseDelay > 0ms)
        std::this_thread::sleep_for(arguments.tangentReleaseDelay);

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
        return newName;
    }
    return nickname;
}
