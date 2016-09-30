#pragma once
#include <string>
#include <map>
#include <ts3_functions.h>
#include "common.h"
#include "RadioEffect.h"
#include "Clunk.h"
#include <clunk/wav_file.h>
#include "simpleSource\SimpleComp.h"

enum OVER_RADIO_TYPE {
	LISTEN_TO_SW,
	LISTEN_TO_LR,
	LISTEN_TO_DD, //#diverRadio
	LISTEN_TO_NONE
};

class CLIENT_DATA
{
public:

	static std::string convertNickname(const std::string& nickname) {
		if (nickname.front() == ' ' || nickname.back() == ' ') {
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

	std::map<std::string, PersonalRadioEffect*> swEffects;
	std::map<std::string, LongRangeRadioffect*> lrEffects;
	std::map<std::string, UnderWaterRadioEffect*> ddEffects;
	std::map<std::string, Clunk*> clunks;

	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>*> filtersCantSpeak;
	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>*> filtersVehicle;
	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>*> filtersSpeakers;
	std::map<std::string, Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>*> filtersPhone;
	
	float viewAngle;

	float voiceVolumeMultiplifier;

	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>* getSpeakerPhone(std::string key)
	{
		if (!filtersPhone.count(key))
		{
			filtersPhone[key] = new Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, MAX_CHANNELS>();
			filtersPhone[key]->setup(2, 48000, 1850, 1550);
		}
		return filtersPhone[key];
	}

	
	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>* getSpeakerFilter(std::string key)
	{
		if (!filtersSpeakers.count(key))
		{
			filtersSpeakers[key] = new Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>();
			filtersSpeakers[key]->setup(1, 48000, 2000, 1000);
		}
		return filtersSpeakers[key];
	}

	PersonalRadioEffect* getSwRadioEffect(std::string key)
	{
		if (!swEffects.count(key))
		{
			swEffects[key] = new PersonalRadioEffect();
		}
		return swEffects[key];
	}

	LongRangeRadioffect* getLrRadioEffect(std::string key)
	{
		if (!lrEffects.count(key))
		{
			lrEffects[key] = new LongRangeRadioffect();
		}
		return lrEffects[key];
	}

	UnderWaterRadioEffect* getUnderwaterRadioEffect(std::string key)
	{
		if (!ddEffects.count(key))
		{
			ddEffects[key] = new UnderWaterRadioEffect();
		}
		return ddEffects[key];
	}

	Clunk* getClunk(std::string key) {
		if (!clunks.count(key))
		{
			clunks[key] = new Clunk();
		}
		return clunks[key];
	}

	void removeClunk(std::string key)
	{
		if (clunks.count(key))
		{
			delete clunks[key];
		}
		clunks.erase(key);
	}

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>* getFilterCantSpeak(std::string key)
	{
		if (!filtersCantSpeak.count(key)) 
		{
			filtersCantSpeak[key] = new Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>();
			filtersCantSpeak[key]->setup(4, 48000, 100);
		}
		return filtersCantSpeak[key];
	}

	Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>* getFilterVehicle(std::string key, float vehicleVolumeLoss)
	{
		std::string byKey = key + std::to_string(vehicleVolumeLoss);
		if (!filtersVehicle.count(byKey))
		{
			filtersVehicle[byKey] = new Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>();
			filtersVehicle[byKey]->setup(2, 48000, 20000 * (1.0 - vehicleVolumeLoss) / 4.0);
		}
		return filtersVehicle[byKey];
	}

	chunkware_simple::SimpleComp compressor;
	void resetRadioEffect()
	{
		for (auto it = swEffects.begin(); it != swEffects.end(); ++it) delete it->second;		
		swEffects.clear();
		for (auto it = lrEffects.begin(); it != lrEffects.end(); ++it) delete it->second;		
		lrEffects.clear();
		for (auto it = ddEffects.begin(); it != ddEffects.end(); ++it) delete it->second;
		ddEffects.clear();
		for (auto it = filtersSpeakers.begin(); it != filtersSpeakers.end(); ++it) delete it->second;
		filtersSpeakers.clear();
		for (auto it = filtersPhone.begin(); it != filtersPhone.end(); ++it) delete it->second;
		filtersPhone.clear();		
	}

	void resetVoices() 
	{
		for (auto it = clunks.begin(); it != clunks.end(); ++it) delete it->second;
		clunks.clear();		
		for (auto it = filtersCantSpeak.begin(); it != filtersCantSpeak.end(); ++it) delete it->second;
		filtersCantSpeak.clear();
		for (auto it = filtersVehicle.begin(); it != filtersVehicle.end(); ++it) delete it->second;
		filtersVehicle.clear();
	}

	CLIENT_DATA()
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
	typedef std::map<std::string, CLIENT_DATA*>::iterator iterator;
	~STRING_TO_CLIENT_DATA_MAP();
	std::map<std::string, CLIENT_DATA*>::iterator begin();
	std::map<std::string, CLIENT_DATA*>::iterator end();
	std::vector<CLIENT_DATA*> getClientDataByClientID(anyID clientID);
	size_t count(std::string const& key) const;
	CLIENT_DATA*& operator[](std::string const& key);
	void removeExpiredPositions(const int &curDataFrame);
private:
	std::map<std::string, CLIENT_DATA*> data;
};




