/*
 * TeamSpeak 3 demo plugin
 *
 * Copyright (c) 2008-2013 TeamSpeak Systems GmbH
 */

#ifdef _WIN32
#pragma warning (disable : 4100)  /* Disable Unreferenced parameter warning */
#include <Windows.h>
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <string>
#include <assert.h>
#include <math.h>
#include <iostream>
#include <sstream>
#include <map>
#include <vector>
#include <algorithm>
#include "public_errors.h"
#include "public_errors_rare.h"
#include "public_rare_definitions.h"
#include "ts3_functions.h"
#include "plugin.h"
#include <DspFilters/Butterworth.h>
#include "sqlite3/sqlite3.h"



#include "RadioEffect.hpp"


#include "clientData.hpp"
#include "serverData.hpp"
#include "task_force_radio.hpp"
#include "common.hpp"
#include "pipe_handler.hpp"
#include "helpers.hpp"
#include "PlaybackHandler.hpp"
#include "Logger.hpp"
#include "SharedMemoryHandler.hpp"
#include "Teamspeak.hpp"
#include <chrono>

#define PATH_BUFSIZE 512

std::thread threadPipeHandle;
std::thread threadService;

volatile bool exitThread = FALSE;
volatile bool pipeConnected = false;

void log_string(std::string message, LogLevel level) {
    Logger::log(LoggerTypes::teamspeakClientlog, message, level);//Default loglevel is Info
}

bool isSeriousModeEnabled(TSServerID serverConnectionHandlerID, TSClientID clientId) {
    std::string	serious_mod_channel_name = TFAR::config.get<std::string>(Setting::serious_channelName);
    return (!serious_mod_channel_name.empty()) && Teamspeak::isInChannel(serverConnectionHandlerID, clientId, serious_mod_channel_name);
}

float effectErrorFromDistance(sendingRadioType radioType, float distance, std::shared_ptr<clientData>& data) {
    float maxD = 1.0f;//We don't want division by 0 do we?
    switch (radioType) {
        case sendingRadioType::LISTEN_TO_SW: maxD = static_cast<float>(data->range); break;
        case sendingRadioType::LISTEN_TO_LR: maxD = static_cast<float>(data->range);
        default: break;
    };
    return distance / maxD;
}

void setGameClientMuteStatus(TSServerID serverConnectionHandlerID, TSClientID clientID, std::pair<bool, bool> isOverRadio = { false,false }) {
    bool mute = false;
    if (isSeriousModeEnabled(serverConnectionHandlerID, clientID)) {

        auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
        std::shared_ptr<clientData> clientData;
        if (clientDataDir)
            clientData = clientDataDir->getClientData(clientID);
        auto myData = clientDataDir->myClientData;

        if (clientData && myData && ((TFAR::getInstance().m_gameData.alive && clientData->isAlive()) || myData->isSpectating)) {
            bool isOnRadio = isOverRadio.first ? isOverRadio.second : !clientData->isOverRadio(myData, false, false, false).empty();

            if (!isOnRadio) {
                bool isTalk = clientData->clientTalkingNow || Teamspeak::isTalking(serverConnectionHandlerID, clientData->clientId);
                auto distance = myData->getClientPosition().distanceTo(clientData->getClientPosition());
                mute = distance > (clientData->voiceVolume+15) || !isTalk;
            } else {
                mute = false;
            }
        } else {
            mute = true;
        }
        if (mute && clientData) clientData->effects.resetVoices();
    }
    Teamspeak::setClientMute(serverConnectionHandlerID, clientID, mute);
}

std::string getConnectionStatusInfo(bool pipeConnected, bool inGame, bool includeVersion) {
    std::ostringstream stringStream;
    stringStream << "Connected to Game: " << (pipeConnected ? "[B]Yes[/B]" : "[B]No[/B]") << std::endl;
    stringStream << "Playing: " << (inGame ? "[B]Yes[/B]" : "[B]No[/B]") << std::endl;
    if (includeVersion) {
        stringStream << "Plugin version: [B]" << PLUGIN_VERSION << "[/B]" << std::endl;
        stringStream << "Addon version: [B]" << TFAR::config.get<std::string>(Setting::addon_version) << "[/B]" << std::endl;
    }
    return stringStream.str();
}

void updateUserStatusInfo(bool pluginEnabled) {
    if (!Teamspeak::isConnected()) return;
    std::string result;
    if (pluginEnabled)
        result = getConnectionStatusInfo(pipeConnected, TFAR::getInstance().getCurrentlyInGame(), true);
    else
        result = "[B]Task Force Radio Plugin Disabled[/B]";
    Teamspeak::setMyMetaData(result);
}

PTTDelayArguments::subtypes PTTDelayArguments::stringToSubtype(const std::string& type) {
    switch (type.length()) {
        case const_strlen("dd"): return subtypes::dd;
        case const_strlen("digital"): return subtypes::digital;
        case const_strlen("airborne"): return subtypes::airborne;
        case const_strlen("digital_lr"): return subtypes::digital_lr;
        case const_strlen("phone"): return subtypes::phone;
        default: return subtypes::invalid;
    }
}

