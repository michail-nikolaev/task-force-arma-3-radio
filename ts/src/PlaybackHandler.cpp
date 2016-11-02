#include "PlaybackHandler.hpp"
#include <vector>

#include "helpers.hpp"
#include <DspFilters/Filter.h>
#include <DspFilters/Butterworth.h>
#include "clientData.hpp"
#include <public_errors.h>
#include "serverData.hpp"
#include "task_force_radio.hpp"
#include "Teamspeak.hpp"

PlaybackHandler::PlaybackHandler() {}


PlaybackHandler::~PlaybackHandler() {}

void PlaybackHandler::onEditMixedPlaybackVoiceDataEvent(short * samples, int sampleCount, int channels, const unsigned int * channelSpeakerArray, unsigned int * channelFillMask) {
	LockGuard_exclusive<CriticalSectionLock> lock(&playbackCriticalSection);
	bool fill = false;
	std::vector<std::string> to_remove;
	if (!(*channelFillMask & 3)) {
		memset(samples, 0, sampleCount * channels * sizeof(short));
	}
	for (auto it = playbacks.begin(); it != playbacks.end(); ++it) {
		const short* playbackSamples = nullptr;
		size_t playbackSampleCount = it->second->getSamples(playbackSamples);


		int outputPosition = 0;
		int inputPosition = 0;
		//mix stereo sound into multichannel sound
		while (inputPosition < sampleCount * channels && (playbackSampleCount - outputPosition) > 0) {
			for (int q = 0; q < 2; q++) {
				short s = playbackSamples[inputPosition];
				//clamp sample
				if (samples[outputPosition] + s > SHRT_MAX) {
					samples[outputPosition] = SHRT_MAX;
				} else if (samples[outputPosition] + s < SHRT_MIN) {
					samples[outputPosition] = SHRT_MIN;
				} else {
					samples[outputPosition] += s;
				}
				outputPosition++;
				inputPosition++;
				fill = true;
			}
			outputPosition += std::max(channels - 2, 0);
		}
		it->second->cleanSamples(inputPosition);
		if (it->second->isDone()) {
			to_remove.push_back(it->first);
		}
	}
	for (const std::string & it : to_remove) {
		playbacks.erase(it);
	}

	if (fill) *channelFillMask |= 3;
}

void PlaybackHandler::appendPlayback(std::string name, short* samples, int sampleCount, int channels) {
	LockGuard_exclusive<CriticalSectionLock> lock(&playbackCriticalSection);
	if (playbacks.count(name) == 0) {
		std::shared_ptr<playbackWavRaw> d = std::make_shared<playbackWavRaw>();
		playbacks[name] = d;
		d->appendSamples(samples, sampleCount, channels);
	} else {
		if (playbacks[name]->type() == playbackType::raw) {
			std::static_pointer_cast<playbackWavRaw>(playbacks[name])->appendSamples(samples, sampleCount, channels);
		} else {
			__debugbreak();
			//should not have different playback types with same name.
		}
	}
}


void PlaybackHandler::appendPlayback(std::string name, std::string filePath, stereoMode stereo, float gain) {
	LockGuard_exclusive<CriticalSectionLock> lock(&playbackCriticalSection);
	if (playbacks.count(name) == 0) {
		std::shared_ptr<clunk::WavFile> wave;
		if (wavCache.count(filePath) == 0) {
			FILE *f = fopen(filePath.c_str(), "rb");
			if (f) {
				std::shared_ptr<clunk::WavFile> wav = std::make_shared<clunk::WavFile>(f);
				wav->read();
				if (wav->ok() && wav->_spec.channels == 2 && wav->_spec.sample_rate == 48000) {
					wavCache[filePath] = wav;
					wave = wav;
				}
				fclose(f);
			}
		} else {
			wave = wavCache[filePath];
		}

		playbacks[name] = std::make_shared<playbackWavStereo>(wave.get(), stereo, gain);//we can use wave.get() because playbackWavStereo doesn't hold a ref to it
	} else {
		__debugbreak();
		//should not have different playback types with same name.
		//wavStereo types cannot append
	}
}


