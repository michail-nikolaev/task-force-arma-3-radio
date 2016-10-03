#include "playback_handler.h"
#include <vector>

#include "helpers.h"
playback_handler::playback_handler() { InitializeCriticalSection(&playbackCriticalSection); }


playback_handler::~playback_handler() {}

void playback_handler::onEditMixedPlaybackVoiceDataEvent(uint64_t serverConnectionHandlerID, short * samples, int sampleCount, int channels, const unsigned int * channelSpeakerArray, unsigned int * channelFillMask) {
	CriticalSectionLock lock(&playbackCriticalSection);
	bool fill = false;
	std::vector<std::string> to_remove;
	if (!(*channelFillMask & 3)) {
		memset(samples, 0, sampleCount * channels * sizeof(short));
	}
	for (auto it = serverIdToPlayback[serverConnectionHandlerID].playback.begin(); it != serverIdToPlayback[serverConnectionHandlerID].playback.end(); ++it) {
		int position = 0;
		while (position < sampleCount * channels && it->second.size() > 0) {
			for (int q = 0; q < 2; q++) {
				short s = it->second.at(0);
				if (samples[position] + s > SHRT_MAX) {
					samples[position] = SHRT_MAX;
				} else if (samples[position] + s < SHRT_MIN) {
					samples[position] = SHRT_MIN;
				} else {
					samples[position] += s;
				}
				position++;
				it->second.pop_front();
				fill = true;
			}
			for (int q = 2; q < channels; q++) {
				samples[position++] = 0;
			}
		}
		if (it->second.size() == 0) {
			to_remove.push_back(it->first);
		}
	}

	for (auto it = to_remove.begin(); it != to_remove.end(); ++it) {	 //#FOREACH
		serverIdToPlayback[serverConnectionHandlerID].playback.erase(*it);
	}

	if (fill) *channelFillMask |= 3;
}

void playback_handler::appendPlayback(std::string name, uint64_t serverConnectionHandlerID, short* samples, int sampleCount, int channels) {
	CriticalSectionLock lock(&playbackCriticalSection);
	if (serverIdToPlayback[serverConnectionHandlerID].playback.count(name) == 0) {
		std::deque<short> d;
		serverIdToPlayback[serverConnectionHandlerID].playback[name] = d;
	}
	if (channels == 2) {
		for (int q = 0; q < sampleCount * channels; q++) {
			serverIdToPlayback[serverConnectionHandlerID].playback[name].push_back(samples[q]);
		}
	} else {
		for (int q = 0; q < sampleCount * channels; q++) {
			serverIdToPlayback[serverConnectionHandlerID].playback[name].push_back(samples[q * 2]);
			serverIdToPlayback[serverConnectionHandlerID].playback[name].push_back(samples[q * 2 + 1]);
		}
	}
}

void playback_handler::addServer(uint64_t serverConnectionHandlerID) {
	CriticalSectionLock lock(&playbackCriticalSection);//std::map is ordered so we need a lock here
	serverIdToPlayback[serverConnectionHandlerID] = SERVER_PLAYBACK();
}

playbackWavStereo::playbackWavStereo(clunk::WavFile* wavFile, stereoMode stereo) {
	if (wavFile->ok() && wavFile->_spec.channels == 2 && wavFile->_spec.sample_rate == 48000 && wavFile->_spec.format == clunk::AudioSpec::S16) {
		playbackWavStereo(static_cast<short*>(wavFile->_data.get_ptr()), wavFile->_data.get_size() / sizeof(short), wavFile->_spec.channels, stereo);
	} else if (wavFile->ok()) {
		MessageBoxA(0, "Unknown audio file has invalid format.", "Task Force Arrowhead Radio", MB_OK);
	}
}

playbackWavStereo::playbackWavStereo(std::string wavFilePath, stereoMode stereo) {
	FILE *f = fopen(wavFilePath.c_str(), "rb");
	if (f) {
		clunk::WavFile* wav = new clunk::WavFile(f);
		wav->read();
		if (!wav->ok() || wav->_spec.channels != 2 || wav->_spec.sample_rate != 48000 || wav->_spec.format != clunk::AudioSpec::S16) {
			char buffer[MAX_PATH + const_strlen("File %s has invalid format.")];
			_snprintf_s(buffer, MAX_PATH + const_strlen("File %s has invalid format."), _TRUNCATE, "File %s has invalid format.", wavFilePath.c_str());
			MessageBoxA(0, buffer, "Task Force Arrowhead Radio", MB_OK);
		} else {
			playbackWavStereo(wav, stereo);
		}
		fclose(f);
		delete wav;
	}
	//#TODO else log error to teamspeak
}

playbackWavStereo::playbackWavStereo(short* samples, uint32_t sampleCount, uint8_t channels, stereoMode stereo) : currentPosition(0) {
	sampleStore.reserve(sampleCount * 2);
	if (stereo == stereoMode::stereo) {
		if (channels == 2)
			memcpy(sampleStore.data(), samples, sampleCount*channels);
		else {
			short* target = sampleStore.data();
			for (uint32_t q = 0; q < sampleCount; q += 2) {
				target[q] = samples[(q*channels)];//copy left channel
				target[q + 1] = samples[(q*channels) + 1];//copy right channel
			}
		}
	} else if (stereo == stereoMode::leftOnly) {
		short* target = sampleStore.data();
		for (uint32_t q = 0; q < sampleCount; q += 2) {
			target[q] = samples[(q*channels)];//only copy left channel
		}
	} else if (stereo == stereoMode::rightOnly) {
		short* target = sampleStore.data();
		for (uint32_t q = 0; q < sampleCount; q += 2) {
			target[q + 1] = samples[(q*channels) + 1] = 0;//only copy right channel
		}
	}
}


playbackWavStereo::~playbackWavStereo() {
	sampleStore.clear();
}

uint32_t playbackWavStereo::getSamples(const short* &data) {
	data = sampleStore.data() + currentPosition;
	return sampleStore.size() - currentPosition;//current position can never be bigger than sampleStore.size()
}

uint32_t playbackWavStereo::cleanSamples(uint32_t sampleCount) {
	uint32_t increase = min(sampleCount, sampleStore.size() - currentPosition);
	currentPosition += increase;
	return increase;
}