#include "CommandProcessor.hpp"

std::atomic<std::chrono::system_clock::time_point> lastInGame = std::chrono::system_clock::now();
std::atomic<std::chrono::system_clock::time_point> lastCheckForExpire = std::chrono::system_clock::now();
std::atomic<std::chrono::system_clock::time_point> lastInfoUpdate = std::chrono::system_clock::now();

void ServiceThread() {

    while (!exitThread) {
        if (!Teamspeak::isConnected()) {  //If not connected we don't have any clientData anyway
            Sleep(500);
            continue;
        }
        if ((std::chrono::system_clock::now() - lastCheckForExpire.load()) > MILLIS_TO_EXPIRE) {
            //bool isSerious = isSeriousModeEnabled(Teamspeak::getCurrentServerConnection(), Teamspeak::getMyId());

            if (TFAR::getInstance().getCurrentlyInGame())
                Teamspeak::moveToSeriousChannel();
            lastCheckForExpire = std::chrono::system_clock::now();
        }
        if ((std::chrono::system_clock::now() - lastInfoUpdate.load()) > 4000ms) {
            updateUserStatusInfo(true);
            lastInfoUpdate = std::chrono::system_clock::now();
        }
        Sleep(100);
    }
}
#define USE_SHAREDMEM
void PipeThread() {
#ifdef USE_SHAREDMEM
    SharedMemoryHandler pipeHandler;


    pipeHandler.onDisconnected.connect(
        [&]() {
        OutputDebugStringA("disconnected\n");
        pipeConnected = false;
        updateUserStatusInfo(true);
        TFAR::getInstance().onGameDisconnected();

    });

    pipeHandler.onConnected.connect(
        [&]() {
        OutputDebugStringA("connected\n");
        pipeConnected = true;
        TFAR::getInstance().onGameConnected();
    });

#else
    pipe_handler pipeHandler;
#endif


    std::string command;
    while (!exitThread) {
        if (!pipeHandler.isConnected()) { //Need this call! It sets the lastPluginTick variable and causes on(dis)Connected events
            std::this_thread::sleep_for(5ms);
            continue;
        }

#ifdef USE_SHAREDMEM
        pipeHandler.setConfigNeedsRefresh(TFAR::config.needsRefresh());	//#TODO Signal/Slot ?
#endif
        if (!pipeHandler.getData(command, 20ms))//This will still wait. 1ms if SHAMEM error. 20ms if game unconnected
            continue;

        speedTest gameCommandIn("gameCommandInPipe", false);
        bool dataReturned = false;
        if (command.back() == '~') {//a ~ at the end identifies an Async call
            command.pop_back();//removes ~ from end
#ifdef USE_SHAREDMEM
            TFAR::getInstance().getCommandProcessor()->queueCommand(command);
#else
            if (pipeHandler.sendData("OK", 2)) {
                log_string("Info to ARMA send async", LogLevel_DEBUG);
                dataReturned = true;
            } else {
                log_string("Can't send info to ARMA async", LogLevel_ERROR);
            }
#endif	
        } else {
            gameCommandIn.reset();
#ifdef USE_SHAREDMEM
            std::string commandResult = TFAR::getInstance().getCommandProcessor()->processCommand(command);
            pipeHandler.sendData(commandResult);
            if (gameCommandIn.getCurrentElapsedTime().count() >
#ifdef _DEBUG
                400)
#else
                200)
#endif
                log_string("gameinteraction " + std::to_string(gameCommandIn.getCurrentElapsedTime().count()) + command, LogLevel_INFO);   //#Release remove logging and creation variable
#else
            if (gameCommandIn.getCurrentElapsedTime().count() > 200)
                log_string("gameinteraction " + std::to_string(gameCommandIn.getCurrentElapsedTime().count()) + command, LogLevel_INFO);   //#Release remove logging and creation variable

            if (!dataReturned) {
                if (pipeHandler.sendData(commandResult)) {
                    log_string("Info to ARMA send", LogLevel_DEBUG);
                } else {
                    log_string("Can't send info to ARMA", LogLevel_ERROR);
                }
            }
#endif

        }

    }
}

int pttCallback(void *arg, int argc, char **argv, char **azColName) {
    bool pttDelay = false;
    std::chrono::milliseconds pttDelayMs = 0ms;
    if (argc != 1) return 1;
    if (argv[0] != NULL) {
        std::vector<std::string> v = helpers::split(argv[0], '\n');
        for (const std::string i : v) {
            if (i == "delay_ptt=true") {
                pttDelay = true;
            }
            if (i.substr(0, const_strlen("delay_ptt_msecs")) == "delay_ptt_msecs") {
                std::vector<std::string> values = helpers::split(i, '=');
                pttDelayMs = std::chrono::milliseconds(std::stoi(values[1]));
            }
        }
    }
    if (pttDelay)
        TFAR::getInstance().m_gameData.pttDelay = pttDelayMs;
    return 0;
}

/*
 * Custom code called right after loading the plugin. Returns 0 on success, 1 on failure.
 * If the function returns 1 on failure, the plugin will be unloaded again.
 */
extern struct TS3Functions ts3Functions;