void PlaybackHandler::appendPlayback(std::string name, std::string filePath, std::vector<std::function<void(short*, size_t, uint8_t)>> functors) {
	LockGuard_exclusive<CriticalSectionLock> lock(&playbackCriticalSection);
	if (playbacks.count(name) == 0) {

		std::shared_ptr<clunk::WavFile> wave;
		if (wavCache.count(filePath) == 0) {
			FILE *f = fopen(filePath.c_str(), "rb");
			if (f) {
				std::shared_ptr<clunk::WavFile> wav = std::make_shared<clunk::WavFile>(f);
				wav->read();
				if (wav->ok() && wav->_spec.channels == 2 && wav->_spec.sample_rate == 48000) {
					wavCache[filePath] = wav;
					wave = wav;
				}
				fclose(f);
			}
		} else {
			wave = wavCache[filePath];
		}
		if (wave)
			playbacks[name] = std::make_shared<playbackWavProcessing>(static_cast<short*>(wave->_data.get_ptr()), (wave->_data.get_size() / sizeof(short)) / wave->_spec.channels, wave->_spec.channels, functors);
	}
}
extern serverDataDirectory serverIdToData;
extern std::shared_ptr<clientData> getClientData(uint64 serverConnectionHandlerID, anyID clientID);	//#TODO make obsolete
extern bool hasClientData(uint64 serverConnectionHandlerID, anyID clientID);//#TODO make obsolete
void PlaybackHandler::playWavFile(uint64 serverConnectionHandlerID, const char* fileNameWithoutExtension, float gain, Position3D position, bool onGround, int radioVolume, bool underwater, float vehicleVolumeLoss, bool vehicleCheck, stereoMode stereoMode) {

	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
	if (!Teamspeak::isConnected(serverConnectionHandlerID)) return;

	auto clientDataDir = TFAR::getServerDataDirectory()->getClientDataDirectory(serverConnectionHandlerID);
	if (!clientDataDir) return;

	std::string to_play = TFAR::getInstance().getPluginPath() + std::string(fileNameWithoutExtension) + ".wav";
	std::vector<std::function<void(short*, size_t, uint8_t)>> processors;
	std::string id = to_play + std::to_string(rand());
	//apply gain
	if (gain != 1.0f)
		processors.push_back([gain](short* samples, size_t sampleCount, uint8_t channels) {
		helpers::applyGain(samples, sampleCount, channels, gain);
	});

	auto myClientData = clientDataDir->myClientData;

	//#TODO to remove nesting add executeAtReturn class that calls appendPlayback at return
	if (myClientData) {
		float speakerDistance = (radioVolume / 10.f) * TFAR::getInstance().m_gameData.speakerDistance;
		float distance_from_radio = position.distanceTo(myClientData->getClientPosition());

		if (vehicleVolumeLoss > 0.01f && !vehicleCheck)
			processors.push_back([id, distance_from_radio, speakerDistance, vehicleVolumeLoss, myClientData](short* samples, size_t sampleCount, uint8_t channels) {

			helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<2>, MAX_CHANNELS>>(samples, channels, sampleCount, helpers::volumeAttenuation(distance_from_radio, true, round(speakerDistance), 1.0f - vehicleVolumeLoss) * pow(1.0f - vehicleVolumeLoss, 1.2f), myClientData->getFilterVehicle(id + "vehicle", vehicleVolumeLoss));
		});
		if (onGround) {
			processors.push_back([id, distance_from_radio, speakerDistance, myClientData](short* samples, size_t sampleCount, uint8_t channels) {
				helpers::applyGain(samples, sampleCount, channels, helpers::volumeAttenuation(distance_from_radio, true, round(speakerDistance)));
				helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::BandPass<1>, MAX_CHANNELS>>(samples, channels, sampleCount, SPEAKER_GAIN, myClientData->getSpeakerFilter(id));
			});

			if (underwater) {
				processors.push_back([id, distance_from_radio, speakerDistance, myClientData](short* samples, size_t sampleCount, uint8_t channels) {
					helpers::processFilterStereo<Dsp::SimpleFilter<Dsp::Butterworth::LowPass<4>, MAX_CHANNELS>>(samples, channels, sampleCount, CANT_SPEAK_GAIN * 50, myClientData->getFilterCantSpeak(id));
				});
			}
		} else {
			//muting for stereo mode
			if (stereoMode != stereoMode::stereo)
				processors.push_back([stereoMode](short* samples, size_t sampleCount, uint8_t channels) {

				if (channels == 2) {
					//Performance opt using 32bit operations instead of 16 bit ones
					int* samples32bit = reinterpret_cast<int*>(samples);
					if (stereoMode == stereoMode::leftOnly) {//Only left
						for (size_t q = 0; q < sampleCount / 2; q += 1) {
							samples32bit[q] &= 0xFFFF0000;//mute right channel
						}
					} else if (stereoMode == stereoMode::rightOnly) {//Only right
						for (size_t q = 0; q < sampleCount / 2; q += 1) {
							samples32bit[q] &= 0x0000FFFF;//mute left channel
						}
					}
				} else {
					if (stereoMode == stereoMode::leftOnly) {//Only left
						for (size_t q = 0; q < sampleCount * channels; q += channels) {
							samples[q + 1] = 0;//mute right channel
						}
					} else if (stereoMode == stereoMode::rightOnly) {//Only right
						for (size_t q = 0; q < sampleCount * channels; q += channels) {
							samples[q] = 0;//mute left channel
						}
					}
				}

			});

		}
		auto pClunk = myClientData->getClunk(id);
		processors.push_back([pClunk, position, myClientData, id](short* samples, size_t sampleCount, uint8_t channels) {
			auto relativePos = myClientData->getClientPosition().directionTo(position);
			auto viewDirection = myClientData->getViewDirection().toAngle();
			pClunk->process(samples, channels, static_cast<int>(sampleCount), relativePos, viewDirection); //interaural time difference
			helpers::applyILD(samples, sampleCount, channels, relativePos, viewDirection);	//interaural level difference
			myClientData->removeClunk(id);
		});
	}

	appendPlayback(id, to_play, processors);
}

