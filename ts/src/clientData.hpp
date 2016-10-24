#pragma once
#include "common.h"
#include <map>
#include <ts3_functions.h>
#include "RadioEffect.h"
#include "Clunk.h"
#include <clunk/wav_file.h>
#include "simpleSource/SimpleComp.h"
#include <memory> //shared_ptr
#include <unordered_map>

enum OVER_RADIO_TYPE {
	LISTEN_TO_SW,
	LISTEN_TO_LR,
	LISTEN_TO_DD, //#diverRadio
	LISTEN_TO_NONE
};

class clientData
{
public:

	static std::string convertNickname(const std::string& nickname) {
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

	bool pluginEnabled;
	uint32_t pluginEnabledCheck;
	anyID clientId;
	OVER_RADIO_TYPE tangentOverType; //Radio type this transmission is comming from
	TS3_VECTOR clientPosition;
	uint64 positionTime;

	std::string frequency;
	int voiceVolume;
	int range;

	bool canSpeak;
	bool clientTalkingNow;
	int dataFrame;

	bool canUseSWRadio;
	bool canUseLRRadio;
	bool canUseDDRadio;

	std::string subtype;
	std::string vehicleId;

	int terrainInterception;
	int objectInterception;
	std::map<std::string, std::unique_ptr<PersonalRadioEffect>> swEffects;
	std::map<std::string, std::unique_ptr<LongRangeRadioffect>> lrEffects;
	std::map<std::string, std::unique_ptr<UnderWaterRadioEffect>> ddEffects;
	std::map<std::string, std::unique_ptr<Clunk>> clunks;

	std::map<std::string, std::unique_ptr<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>> filtersCantSpeak;
	std::map<std::string, std::unique_ptr<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>> filtersVehicle;
	std::map<std::string, std::unique_ptr<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>> filtersSpeakers;
	std::map<std::string, std::unique_ptr<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>> filtersPhone;
	
	float viewAngle;

	float voiceVolumeMultiplifier;

	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>* getSpeakerPhone(std::string key)
	{
		if (!filtersPhone.count(key))
		{
			filtersPhone[key] = std::make_unique<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>>();
			filtersPhone[key]->setup(2, 48000, 1850, 1550);
		}
		return filtersPhone[key].get();
	}

	
	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>* getSpeakerFilter(std::string key)
	{
		if (!filtersSpeakers.count(key))
		{
			filtersSpeakers[key] = std::make_unique<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>();
			filtersSpeakers[key]->setup(1, 48000, 2000, 1000);
		}
		return filtersSpeakers[key].get();
	}

	PersonalRadioEffect* getSwRadioEffect(std::string key)
	{
		if (!swEffects.count(key))
		{
			swEffects[key] = std::make_unique<PersonalRadioEffect>();
		}
		return swEffects[key].get();
	}

	LongRangeRadioffect* getLrRadioEffect(std::string key)
	{
		if (!lrEffects.count(key))
		{
			lrEffects[key] = std::make_unique<LongRangeRadioffect>();
		}
		return lrEffects[key].get();
	}

	UnderWaterRadioEffect* getUnderwaterRadioEffect(std::string key)
	{
		if (!ddEffects.count(key))
		{
			ddEffects[key] = std::make_unique<UnderWaterRadioEffect>();
		}
		return ddEffects[key].get();
	}

	Clunk* getClunk(std::string key) {
		if (!clunks.count(key))
		{
			clunks[key] = std::make_unique<Clunk>();
		}
		return clunks[key].get();
	}

	void removeClunk(std::string key)
	{
		clunks.erase(key);
	}

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>* getFilterCantSpeak(std::string key)
	{
		if (!filtersCantSpeak.count(key)) 
		{
			filtersCantSpeak[key] = std::make_unique<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>();
			filtersCantSpeak[key]->setup(4, 48000, 100);
		}
		return filtersCantSpeak[key].get();
	}

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>* getFilterVehicle(std::string key, float vehicleVolumeLoss)
	{
		std::string byKey = key + std::to_string(vehicleVolumeLoss);
		if (!filtersVehicle.count(byKey))
		{
			filtersVehicle[byKey] = std::make_unique<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>();
			filtersVehicle[byKey]->setup(2, 48000, 20000 * (1.0 - vehicleVolumeLoss) / 4.0);
		}
		return filtersVehicle[byKey].get();
	}

	std::map<uint8_t, std::unique_ptr<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>> filtersObjectInterception;

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>* getFilterObjectInterception(uint8_t objectCount) {
		objectCount = std::min(objectCount, (uint8_t)5);
		if (!filtersObjectInterception.count(objectCount)) {
			filtersObjectInterception[objectCount] = std::make_unique<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>();
			filtersObjectInterception[objectCount]->setup(2, 48000, 1800 - ((objectCount-1) * 400));
		}
		return filtersObjectInterception[objectCount].get();
	}


	chunkware_simple::SimpleComp compressor;
	void resetRadioEffect()
	{	
		swEffects.clear();		
		lrEffects.clear();
		ddEffects.clear();
		filtersSpeakers.clear();
		filtersPhone.clear();		
	}

	void resetVoices() 
	{
		clunks.clear();		
		filtersCantSpeak.clear();
		filtersVehicle.clear();
	}

	clientData()
	{
		positionTime = 0;
		tangentOverType = LISTEN_TO_NONE;
		dataFrame = 0;
		clientPosition.x = clientPosition.y = clientPosition.z = 0;
		clientId = -1;
		voiceVolume = 0;
		canSpeak = true;
		canUseLRRadio = canUseSWRadio = canUseDDRadio = clientTalkingNow = false;
		range = 0;
		terrainInterception = 0;
		voiceVolumeMultiplifier = 1.0f;

		compressor.setSampleRate(48000);
		compressor.setThresh(65);
		compressor.setRelease(300);
		compressor.setAttack(1);
		compressor.setRatio(0.1);
		compressor.initRuntime();

		resetRadioEffect();
	}
};
//typedef std::map<std::string, CLIENT_DATA*> STRING_TO_CLIENT_DATA_MAP;

class STRING_TO_CLIENT_DATA_MAP {
public:
	typedef std::unordered_map<std::string, std::shared_ptr<clientData>>::iterator iterator;
	~STRING_TO_CLIENT_DATA_MAP();
	std::unordered_map<std::string, std::shared_ptr<clientData>>::iterator begin();
	std::unordered_map<std::string, std::shared_ptr<clientData>>::iterator end();
	std::unordered_map<std::string, std::shared_ptr<clientData>>::iterator find(const std::string& key);
	std::vector<std::shared_ptr<clientData>> getClientDataByClientID(anyID clientID);
	size_t count(std::string const& key) const;

	std::shared_ptr<clientData>& operator[](std::string const& key);
	void removeExpiredPositions(const int &curDataFrame);
private:
	//unordered_map is a hashmap, which has faster access times. Which we definitely want for many players
	//The default hash function (std::hash) may produce collisions. use Murmur-hash?
	std::unordered_map<std::string, std::shared_ptr<clientData>> data;
};