/* Plugin API version. Must be the same as the clients API major version, else the plugin fails to load. */

bool pluginInitialized = false;
int ts3plugin_init() {
    pluginInitialized = true;
    char pluginPath[PATH_BUFSIZE];
    if (ts3plugin_apiVersion() <= 20) {
        ts3Functions.getPluginPath(pluginPath, PATH_BUFSIZE);
    } else {	//Compatibility hack for API version > 21
        typedef  void(*getPluginPath_20)(char* path, size_t maxLen, const char* pluginID);
        static_cast<getPluginPath_20>(static_cast<void*>(ts3Functions.getPluginPath))(pluginPath, PATH_BUFSIZE, TFAR::getInstance().getPluginID().c_str()); //This is ugly but keeps compatibility
    }
    TFAR::getInstance().setPluginPath(pluginPath);

#ifdef ENABLE_API_PROFILER
    Logger::registerLogger(LoggerTypes::profiler, std::make_shared<FileLogger>("P:/profiler.log"));
    Logger::registerLogger(LoggerTypes::gameCommands, std::make_shared<FileLogger>("P:/gameCommands.log"));
    Logger::registerLogger(LoggerTypes::pluginCommands, std::make_shared<FileLogger>("P:/pluginCommands.log"));
    Logger::registerLogger(LoggerTypes::teamspeakClientlog, std::make_shared<TeamspeakLogger>(LogLevel::LogLevel_INFO));
#endif

    TFAR::getInstance().setPluginPath(pluginPath);
    TFAR::getServerDataDirectory();//initializes the ServerdataDirectory so it connects its Slots to TFAR's Signals

    Teamspeak::_onInit();


    exitThread = false;
    threadPipeHandle = std::thread(&PipeThread);
    threadService = std::thread(&ServiceThread);
    TFAR::createCheckForUpdateThread();

    TFAR::getInstance().onGameDisconnected.connect([]() {
        TFAR::getInstance().m_gameData.alive = false;
        TFAR::getInstance().m_gameData.currentDataFrame = INVALID_DATA_FRAME;
    });

    char path[MAX_PATH];
    ts3Functions.getConfigPath(path, MAX_PATH);
    strcat_s(path, MAX_PATH, "settings.db");

    sqlite3 *db = 0;
    char *err = 0;
    if (!sqlite3_open(path, &db)) {
        sqlite3_exec(db, "SELECT value FROM Profiles WHERE key='Capture/Default/PreProcessing'", pttCallback, NULL, &err);
        sqlite3_close(db);
    }

    return 0;
}

/* Custom code called right before the plugin is unloaded */
void ts3plugin_shutdown() {
    if (!pluginInitialized) return;	//For some reason shutdown is called before init.
    pluginInitialized = false;
    /* Your plugin cleanup code here */
    Logger::log(LoggerTypes::teamspeakClientlog, "shutdown...", LogLevel_DEVEL);

    exitThread = true;
    threadPipeHandle.join();
    threadService.join();
    TFAR::getInstance().onShutdown();//Call shutdown Signal

    TFAR::getInstance().m_gameData.alive = false;
    pipeConnected = false;
    updateUserStatusInfo(false);
    Teamspeak::unmuteAll();
}

/*
 * Dynamic content shown in the right column in the info frame. Memory for the data string needs to be allocated in this
 * function. The client will call ts3plugin_freeMemory once done with the string to release the allocated memory again.
 * Check the parameter "type" if you want to implement this feature only for specific item types. Set the parameter
 * "data" to NULL to have the client ignore the info data.
 */
void ts3plugin_infoData(uint64 serverConnectionHandlerID, uint64 id, enum PluginItemType type, char** data) {

    if (PLUGIN_CLIENT == type) {
        std::string metaData = Teamspeak::getMetaData(serverConnectionHandlerID, static_cast<anyID>(id));
        *data = static_cast<char*>(malloc(INFODATA_BUFSIZE * sizeof(char)));  /* Must be allocated in the plugin! */
        snprintf(*data, INFODATA_BUFSIZE, "%s", metaData.c_str());  /* bbCode is supported. HTML is not supported */
    } else {
        *data = NULL;
    }
}

/************************** TeamSpeak callbacks ***************************/
/*
 * Following functions are optional, feel free to remove unused callbacks.
 * See the clientlib documentation for details on each function.
 */

 /* Clientlib */


bool isPluginEnabledForUser(TSServerID serverConnectionHandlerID, TSClientID clientID) {
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
    if (!clientDataDir) return false;
    auto clientData = clientDataDir->getClientData(clientID);
    if (!clientData) return false;


    auto currentTime = std::chrono::system_clock::now();
    bool result;

    if (currentTime - clientData->pluginEnabledCheck < 10s) {
        result = clientData->pluginEnabled;
    } else {
        std::string clientInfo = Teamspeak::getMetaData(Teamspeak::getCurrentServerConnection(), clientID);
        if (clientInfo.empty()) return false;
        std::string shouldStartWith = getConnectionStatusInfo(true, true, false);  //slow
        result = clientData->pluginEnabled = helpers::startsWith(shouldStartWith, clientInfo);
    }

    clientData->pluginEnabledCheck = currentTime;

    return result;
}