void PlaybackHandler::playWavFile(const char* fileNameWithoutExtension) const {
	if (!Teamspeak::isConnected()) return;
	std::string to_play = TFAR::getInstance().getPluginPath() + std::string(fileNameWithoutExtension) + ".wav";
	Teamspeak::playWavFile(to_play);
}

void PlaybackHandler::playWavFile(uint64 serverConnectionHandlerID, const char* fileNameWithoutExtension, float gain, stereoMode stereo) {
	_MM_SET_FLUSH_ZERO_MODE(_MM_FLUSH_ZERO_ON);
	_MM_SET_DENORMALS_ZERO_MODE(_MM_DENORMALS_ZERO_ON);
	if (!Teamspeak::isConnected(serverConnectionHandlerID)) return;
	std::string to_play = TFAR::getInstance().getPluginPath() + std::string(fileNameWithoutExtension) + ".wav";

	appendPlayback(to_play + std::to_string(rand()), to_play, stereo, gain);
}

void playbackWavStereo::construct(clunk::WavFile* wavFile, stereoMode stereo, float gain) {
	if (wavFile->ok() && wavFile->_spec.channels == 2 && wavFile->_spec.sample_rate == 48000 && wavFile->_spec.format == clunk::AudioSpec::S16) {
		construct(static_cast<short*>(wavFile->_data.get_ptr()), (wavFile->_data.get_size() / sizeof(short)) / wavFile->_spec.channels, wavFile->_spec.channels, stereo, gain);
	} else if (wavFile->ok()) {
		MessageBoxA(0, "Unknown audio file has invalid format.", "Task Force Arrowhead Radio", MB_OK);
	}
}

