#pragma once
#include <stdint.h>
#include <windows.h>
#include <map>
#include <deque>
#include <atomic>
#include <vector>
#include "clunk/wav_file.h"
#include "common.h"
#include <memory>

/*
 Dedmen:
 This style of separate functions for getting and removing may seem weird.
 My first thought for this was that i was going to use queue's which i scrapped for performance reasons.
 But I left that style to give more freedom to underlying containers. I don't really know why... But I'll still leave it.
*/


class playbackBase {
protected:
	playbackBase() {}
	~playbackBase() {}
	//************************************
	// Method:    getSamples
	// FullName:  playbackBase::getSamples
	// Returns:   uint32_t availableSamples - the actual amount of samples available in data
	// Parameter: short * & data - will contain pointer to data after call
	// Description:	Used to retrieve a Pointer to the beginning of the internal buffer.	 
	//				After processing cleanSamples should be called with the amount of availableSamples returned by this function 
	//************************************
	virtual uint32_t getSamples(const short*& data) = 0;
	//************************************
	// Method:    cleanSamples
	// FullName:  playbackBase::cleanSamples
	// Returns:   uint32_t removedSamples - the amount of samples actually removed
	// Parameter: uint32_t sampleCount - the amount of samples to remove from the internal buffer
	// Description: This will remove sampleCount samples from the beginning of the internal buffer.
	//************************************
	virtual uint32_t cleanSamples(uint32_t sampleCount) = 0;
	//************************************
	// Method:    samplesReady
	// FullName:  playbackBase::samplesReady
	// Returns:   bool ready - If all samples are processed and ready for playback
	// Description: This can be used to determine if a playback that has effects applied to it 
	//				has all samples processed and is ready to output them.
	//				If this returns false then getSamples would block till the thread doing the processing is done. 
	//************************************
	virtual bool samplesReady() { return true; };
};

//************************************
// Class:    playbackWavStereo
// Description:	A basic wav playback that only has processing for setting the stereo channel.
//				Construction is slow because processing stereo of setting is done in constructor.
//************************************
class playbackWavStereo : public playbackBase {
public:
	static std::shared_ptr<playbackWavStereo> create(short* samples, uint32_t sampleCount, uint8_t channels, stereoMode stereo) {
		return std::make_shared<playbackWavStereo>(samples, sampleCount, channels, stereo);
	}
	static std::shared_ptr<playbackWavStereo> create(clunk::WavFile* wavFile, stereoMode stereo) {
		return std::make_shared<playbackWavStereo>(wavFile, stereo);
	}
	static std::shared_ptr<playbackWavStereo> create(std::string wavFilePath, stereoMode stereo) {
		return std::make_shared<playbackWavStereo>(wavFilePath, stereo);
	}
	virtual ~playbackWavStereo();
	//************************************
	// Method:    getSamples
	// FullName:  playbackBase::getSamples
	// Returns:   uint32_t availableSamples - the actual amount of samples available in data
	// Parameter: short * & data - will contain pointer to data after call
	// Description:	Used to retrieve a Pointer to the beginning of the internal buffer.	 
	//				After processing cleanSamples should be called with the amount of availableSamples returned by this function 
	//************************************
	virtual uint32_t getSamples(const short*& data);
	//************************************
	// Method:    cleanSamples
	// FullName:  playbackBase::cleanSamples
	// Returns:   uint32_t removedSamples - the amount of samples actually removed
	// Parameter: uint32_t sampleCount - the amount of samples to remove from the internal buffer
	// Description: This will remove sampleCount samples from the beginning of the internal buffer.
	//************************************
	virtual uint32_t cleanSamples(uint32_t sampleCount);
	//************************************
	// Method:    samplesReady
	// FullName:  playbackBase::samplesReady
	// Returns:   bool ready - If all samples are processed and ready for playback
	// Description: This can be used to determine if a playback that has effects applied to it 
	//				has all samples processed and is ready to output them.
	//				If this returns false then getSamples would block till the thread doing the processing is done. 
	//************************************
	virtual bool samplesReady() { return true; };
private:
	playbackWavStereo(short* samples, uint32_t sampleCount, uint8_t channels, stereoMode stereo); //#DOCS
	playbackWavStereo(clunk::WavFile* wavFile, stereoMode stereo);  //#DOCS
	playbackWavStereo(std::string wavFilePath, stereoMode stereo);	//#DOCS
	std::vector<short> sampleStore;
	uint32_t currentPosition;
};



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