//packet receive ->	decode -> onEditPlaybackVoiceDataEvent -> 3D positioning -> onEditPostProcessVoiceDataEvent -> mixing -> onEditMixedPlaybackVoiceDataEvent -> speaker output
void ts3plugin_onEditMixedPlaybackVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
    TFAR::getInstance().getPlaybackHandler()->onEditMixedPlaybackVoiceDataEvent(samples, sampleCount, channels, channelSpeakerArray, channelFillMask);
}

void ts3plugin_onEditPostProcessVoiceDataEventStereo(TSServerID serverConnectionHandlerID, TSClientID clientID, short* samples, int sampleCount, int channels) {
    if (!TFAR::getInstance().getCurrentlyInGame())
        return;
    _MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
    _mm_setcsr((_mm_getcsr() & ~0x0040) | (0x0040));//_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
    static std::chrono::system_clock::time_point last_no_info;
    auto myId = Teamspeak::getMyId(serverConnectionHandlerID);
    std::string myNickname = Teamspeak::getMyNickname(serverConnectionHandlerID);

    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
    if (!clientDataDir) return;	//Unknown server
    //Senders Data
    auto clientData = clientDataDir->getClientData(clientID);
    if (!clientData) {
        //Should not happen..
        log_string(std::string("No info about ") + std::to_string(clientID.baseType()) + " " + Teamspeak::getClientNickname(serverConnectionHandlerID, clientID), LogLevel_ERROR);
        return; //Unknown client
    }

    bool alive = TFAR::getInstance().m_gameData.alive && clientDataDir->myClientData;//If i don't know who i am... I am not alive

    bool hasPluginEnabled = isPluginEnabledForUser(serverConnectionHandlerID, clientID);

    if (!clientData || !clientDataDir->myClientData || !hasPluginEnabled) {
        if (clientID == myId) {
            memset(samples, 0, channels * sampleCount * sizeof(short));
            return;
        }


        if (isSeriousModeEnabled(serverConnectionHandlerID, clientID)) {
            if (alive && TFAR::getInstance().getCurrentlyInGame() && hasPluginEnabled)
                helpers::applyGain(samples, sampleCount, channels, 0.0f); // alive player hears only alive players in serious mode
        }
        if (std::chrono::system_clock::now() - last_no_info > MILLIS_TO_EXPIRE) {
            std::string nickname = clientData->getNickname();
            if (!hasPluginEnabled)
                log_string(std::string("No plugin enabled for ") + std::to_string(clientID.baseType()) + " " + nickname, LogLevel_DEBUG);
            last_no_info = std::chrono::system_clock::now();
        }
        return;
    }
    bool canSpeak = clientDataDir->myClientData->canSpeak;
    //If we are dead we can't hear anyone in seriousMode. And if we are alive we can't hear the dead.

    bool isSpectator = clientData->isSpectating;
    //NonPure normalPlayer->Spectator
    bool isNotHearableInNonPureSpectator = clientDataDir->myClientData->isSpectating && (clientData->isEnemyToPlayer && TFAR::config.get<bool>(Setting::spectatorNotHearEnemies)) && TFAR::config.get<bool>(Setting::spectatorCanHearFriendlies);
    //Other player is also a spectator. So we always hear him without 3D positioning
    bool isHearableInPureSpectator = clientDataDir->myClientData->isSpectating && clientData->isSpectating;
    bool isHearableInSpectator = isHearableInPureSpectator || !isNotHearableInNonPureSpectator;

    if (!isHearableInSpectator && isSeriousModeEnabled(serverConnectionHandlerID, clientID) && (!alive || !clientData->isAlive())) {
        helpers::applyGain(samples, sampleCount, channels, 0.0f);
        return;
    }
    auto myData = clientDataDir->myClientData;
    auto myPosition = myData->getClientPosition();
    float globalGain = TFAR::getInstance().m_gameData.globalVolume;
    if (!clientData || !myData) return;
    helpers::applyGain(samples, sampleCount, channels, clientData->voiceVolumeMultiplifier);
    short* original_buffer = helpers::allocatePool(sampleCount, channels, samples);

    bool shouldPlayerHear = (clientData->canSpeak && canSpeak);

    auto myVehicleDesriptor = myData->getVehicleDescriptor();
    auto hisVehicleDesriptor = clientData->getVehicleDescriptor();

    const float vehicleVolumeLoss = std::clamp(myVehicleDesriptor.vehicleIsolation + hisVehicleDesriptor.vehicleIsolation, 0.0f, 0.99f);
    bool isInSameVehicle = (myVehicleDesriptor.vehicleName == hisVehicleDesriptor.vehicleName);
    float distanceFromClient_ = myPosition.distanceTo(clientData->getClientPosition()) + (2 * clientData->objectInterception); //2m more dist for each obstacle



    //#### DIRECT SPEECH
    if (myId != clientID &&
        !isSpectator && !isNotHearableInNonPureSpectator && //We don't hear spectators and enemy units(if enabled in config)....
        distanceFromClient_ <= (clientData->voiceVolume + 15)
        ) {
        //Direct Speech
        //process voice
        auto relativePosition = myPosition.directionTo(clientData->getClientPosition());
        auto myViewDirection = myData->getViewDirection();
        //Time differential based on direction
        clientData->effects.getClunk("voice_clunk")->process(samples, channels, sampleCount, relativePosition, myViewDirection);//interaural time difference
        //Volume differential based on direction
        helpers::applyILD(samples, sampleCount, channels, myPosition, myViewDirection, clientData->getClientPosition(), clientData->getViewDirection());

        //helpers::applyILD(samples, sampleCount, channels, relativePosition, myViewDirection);//interaural level difference


        if (shouldPlayerHear) {
            if (vehicleVolumeLoss < 0.01 || isInSameVehicle) {

                helpers::applyGain(samples, sampleCount, channels, helpers::volumeAttenuation(distanceFromClient_, shouldPlayerHear, clientData->voiceVolume));
                if (!isInSameVehicle && clientData->objectInterception > 0) {
                    helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, 1.0f,
                        clientData->effects.getFilterObjectInterception(clientData->objectInterception)); //getFilterObjectInterception
                }
            } else {
                helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, helpers::volumeAttenuation(distanceFromClient_, shouldPlayerHear, clientData->voiceVolume, 1.0f - vehicleVolumeLoss) * pow(1.0f - vehicleVolumeLoss, 1.2f), clientData->effects.getFilterVehicle("local_vehicle", vehicleVolumeLoss));
            }
        } else {
            helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, helpers::volumeAttenuation(distanceFromClient_, shouldPlayerHear, clientData->voiceVolume) * CANT_SPEAK_GAIN, (clientData->effects.getFilterCantSpeak("local_cantspeak")));
        }

    } else if (!isHearableInPureSpectator) { //.... unless we are both spectating
        memset(samples, 0, channels * sampleCount * sizeof(short));
    }


    //#### RADIOS AND SPEAKERS

    // process radio here
    processCompressor(&clientData->effects.compressor, original_buffer, channels, sampleCount);

    std::vector<LISTED_INFO> listed_info = clientData->isOverRadio(myData, false, false, false);
    float radioDistance = myData->effectiveDistanceTo(clientData);

    for (auto& info : listed_info) {
        short* radio_buffer = helpers::allocatePool(sampleCount, channels, original_buffer);
        float volumeLevel = helpers::volumeMultiplifier(static_cast<float>(info.volume));
        if (info.on < receivingRadioType::LISTED_ON_NONE) {//don't do for onGround or Intercom

            //Volume modifier for lowered headset - Placed here because this part of code only applies to actual non-speaker Radios
            if (TFAR::config.get<bool>(Setting::headsetLowered))
                volumeLevel *= 0.1f;

            switch (PTTDelayArguments::stringToSubtype(clientData->getCurrentTransmittingSubtype())) {
                case PTTDelayArguments::subtypes::digital: {
                    if (info.over == sendingRadioType::LISTEN_TO_SW) {
                        clientData->effects.getSwRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, clientData));
                        processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, clientData->effects.getSwRadioEffect(info.radio_id), info.stereoMode);
                    } else {
                        float underwaterDist = myPosition.distanceUnderwater(clientData->getClientPosition());
                        float normalDist = myPosition.distanceTo(clientData->getClientPosition());
                        clientData->effects.getUnderwaterRadioEffect(info.radio_id)->setErrorLeveL(
                            (underwaterDist * (clientData->range / helpers::distanceForDiverRadio()) + (normalDist - underwaterDist)) / clientData->range
                        );
                        processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, clientData->effects.getUnderwaterRadioEffect(info.radio_id), info.stereoMode);
                    }
                }
                                                           break;
                case PTTDelayArguments::subtypes::airborne:
                    clientData->effects.getAirborneRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, clientData));
                    processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, clientData->effects.getAirborneRadioEffect(info.radio_id), info.stereoMode);
                    break;
                case PTTDelayArguments::subtypes::digital_lr:
                    clientData->effects.getLrRadioEffect(info.radio_id)->setErrorLeveL(effectErrorFromDistance(info.over, radioDistance, clientData));
                    processRadioEffect(radio_buffer, channels, sampleCount, volumeLevel * 0.35f, clientData->effects.getLrRadioEffect(info.radio_id), info.stereoMode);
                    break;
                case  PTTDelayArguments::subtypes::phone:
                    helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, volumeLevel * 10.0f, (clientData->effects.getSpeakerPhone(info.radio_id)));
                    break;
                default:
                    helpers::applyGain(radio_buffer, sampleCount, channels, 0.0f);
                    break;
            }
        }
        if (info.on == receivingRadioType::LISTED_ON_GROUND) {

            float distance_from_radio = myPosition.distanceTo(info.pos);

            const float radioVehicleVolumeLoss = std::clamp(myVehicleDesriptor.vehicleIsolation + info.vehicle.vehicleIsolation, 0.0f, 0.99f);

            helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, SPEAKER_GAIN, (clientData->effects.getSpeakerFilter(info.radio_id)));
            //Special handling for Radios that are louder than normal max. == statically placed radios
            float speakerDistance = (info.volume < 20) ? (info.volume / 10.f) * TFAR::getInstance().m_gameData.speakerDistance : info.volume*1.9f;
            if (radioVehicleVolumeLoss < 0.01f || isInSameVehicle) {
                helpers::applyGain(radio_buffer, sampleCount, channels, helpers::volumeAttenuation(distance_from_radio, shouldPlayerHear, speakerDistance));
            } else {
                helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, helpers::volumeAttenuation(distance_from_radio, shouldPlayerHear, speakerDistance, 1.0f - radioVehicleVolumeLoss) * pow((1.0f - radioVehicleVolumeLoss), 1.2f), (clientData->effects.getFilterVehicle(info.radio_id, radioVehicleVolumeLoss)));
            }
            if (info.waveZ < UNDERWATER_LEVEL) {
                helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(radio_buffer, channels, sampleCount, CANT_SPEAK_GAIN, (clientData->effects.getFilterCantSpeak(info.radio_id)));
            }
            auto relativePosition = myPosition.directionTo(info.pos);
            auto myViewDirection = myData->getViewDirection();

            clientData->effects.getClunk(info.radio_id)->process(radio_buffer, channels, sampleCount, relativePosition, myViewDirection);//interaural time difference
            helpers::applyILD(radio_buffer, sampleCount, channels, relativePosition, myViewDirection);//interaural level difference

        } else if (info.on == receivingRadioType::LISTED_ON_INTERCOM) {
            clientData->effects.getLrRadioEffect("intercom")->setErrorLeveL(0.f);
            processRadioEffect(radio_buffer, channels, sampleCount, TFAR::config.get<float>(Setting::intercomVolume), clientData->effects.getLrRadioEffect("intercom"), stereoMode::stereo);
        }



        helpers::mix(samples, radio_buffer, sampleCount, channels);//Mix current Radio into samples


        delete[] radio_buffer;
    }

    delete[] original_buffer;

    helpers::applyGain(samples, sampleCount, channels, globalGain);


}