void playbackWavStereo::construct(std::string wavFilePath, stereoMode stereo, float gain) {
	FILE *f = fopen(wavFilePath.c_str(), "rb");
	if (f) {
		clunk::WavFile* wav = new clunk::WavFile(f);
		wav->read();
		if (!wav->ok() || wav->_spec.channels != 2 || wav->_spec.sample_rate != 48000 || wav->_spec.format != clunk::AudioSpec::S16) {
			char buffer[MAX_PATH + const_strlen("File %s has invalid format.")];
			_snprintf_s(buffer, MAX_PATH + const_strlen("File %s has invalid format."), _TRUNCATE, "File %s has invalid format.", wavFilePath.c_str());
			MessageBoxA(0, buffer, "Task Force Arrowhead Radio", MB_OK);
		} else {
			construct(wav, stereo, gain);
		}
		fclose(f);
		delete wav;
	} else {
		log_string("Can't Open file " + wavFilePath, LogLevel_ERROR);
	}
}

void playbackWavStereo::construct(const short* samples, size_t sampleCount, uint8_t channels, stereoMode stereo, float gain) {
	sampleStore.assign(sampleCount * 2, 0);
	if (stereo == stereoMode::stereo) {
		if (channels == 2)
			memcpy(sampleStore.data(), samples, sampleCount*channels);//everything like we want it..
		else {
			short* target = sampleStore.data();
			uint32_t posInTarget = 0;
			for (uint32_t q = 0; q < sampleCount*channels; q += channels) {
				target[posInTarget++] = samples[q];//copy left channel
				target[posInTarget++] = samples[q + 1];//copy right channel
			}
		}
	} else if (stereo == stereoMode::leftOnly) {
		short* target = sampleStore.data();
		uint32_t posInTarget = 0;
		for (uint32_t q = 0; q < sampleCount*channels; q += channels) {
			target[posInTarget++] = samples[q];//only copy left channel
			posInTarget++;//leave right channel 0
		}
	} else if (stereo == stereoMode::rightOnly) {
		short* target = sampleStore.data();
		uint32_t posInTarget = 0;
		for (uint32_t q = 0; q < sampleCount*channels; q += channels) {
			posInTarget++;//leave left channel 0
			target[posInTarget++] = samples[q + 1];//only copy right channel
		}
	}
	helpers::applyGain(sampleStore.data(), sampleCount, 2, gain);
}


playbackWavStereo::playbackWavStereo(const short* samples, size_t sampleCount, uint8_t channels, stereoMode stereo, float gain /*= 1.0f*/) : currentPosition(0) {
	construct(samples, sampleCount, channels, stereo, gain);
}

playbackWavStereo::playbackWavStereo(clunk::WavFile* wavFile, stereoMode stereo, float gain /*= 1.0f*/) : currentPosition(0) {
	construct(wavFile, stereo, gain);
}


playbackWavStereo::playbackWavStereo(std::string wavFilePath, stereoMode stereo, float gain) : currentPosition(0) {
	construct(wavFilePath, stereo, gain);
}

playbackWavStereo::~playbackWavStereo() {
	sampleStore.clear();
}

size_t playbackWavStereo::getSamples(const short* &data) {
	data = sampleStore.data() + currentPosition;
	return sampleStore.size() - currentPosition;//current position can never be bigger than sampleStore.size()
}

size_t playbackWavStereo::cleanSamples(size_t sampleCount) {
	size_t increase = std::min(sampleCount, sampleStore.size() - currentPosition);
	currentPosition += increase;
	if (isDone()) {
		sampleStore.clear();
		currentPosition = 0;
	}
	return increase;
}


playbackWavRaw::playbackWavRaw() :currentPosition(0) {
#ifdef DEBUG_PLAYBACK_TIMES
	creation = std::chrono::high_resolution_clock::now();
#endif
}

size_t playbackWavRaw::getSamples(const short*& data) {
#ifdef DEBUG_PLAYBACK_TIMES
	std::call_once(flag1, [this]() {
		std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2 - creation).count();
		log_string("raw use " + std::to_string(duration), LogLevel_WARNING);
	});
#endif
	data = sampleStore.data() + currentPosition;
	return sampleStore.size() - currentPosition;//current position can never be bigger than sampleStore.size()
}

