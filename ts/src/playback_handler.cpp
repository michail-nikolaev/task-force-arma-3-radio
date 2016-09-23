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