//packet receive ->	decode -> onEditPlaybackVoiceDataEvent -> 3D positioning -> onEditPostProcessVoiceDataEvent -> mixing -> onEditMixedPlaybackVoiceDataEvent -> speaker output
//Data from other clients to us. After 3D processing
void ts3plugin_onEditPostProcessVoiceDataEvent(uint64 serverConnectionHandlerID, anyID clientID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask) {
    if (!TFAR::getInstance().getCurrentlyInGame())
        return;

    short* stereo = new short[sampleCount * 2];
    for (int q = 0; q < sampleCount; q++) {
        for (int g = 0; g < 2; g++)
            stereo[q * 2 + g] = samples[q * channels + g];
    }

    ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, clientID, stereo, sampleCount, 2);

    for (int q = 0; q < sampleCount; q++) {
        for (int g = 0; g < 2; g++)
            samples[q * channels + g] = stereo[q * 2 + g];
        for (int g = 2; g < channels; g++)
            samples[q * channels + g] = 0;
    }

    delete[] stereo;
}

//Data from our microphone before its sent
void ts3plugin_onEditCapturedVoiceDataEvent(uint64 serverConnectionHandlerID, short* samples, int sampleCount, int channels, int* edited) {
    if (!TFAR::getInstance().getCurrentlyInGame() || !(*edited & 2))
        return;

    if (!TFAR::getInstance().m_gameData.alive || TFAR::getInstance().m_gameData.speakers.empty()) return;
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
    if (!clientDataDir || !clientDataDir->myClientData) return;

    //ts3plugin_onEditPostProcessVoiceDataEventStereo is always modifying data so we need copy.
    short* voice = new short[sampleCount * 2];
    if (channels == 1) {  //copy to stereo
        for (int q = 0; q < sampleCount; q++) {
            voice[q * 2] = samples[q];
            voice[q * 2 + 1] = samples[q];
        }
    } else if (channels == 2) {
        memcpy(voice, samples, sampleCount * 2 * sizeof(short));
    } else {
        uint32_t posInTarget = 0;
        for (int32_t q = 0; q < sampleCount*channels; q += channels) {
            voice[posInTarget++] = samples[q];//copy left channel
            voice[posInTarget++] = samples[q + 1];//copy right channel
        }
    }


    ts3plugin_onEditPostProcessVoiceDataEventStereo(serverConnectionHandlerID, clientDataDir->myClientData->clientId, voice, sampleCount, 2);

    TFAR::getInstance().getPlaybackHandler()->appendPlayback("my_radio_voice", voice, sampleCount, 2);
    delete[] voice;
}

