#include "clientData.hpp"
#include <Windows.h>
#include "Logger.hpp"
#include "task_force_radio.hpp"

void clientData::updatePosition(const unitPositionPacket & packet) {
    LockGuard_exclusive lock(&m_lock);

    clientPosition = packet.position;//Could move assign if more performance is needed
    viewDirection = packet.viewDirection;
    canSpeak = packet.canSpeak;
    if (packet.myData) {
		//Ugly hack because the canUsees of other people don't respect if they even have that radio type
        canUseSWRadio = packet.canUseSWRadio;
        canUseLRRadio = packet.canUseLRRadio;
        canUseDDRadio = packet.canUseDDRadio;
    }
    setVehicleId(packet.vehicleID);
    terrainInterception = packet.terrainInterception;
    voiceVolumeMultiplifier = packet.voiceVolume;
    objectInterception = packet.objectInterception;
    isSpectating = packet.isSpectating;
    isEnemyToPlayer = packet.isEnemyToPlayer;

    lastPositionUpdateTime = std::chrono::system_clock::now();
    dataFrame = TFAR::getInstance().m_gameData.currentDataFrame;
}

float clientData::effectiveDistanceTo(std::shared_ptr<clientData>& other) const {
    float d = getClientPosition().distanceTo(other->getClientPosition());
    // (bob distance player) + (bob call TFAR_fnc_calcTerrainInterception) * 7 + (bob call TFAR_fnc_calcTerrainInterception) * 7 * ((bob distance player) / 2000.0)
    float result = d +
        +(other->terrainInterception * TFAR::getInstance().m_gameData.terrainIntersectionCoefficient)
        + (other->terrainInterception * TFAR::getInstance().m_gameData.terrainIntersectionCoefficient * d / 2000.0f);
    result *= TFAR::getInstance().m_gameData.receivingDistanceMultiplicator;
    return result;
}

float clientData::effectiveDistanceTo(clientData* other) const {
    float d = getClientPosition().distanceTo(other->getClientPosition());
    // (bob distance player) + (bob call TFAR_fnc_calcTerrainInterception) * 7 + (bob call TFAR_fnc_calcTerrainInterception) * 7 * ((bob distance player) / 2000.0)
    float result = d +
        +(other->terrainInterception * TFAR::getInstance().m_gameData.terrainIntersectionCoefficient)
        + (other->terrainInterception * TFAR::getInstance().m_gameData.terrainIntersectionCoefficient * d / 2000.0f);
    result *= TFAR::getInstance().m_gameData.receivingDistanceMultiplicator;
    return result;
}

bool clientData::isAlive() {
    if (dataFrame == INVALID_DATA_FRAME) return false;
    bool timeout = (std::chrono::system_clock::now() - getLastPositionUpdateTime() > (MILLIS_TO_EXPIRE * 5)) || (abs(TFAR::getInstance().m_gameData.currentDataFrame - dataFrame) > 1);
    if (timeout)
        dataFrame = INVALID_DATA_FRAME;
    return !timeout;
}

LISTED_INFO clientData::isOverLocalRadio(std::shared_ptr<clientData>& myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent) {
    //Sender is this
    LISTED_INFO result;
    result.over = sendingRadioType::LISTEN_TO_NONE;
    result.volume = 0;
    result.on = receivingRadioType::LISTED_ON_NONE;
    result.waveZ = 1.0f;
    if (!myData) return result;

    Position3D myPosition = myData->getClientPosition();
    Position3D clientPosition = getClientPosition();


    //If we are underwater and can still use SWRadio then we are in a vehicle
    bool receiverUnderwater = myPosition.getHeight() < 0 && !myData->canUseSWRadio;
    bool senderUnderwater = clientPosition.getHeight() < 0 && !canUseSWRadio;

    //If we didn't find anything result.on has to be LISTED_ON_NONE so we can set result.over
    //even if we won't find a valid path on the receiver side

    if ((currentTransmittingTangentOverType == sendingRadioType::LISTEN_TO_SW || ignoreSwTangent) && (canUseSWRadio || canUseDDRadio)) {//Sending from SW
        result.over = senderUnderwater ? sendingRadioType::LISTEN_TO_DD : sendingRadioType::LISTEN_TO_SW;
    } else if ((currentTransmittingTangentOverType == sendingRadioType::LISTEN_TO_LR || ignoreLrTangent) && canUseLRRadio) {//Sending from LR
        result.over = sendingRadioType::LISTEN_TO_LR;
    } else {
        //He isn't actually sending on anything... 
        return result;
    }

    result.radio_id = "local_radio";
    result.vehicle = myData->getVehicleDescriptor();
    std::string senderFrequency = getCurrentTransmittingFrequency();
    bool isUnderwater = receiverUnderwater || senderUnderwater;

    LockGuard_shared countLock(&TFAR::getInstance().m_gameData.m_lock);
    //Sender is sending on a Frequency we are listening to on our LR Radio
    bool senderOnLRFrequency = TFAR::getInstance().m_gameData.myLrFrequencies.count(senderFrequency) != 0;
    //Sender is sending on a Frequency we are listening to on our SW Radio
    bool senderOnSWFrequency = TFAR::getInstance().m_gameData.mySwFrequencies.count(senderFrequency) != 0;
    countLock.unlock();

    float effectiveDist = myData->effectiveDistanceTo(this);
    
    if (isUnderwater) {
        float underwaterDist = myPosition.distanceUnderwater(clientPosition);
		//Seperate distance underwater and distance overwater.
        effectiveDist = underwaterDist * (range / helpers::distanceForDiverRadio()) + (effectiveDist - underwaterDist);
     }

    if (effectiveDist > range)
        return result;






    std::string currentTransmittingRadio;
    if (!TFAR::config.get<bool>(Setting::full_duplex)) {
        //We have to get it here because we can't while m_gameData is Locked
        currentTransmittingRadio = TFAR::getInstance().m_gameData.getCurrentTransmittingRadio();
    }

    if (senderOnLRFrequency && myData->canUseLRRadio) {//to our LR
        LockGuard_shared lock(&TFAR::getInstance().m_gameData.m_lock);
        auto &frequencyInfo = TFAR::getInstance().m_gameData.myLrFrequencies[senderFrequency];
        if (!TFAR::config.get<bool>(Setting::full_duplex) && //If we are currently transmitting on that Radio we can't hear so we return before result gets valid
            frequencyInfo.radioClassname.compare(currentTransmittingRadio) == 0) {
            return result;
        }
        result.on = receivingRadioType::LISTED_ON_LR;
        result.volume = frequencyInfo.volume;
        result.stereoMode = frequencyInfo.stereoMode;
    } else if (senderOnSWFrequency && myData->canUseSWRadio) {//to our SW
        LockGuard_shared lock(&TFAR::getInstance().m_gameData.m_lock);
        auto &frequencyInfo = TFAR::getInstance().m_gameData.mySwFrequencies[senderFrequency];
        if (!TFAR::config.get<bool>(Setting::full_duplex) && //If we are currently transmitting on that Radio we can't hear so we return before result gets valid
            frequencyInfo.radioClassname.compare(currentTransmittingRadio) == 0) {
            return result;
        }
        result.on = receivingRadioType::LISTED_ON_SW;
        result.volume = frequencyInfo.volume;
        result.stereoMode = frequencyInfo.stereoMode;
    }
    return result;
}

