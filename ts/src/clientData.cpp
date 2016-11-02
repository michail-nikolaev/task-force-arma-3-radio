#include "clientData.hpp"
#include <Windows.h>
#include "Logger.hpp"
#include "task_force_radio.hpp"

void clientData::updatePosition(const unitPositionPacket & packet) {
	LockGuard_exclusive<ReadWriteLock> lock(&m_lock);

	clientPosition = packet.position;
	viewDirection = packet.viewDirection;
	canSpeak = packet.canSpeak;
	canUseSWRadio = packet.canUseSWRadio;
	canUseLRRadio = packet.canUseLRRadio;
	canUseDDRadio = packet.canUseDDRadio;
	vehicleId = packet.vehicleID;
	terrainInterception = packet.terrainInterception;
	voiceVolumeMultiplifier = packet.voiceVolume;
	objectInterception = packet.objectInterception;


	lastPositionUpdateTime = GetTickCount();;
	dataFrame = TFAR::getInstance().m_gameData.currentDataFrame;
}