void ts3plugin_onCustom3dRolloffCalculationClientEvent(uint64 serverConnectionHandlerID, anyID clientID, float distance, float* volume) {
    *volume = 1.0f;	// custom gain applied
}

/* Clientlib rare */
void ts3plugin_onClientSelfVariableUpdateEvent(uint64 serverConnectionHandlerID, int flag, const char* oldValue, const char* newValue) {
    if (flag == CLIENT_FLAG_TALKING && TFAR::getInstance().getCurrentlyInGame()) {
        std::string one = "1";
        bool start = (one == newValue);

        auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
        if (clientDataDir && clientDataDir->myClientData) {
            clientDataDir->myClientData->clientTalkingNow = start;
        }
        TSServerID serverId = Teamspeak::getCurrentServerConnection();
        std::string myNickname = Teamspeak::getMyNickname(serverId);
        std::string command = "VOLUME\t" + myNickname + "\t" + std::to_string(TFAR::getInstance().m_gameData.myVoiceVolume) + "\t" + (start ? "true" : "false");
        Logger::log(LoggerTypes::pluginCommands, "Send " + command);
        Teamspeak::sendPluginCommand(serverId, TFAR::getInstance().getPluginID(), command, PluginCommandTarget_CURRENT_CHANNEL);
    }

    /*
    Don't know what this was supposed to be. So I'll just leave it here - Dedmen
    if (flag == CLIENT_FLAG_TALKING && *newValue == '0' && inGame) {
        uint64 serverId = ts3Functions.getCurrentServerConnectionHandlerID();
        bool set_talk_to_true = false;
        if (TFAR::getInstance().m_gameData.tangentPressed) {
            set_talk_to_true = true;
        }
        if (set_talk_to_true) {
            //TODO:
            /*DWORD error;
            if ((error = ts3Functions.setClientSelfVariableAsInt(ts3Functions.getCurrentServerConnectionHandlerID(), CLIENT_INPUT_DEACTIVATED, INPUT_ACTIVE)) != ERROR_ok) {
                log("Can't active talking by tangent", error);
            }
            error = ts3Functions.flushClientSelfUpdates(ts3Functions.getCurrentServerConnectionHandlerID(), NULL);
            if (error != ERROR_ok && error != ERROR_ok_no_update) {
                log("Can't flush self updates", error);
            };* /
        }
    }
    */
}