std::vector<LISTED_INFO> clientData::isOverRadio(std::shared_ptr<clientData>& myData, bool ignoreSwTangent, bool ignoreLrTangent, bool ignoreDdTangent) {
    std::vector<LISTED_INFO> result;
    if (!myData) return result;
    //check if we receive him over a radio we have on us
    if (clientId != myData->clientId) {//We don't hear ourselves over our Radio ^^
        LISTED_INFO local = isOverLocalRadio(myData, ignoreSwTangent, ignoreLrTangent, ignoreDdTangent);
        if (local.on != receivingRadioType::LISTED_ON_NONE && local.over != sendingRadioType::LISTEN_TO_NONE) {
            result.push_back(local);
        }
    }

    //vehicle intercom
    auto vecDescriptor = getVehicleDescriptor();
    auto myVecDescriptor = myData->getVehicleDescriptor();
    if (TFAR::config.get<bool>(Setting::intercomEnabled) &&
        currentTransmittingTangentOverType == sendingRadioType::LISTEN_TO_NONE && //Not currently transmitting on a Radio. If transmitting only direct speech.
        vecDescriptor.vehicleName != "no" && vecDescriptor.vehicleName == myVecDescriptor.vehicleName //In same vehicle 
        && vecDescriptor.intercomSlot != -1 && vecDescriptor.intercomSlot == myVecDescriptor.intercomSlot) { //On same Intercom Channel
        result.emplace_back(
            sendingRadioType::LISTEN_TO_SW,	//unused
            receivingRadioType::LISTED_ON_INTERCOM,
            7,	//unused
            stereoMode::stereo,	 //unused
            "intercom",	  //unused
            Position3D(0, 0, 0), //unused
            0.f,		 //unused
            getVehicleDescriptor());  //unused
    }


    float effectiveDistance_ = myData->effectiveDistanceTo(this);//#TODO is this broken? seems to always return 0
    //check if we receive him over a radio laying on ground
    if (effectiveDistance_ > range)//does senders range reach to us?
        return result;	 //His distance > range

    if (
        (canUseSWRadio && (currentTransmittingTangentOverType == sendingRadioType::LISTEN_TO_SW || ignoreSwTangent)) || //Sending over SW
        (canUseLRRadio && (currentTransmittingTangentOverType == sendingRadioType::LISTEN_TO_LR || ignoreLrTangent))) { //Sending over LR
        auto currentFrequency = getCurrentTransmittingFrequency();
        ::LockGuard_shared<ReadWriteLock> lock(&TFAR::getInstance().m_gameData.m_lock);
        std::for_each(TFAR::getInstance().m_gameData.speakers.begin(), TFAR::getInstance().m_gameData.speakers.end(), [&](auto &it) {
            if (it.first != currentFrequency) return;
            SPEAKER_DATA& speaker = it.second;
            auto speakerOwner = speaker.client.lock();
            //If the speaker is Senders backpack we don't hear it.. Because he is sending with his Backpack so it can't receive
            //Also because we would normally hear him twice
            if (speakerOwner && speakerOwner->clientId == clientId) return;
            auto speakerPosition = speaker.getPos(speakerOwner);
            if (speakerPosition.isNull()) return;//Don't know its position
            if (speakerPosition.getHeight() < 0) return;//Speakers don't work underwater.. duh
            result.emplace_back(
                (currentTransmittingTangentOverType == sendingRadioType::LISTEN_TO_SW || ignoreSwTangent) ? sendingRadioType::LISTEN_TO_SW : sendingRadioType::LISTEN_TO_LR,
                receivingRadioType::LISTED_ON_GROUND,
                speaker.volume,
                stereoMode::stereo,
                speaker.radio_id,
                speakerPosition,
                speaker.waveZ,
                speaker.vehicle);

        });

    }
    return result;



}
