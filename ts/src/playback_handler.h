#pragma once
#include <stdint.h>
#include <windows.h>
#include <map>
#include <deque>

struct SERVER_PLAYBACK {
	//#TODO add mixable sound class. subclassable to play repeating sound. vector<short> getSamples(sampleCount) , bool isDone();
	//event callback when player releases tangent. because some repeating sounds want to go into done state then.
	std::map<std::string, std::deque<short>> playback;
};

class playback_handler {
public:
	playback_handler();
	~playback_handler();

	void onEditMixedPlaybackVoiceDataEvent(uint64_t serverConnectionHandlerID, short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask);
	void appendPlayback(std::string name, uint64_t serverConnectionHandlerID, short* samples, int sampleCount, int channels);
	void addServer(uint64_t serverConnectionHandlerID);

	 //tangentReleased(serverconhandler,clientID) iterates through playbacks and calls their onTangentReleased funcs
	std::map<uint64_t, SERVER_PLAYBACK> serverIdToPlayback;

	CRITICAL_SECTION playbackCriticalSection;
};