void processAllTangentRelease(TSServerID serverId, std::vector<std::string> &tokens) {
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverId);
    if (!clientDataDir) return;
    const std::string nickname = tokens[1];//only copying for readability.. hope compiler optimizes that out
    auto clientData = clientDataDir->getClientData(nickname);
    if (!clientData) return;

    clientData->currentTransmittingTangentOverType = sendingRadioType::LISTEN_TO_NONE;
}

void processTangentPress(TSServerID serverId, std::vector<std::string> &tokens, std::string &command) {
    std::string nickname = tokens.back();
    //Input validation first.
    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverId);
    if (!clientDataDir) return;
    auto senderClientData = clientDataDir->getClientData(nickname);
    if (!senderClientData) {
        log_string(std::string("PLUGIN FROM UNKNOWN NICKNAME ") + nickname);
        return;
    }
    auto myClientData = clientDataDir->myClientData;
    if (!myClientData) //if we don't know who we are we also can't hear anything
        return;



    auto time = std::chrono::system_clock::now();
    bool pressed = (tokens[1] == "PRESSED");
    sendingRadioType sendingRadioType;
    if (tokens[0] == "TANGENT_LR")
        sendingRadioType = sendingRadioType::LISTEN_TO_LR;
    else
        sendingRadioType = sendingRadioType::LISTEN_TO_SW;

    std::string subtype = tokens[4];
    int range = helpers::parseArmaNumberToInt(tokens[3]);

    std::string frequency = tokens[2];
    bool playPressed = false;

    bool alive = TFAR::getInstance().m_gameData.alive;



    senderClientData->pluginEnabled = true;//He just sent us a Plugin command... Either he has Plugin enabled or he is a hacker
    senderClientData->pluginEnabledCheck = time;
    senderClientData->setLastPositionUpdateTime(time);
    senderClientData->setCurrentTransmittingSubtype(subtype);






    //If he could press the tangent.. He is obviously able to use that radio... unless he is using telekinesis...
    if (sendingRadioType == sendingRadioType::LISTEN_TO_LR) senderClientData->canUseLRRadio = true;
    senderClientData->canUseSWRadio = tokens[6] == "1";
    senderClientData->canUseDDRadio = tokens[7] == "1";




    if ((senderClientData->currentTransmittingTangentOverType != sendingRadioType::LISTEN_TO_NONE) != pressed) {
        playPressed = pressed;
    }

    //tell his clientData where he is transmitting from
    if (pressed) {
        senderClientData->currentTransmittingTangentOverType = sendingRadioType;
    } else {
        senderClientData->currentTransmittingTangentOverType = sendingRadioType::LISTEN_TO_NONE;
    }

    senderClientData->setCurrentTransmittingFrequency(frequency);
    senderClientData->range = range;

    auto clientId = senderClientData->clientId;

    //Check where we can Receive him. Radios or Speakers
    std::vector<LISTED_INFO> listedInfos = senderClientData->isOverRadio(myClientData, senderClientData->canUseSWRadio, senderClientData->canUseLRRadio, senderClientData->canUseDDRadio);
    for (LISTED_INFO & listedInfo : listedInfos) {

        if (alive && listedInfo.on != receivingRadioType::LISTED_ON_NONE && listedInfo.on != receivingRadioType::LISTED_ON_INTERCOM) {
            auto vehicleDescriptor = myClientData->getVehicleDescriptor();

            const float vehicleVolumeLoss = std::clamp(vehicleDescriptor.vehicleIsolation + listedInfo.vehicle.vehicleIsolation, 0.0f, 0.99f);
            bool vehicleCheck = (vehicleDescriptor.vehicleName == listedInfo.vehicle.vehicleName);

            float gain = helpers::volumeMultiplifier(static_cast<float>(listedInfo.volume)) * TFAR::getInstance().m_gameData.globalVolume;

            myClientData->receivingTransmission = playPressed; //Set that we are receiving a transmission. For the EventHandler
            switch (PTTDelayArguments::stringToSubtype(subtype)) {
                case PTTDelayArguments::subtypes::digital:
                    TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/sw/remote_start" : "radio-sounds/sw/remote_end", gain, listedInfo.pos, listedInfo.on == receivingRadioType::LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
                    break;
                case PTTDelayArguments::subtypes::digital_lr:
                    TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/lr/remote_start" : "radio-sounds/lr/remote_end", gain, listedInfo.pos, listedInfo.on == receivingRadioType::LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
                    break;
                case PTTDelayArguments::subtypes::airborne:
                    TFAR::getInstance().getPlaybackHandler()->playWavFile(serverId, playPressed ? "radio-sounds/ab/remote_start" : "radio-sounds/ab/remote_end", gain, listedInfo.pos, listedInfo.on == receivingRadioType::LISTED_ON_GROUND, listedInfo.volume, listedInfo.waveZ < UNDERWATER_LEVEL, vehicleVolumeLoss, vehicleCheck, listedInfo.stereoMode);
                    break;
            }
        }
    }
    setGameClientMuteStatus(serverId, clientId, { true,!listedInfos.empty() });
}

