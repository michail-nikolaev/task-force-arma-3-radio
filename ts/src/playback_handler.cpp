#include "playback_handler.h"
#include <vector>

#include "helpers.h"
playback_handler::playback_handler() { InitializeCriticalSection(&playbackCriticalSection); }


playback_handler::~playback_handler() {}

void playback_handler::onEditMixedPlaybackVoiceDataEvent(short * samples, int sampleCount, int channels, const unsigned int * channelSpeakerArray, unsigned int * channelFillMask) {
	CriticalSectionLock lock(&playbackCriticalSection);
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
		while (inputPosition < sampleCount * channels && (playbackSampleCount-outputPosition) > 0) {
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
			outputPosition += max(channels - 2, 0);
		}
		it->second->cleanSamples(inputPosition);
		if (it->second->isDone()) {
			to_remove.push_back(it->first);
		}
	}
	for (const std::string & it: to_remove) {
		playbacks.erase(it);
	}

	if (fill) *channelFillMask |= 3;
}

void playback_handler::appendPlayback(std::string name, short* samples, int sampleCount, int channels) {
	CriticalSectionLock lock(&playbackCriticalSection);
	if (playbacks.count(name) == 0) {
		std::shared_ptr<playbackWavRaw> d = std::make_shared<playbackWavRaw>();
		playbacks[name] = d;
		d->appendSamples(samples, sampleCount, channels);
	} else {
		if (playbacks[name]->type() == playbackType::raw) {
			std::static_pointer_cast<playbackWavRaw>(playbacks[name])->appendSamples(samples, sampleCount, channels);
		}  else {
			__debugbreak();
			//should not have different playback types with same name.
		}
	}
}


void playback_handler::appendPlayback(std::string name, std::string filePath, stereoMode stereo,float gain) {
	CriticalSectionLock lock(&playbackCriticalSection);
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

void playbackWavStereo::construct(clunk::WavFile* wavFile, stereoMode stereo, float gain) {
	if (wavFile->ok() && wavFile->_spec.channels == 2 && wavFile->_spec.sample_rate == 48000 && wavFile->_spec.format == clunk::AudioSpec::S16) {
		construct(static_cast<short*>(wavFile->_data.get_ptr()), wavFile->_data.get_size() / sizeof(short), wavFile->_spec.channels, stereo, gain);
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
			construct(wav, stereo,gain);
		}
		fclose(f);
		delete wav;
	}
	//#TODO else log error to teamspeak
}

void playbackWavStereo::construct(const short* samples, size_t sampleCount, uint8_t channels, stereoMode stereo, float gain)  {
	sampleStore.assign(sampleCount * 2,0);
	if (stereo == stereoMode::stereo) {
		if (channels == 2)
			memcpy(sampleStore.data(), samples, sampleCount*channels);//everything like we want it..
		else {
			short* target = sampleStore.data();
			uint32_t posInTarget = 0;
			for (uint32_t q = 0; q < sampleCount; q += channels) {
				target[posInTarget++] = samples[q];//copy left channel
				target[posInTarget++] = samples[q + 1];//copy right channel
			}
		}
	} else if (stereo == stereoMode::leftOnly) {
		short* target = sampleStore.data();
		uint32_t posInTarget = 0;
		for (uint32_t q = 0; q < sampleCount; q += channels) {
			target[posInTarget++] = samples[q];//only copy left channel
			posInTarget++;//leave right channel 0
		}
	} else if (stereo == stereoMode::rightOnly) {
		short* target = sampleStore.data();
		uint32_t posInTarget = 0;
		for (uint32_t q = 0; q < sampleCount; q += channels) {
			posInTarget++;//leave left channel 0
			target[posInTarget++] = samples[q + 1];//only copy right channel
		}
	}
	helpers::applyGain(sampleStore.data(),2, sampleCount, gain);
}


playbackWavStereo::playbackWavStereo(const short* samples, size_t sampleCount, uint8_t channels, stereoMode stereo, float gain /*= 1.0f*/) : currentPosition(0) {
	construct(samples, sampleCount, channels, stereo, gain);
}


playbackWavStereo::playbackWavStereo(clunk::WavFile* wavFile, stereoMode stereo, float gain /*= 1.0f*/) : currentPosition(0) {
	construct(wavFile, stereo, gain);
}


playbackWavStereo::playbackWavStereo(std::string wavFilePath, stereoMode stereo, float gain) : currentPosition(0) {
	construct(wavFilePath, stereo,gain);
}

playbackWavStereo::~playbackWavStereo() {
	sampleStore.clear();
}

size_t playbackWavStereo::getSamples(const short* &data) {
	data = sampleStore.data() + currentPosition;
	return sampleStore.size() - currentPosition;//current position can never be bigger than sampleStore.size()
}

size_t playbackWavStereo::cleanSamples(size_t sampleCount) {
	size_t increase = min(sampleCount, sampleStore.size() - currentPosition);
	currentPosition += increase;
	if (isDone()) {
		sampleStore.clear();
		currentPosition = 0;
	}
	return increase;
}

size_t playbackWavRaw::getSamples(const short*& data) {
	std::chrono::high_resolution_clock::time_point t2 = std::chrono::high_resolution_clock::now();
	auto duration = std::chrono::duration_cast<std::chrono::microseconds>(t2 - creation).count();
	log_string("raw use " + std::to_string(duration), LogLevel_WARNING);

	data = sampleStore.data() + currentPosition;
	return sampleStore.size() - currentPosition;//current position can never be bigger than sampleStore.size()
}

size_t playbackWavRaw::cleanSamples(size_t sampleCount) {
	size_t increase = min(sampleCount, sampleStore.size() - currentPosition);
	currentPosition += increase;
	if (isDone()) {
		sampleStore.clear();
		currentPosition = 0;
	}	
	return increase;
}

void playbackWavRaw::appendSamples(const short* samples, size_t sampleCount, uint8_t channels) {
	sampleStore.reserve(sampleStore.size() + (sampleCount * 2));
	short* previousEnd = &(*sampleStore.end());
	sampleStore.insert(sampleStore.end(), samples, samples + (sampleCount * 2));
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