size_t playbackWavRaw::cleanSamples(size_t sampleCount) {
	size_t increase = std::min(sampleCount, sampleStore.size() - currentPosition);
	currentPosition += increase;
	if (isDone()) {
		sampleStore.clear();
		currentPosition = 0;
	}
	return increase;
}

void playbackWavRaw::appendSamples(const short* samples, size_t sampleCount, uint8_t channels) {
	sampleStore.reserve(sampleStore.size() + (sampleCount * 2));
	short* previousEnd = &(*sampleStore.insert(sampleStore.end(), samples, samples + (sampleCount * 2)));
	//Even if channelcount is not 2 we still want to set the new vector size
	//If its not stereo we overwrite the data again with the proper 2 channel stuff
	if (channels != 2) {
		uint32_t posInTarget = 0;
		for (uint32_t q = 0; q < sampleCount; q += channels) {
			previousEnd[posInTarget++] = samples[q];//copy left channel
			previousEnd[posInTarget++] = samples[q + 1];//copy right channel
		}
	}
}

playbackWavProcessing::playbackWavProcessing(short* samples, size_t sampleCount, int channels, std::vector<std::function<void(short*, size_t, uint8_t)>> processors)
	: currentPosition(0), processingDone(false), myThread(nullptr) {
	functors = processors;
	short* previousEnd = &(*sampleStore.insert(sampleStore.end(), samples, samples + (sampleCount * 2)));
	//Even if channelcount is not 2 we still want to set the new vector size
	//If its not stereo we overwrite the data again with the proper 2 channel stuff
	if (channels != 2) {
		size_t posInTarget = 0;
		for (size_t q = 0; q < sampleCount; q += channels) {
			previousEnd[posInTarget++] = samples[q];//copy left channel
			previousEnd[posInTarget++] = samples[q + 1];//copy right channel
		}
	}
#ifdef DEBUG_PLAYBACK_TIMES
	std::chrono::high_resolution_clock::time_point t1 = std::chrono::high_resolution_clock::now();
#endif
	myThread = new std::thread([this, sampleCount]() {
		for (auto it : functors) {
			it(sampleStore.data(), sampleCount, 2);
		}
		processingDone = true;
	});
#ifdef DEBUG_PLAYBACK_TIMES
	std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
	creation = t2;
	auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2 - t1).count();
	log_string("processing init " + std::to_string(duration), LogLevel_WARNING);
#endif
}

size_t playbackWavProcessing::getSamples(const short*& data) {
	if (!processingDone) {
#ifdef DEBUG_PLAYBACK_TIMES
		//This was used to diagnose the time myThread->join() would block if it wasn't done yet
		std::chrono::high_resolution_clock::time_point t1 = std::chrono::high_resolution_clock::now();
#endif
		//when someone implements waiting again consider next comment
		//Add possibility to wait instead of skipping (add mutex lock so we actually wait for the thread to end) 
		//myThread->join(); //if thread doesnt exist here something is seriously wrong.. Should check for nullptr
		//delete myThread;
#ifdef DEBUG_PLAYBACK_TIMES
		std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2 - t1).count();
		log_string("processing skip " + std::to_string(duration), LogLevel_WARNING);
#endif
		return 0;
	}
#ifdef DEBUG_PLAYBACK_TIMES
	std::call_once(flag1, [this]() {
		std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
		auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2 - creation).count();
		log_string("processing use " + std::to_string(duration), LogLevel_WARNING);
	});
#endif
	data = sampleStore.data() + currentPosition;
	return sampleStore.size() - currentPosition;//current position can never be bigger than sampleStore.size()
}

size_t playbackWavProcessing::cleanSamples(size_t sampleCount) {
	size_t increase = std::min(sampleCount, sampleStore.size() - currentPosition);
	currentPosition += increase;
	if (isDone()) {
		sampleStore.clear();
		currentPosition = 0;
	}
	return increase;
}

bool playbackWavProcessing::samplesReady() {
	return true;//implement threading
}