void processPluginCommand(std::string command) {
    std::vector<std::string> tokens = helpers::split(command, '\t'); // may not be used in nickname
    TSServerID serverId = Teamspeak::getCurrentServerConnection();

    auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverId);
    if (!clientDataDir) return;


    //PRESSED is 7 tokens with half-duplex	plus 2 tokens for canUseDD and canUseSW
    if ((tokens.size() == 8 || tokens.size() == 9) && (tokens[0] == "TANGENT" || tokens[0] == "TANGENT_LR" || tokens[0] == "TANGENT_DD")) {
        processTangentPress(serverId, tokens, command);
    } else if (tokens.size() == 2 && tokens[0] == "RELEASE_ALL_TANGENTS") {
        processAllTangentRelease(serverId, tokens);
    } else if (tokens.size() == 4 && tokens[0] == "VOLUME") {
        std::string nickname = tokens[1];
        auto clientData = clientDataDir->getClientData(nickname);
        if (!clientData) return; //Don't know who the sender is.. so we don't care

        std::string volume = tokens[2];
        bool start = helpers::isTrue(tokens[3]);
        bool myCommand = clientData == clientDataDir->myClientData;

        clientData->voiceVolume = std::stoi(volume.c_str());
        clientData->pluginEnabled = true;
        clientData->pluginEnabledCheck = std::chrono::system_clock::now();
        clientData->clientTalkingNow = start;
        if (!myCommand) {
            setGameClientMuteStatus(serverId, clientData->clientId);
        }
    } else if (tokens.size() == 2 && tokens[0] == "REQVOL") {//#TODO request volume onGameStart for each client not currently known
        TSClientID clientID = std::stoi(tokens[1]);
        if (!clientDataDir->myClientData)
            return;
        std::string myNickname = clientDataDir->myClientData->getNickname();
        bool curTalking = clientDataDir->myClientData->clientTalkingNow;
        std::string cmd = "VOLUME\t" + myNickname + "\t" + std::to_string(TFAR::getInstance().m_gameData.myVoiceVolume) + "\t" + (curTalking ? "true" : "false");

        Teamspeak::sendPluginCommand(Teamspeak::getCurrentServerConnection(), TFAR::getInstance().getPluginID(), cmd, PluginCommandTarget_CLIENT, { clientID });
    } else {
        log_string(std::string("UNKNOWN PLUGIN COMMAND ") + command);
    }
}

void ts3plugin_onPluginCommandEvent(uint64 serverConnectionHandlerID, const char* pluginName, const char* pluginCommand) {
    Logger::log(LoggerTypes::pluginCommands, std::string(pluginName) + ":" + std::string(pluginCommand));
    log_string(std::string("ON PLUGIN COMMAND ") + pluginName + " " + pluginCommand, LogLevel_DEVEL);
    if (Teamspeak::getCurrentServerConnection() == serverConnectionHandlerID) {
        if (strncmp(pluginName, PLUGIN_NAME, strlen(PLUGIN_NAME)) == 0) {
            processPluginCommand(std::string(pluginCommand));
        } else {
            Logger::log(LoggerTypes::teamspeakClientlog, "Plugin command event failure", LogLevel_ERROR);
        }
    } else {
        Logger::log(LoggerTypes::teamspeakClientlog, "Plugin command unknown ID", LogLevel_ERROR);
    }
}
