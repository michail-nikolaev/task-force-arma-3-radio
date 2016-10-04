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
#include <chrono>
#include <functional>
#include <thread>
#include <mutex>
/*
 Dedmen:
 This style of separate functions for getting and removing may seem weird.
 My first thought for this was that i was going to use queue's which i scrapped for performance reasons.
 But I left that style to give more freedom to underlying containers. I don't really know why... But I'll still leave it.
*/
enum class playbackType {
	base,
	stereo,
	raw,
	processing
};

class playbackBase {
protected:
	playbackBase() {}
	~playbackBase() {}
public:
	//************************************
	// Method:    getSamples
	// FullName:  playbackBase::getSamples
	// Returns:   uint32_t availableSamples - the actual amount of samples available in data
	// Parameter: short * & data - will contain pointer to data after call
	// Description:	Used to retrieve a Pointer to the beginning of the internal buffer.	 
	//				After processing cleanSamples should be called with the amount of availableSamples returned by this function 
	//************************************
	virtual size_t getSamples(const short*& data) = 0;
	//************************************
	// Method:    cleanSamples
	// FullName:  playbackBase::cleanSamples
	// Returns:   uint32_t removedSamples - the amount of samples actually removed
	// Parameter: uint32_t sampleCount - the amount of samples to remove from the internal buffer
	// Description: This will remove sampleCount samples from the beginning of the internal buffer.
	//************************************
	virtual size_t cleanSamples(size_t sampleCount) = 0;
	//************************************
	// Method:    samplesReady
	// FullName:  playbackBase::samplesReady
	// Returns:   bool ready - If all samples are processed and ready for playback
	// Description: This can be used to determine if a playback that has effects applied to it 
	//				has all samples processed and is ready to output them.
	//				If this returns false then getSamples would block till the thread doing the processing is done. 
	//************************************
	virtual bool samplesReady() { return true; }

	virtual bool isDone() { return false; }	//#DOCS 
	virtual playbackType type() { return playbackType::base; }
	/*
	looping playback may need some way to tell when to stop looping
	*/
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
	playbackWavStereo(const short* samples, size_t sampleCount, uint8_t channels, stereoMode stereo, float gain = 1.0f); //#DOCS
	playbackWavStereo(clunk::WavFile* wavFile, stereoMode stereo, float gain = 1.0f);  //#DOCS
	playbackWavStereo(std::string wavFilePath, stereoMode stereo, float gain = 1.0f);	//#DOCS
	virtual ~playbackWavStereo();
	//************************************
	// Method:    getSamples
	// FullName:  playbackBase::getSamples
	// Returns:   uint32_t availableSamples - the actual amount of samples available in data
	// Parameter: short * & data - will contain pointer to data after call
	// Description:	Used to retrieve a Pointer to the beginning of the internal buffer.	 
	//				After processing cleanSamples should be called with the amount of availableSamples returned by this function 
	//************************************
	virtual size_t getSamples(const short*& data);
	//************************************
	// Method:    cleanSamples
	// FullName:  playbackBase::cleanSamples
	// Returns:   uint32_t removedSamples - the amount of samples actually removed
	// Parameter: uint32_t sampleCount - the amount of samples to remove from the internal buffer
	// Description: This will remove sampleCount samples from the beginning of the internal buffer.
	//************************************
	virtual size_t cleanSamples(size_t sampleCount);
	//************************************
	// Method:    samplesReady
	// FullName:  playbackBase::samplesReady
	// Returns:   bool ready - If all samples are processed and ready for playback
	// Description: This can be used to determine if a playback that has effects applied to it 
	//				has all samples processed and is ready to output them.
	//				If this returns false then getSamples would block till the thread doing the processing is done. 
	//************************************
	virtual bool samplesReady() { return true; }
	virtual bool isDone() { return currentPosition == sampleStore.size(); }
	virtual playbackType type() { return playbackType::stereo; }
private:
	void construct(const short* samples, size_t sampleCount, uint8_t channels, stereoMode stereo, float gain); //#DOCS
	void construct(clunk::WavFile* wavFile, stereoMode stereo, float gain);  //#DOCS
	void construct(std::string wavFilePath, stereoMode stereo, float gain);	//#DOCS
	std::vector<short> sampleStore;
	size_t currentPosition;
};

//************************************
// Class:    playbackWavRaw
// Description:	A basic wav playback that only plays back samples
//************************************
class playbackWavRaw : public playbackBase {
public:
	//playbackWavRaw(short* samples, size_t sampleCount, uint8_t channels); //#DOCS
	playbackWavRaw() :currentPosition(0) { creation = std::chrono::high_resolution_clock::now(); }; //#DOCS
	virtual ~playbackWavRaw() {};
	//************************************
	// Method:    getSamples
	// FullName:  playbackBase::getSamples
	// Returns:   uint32_t availableSamples - the actual amount of samples available in data
	// Parameter: short * & data - will contain pointer to data after call
	// Description:	Used to retrieve a Pointer to the beginning of the internal buffer.	 
	//				After processing cleanSamples should be called with the amount of availableSamples returned by this function 
	//************************************
	virtual size_t getSamples(const short*& data);
	//************************************
	// Method:    cleanSamples
	// FullName:  playbackBase::cleanSamples
	// Returns:   uint32_t removedSamples - the amount of samples actually removed
	// Parameter: uint32_t sampleCount - the amount of samples to remove from the internal buffer
	// Description: This will remove sampleCount samples from the beginning of the internal buffer.
	//************************************
	virtual size_t cleanSamples(size_t sampleCount);
	//************************************
	// Method:    samplesReady
	// FullName:  playbackBase::samplesReady
	// Returns:   bool ready - If all samples are processed and ready for playback
	// Description: This can be used to determine if a playback that has effects applied to it 
	//				has all samples processed and is ready to output them.
	//				If this returns false then getSamples would block till the thread doing the processing is done. 
	//************************************
	virtual bool samplesReady() { return true; }
	virtual bool isDone() { return currentPosition == sampleStore.size(); }
	void appendSamples(const short* samples, size_t sampleCount, uint8_t channels);
	virtual playbackType type() { return playbackType::raw; }
	std::chrono::high_resolution_clock::time_point creation;
	std::once_flag flag1;
private:
	std::vector<short> sampleStore;
	size_t currentPosition;
};

//************************************
// Class:    playbackWavProcessing
// Description:	A playback that does more in-depth processing on audio data
//************************************
class playbackWavProcessing : public playbackBase {
public:
	playbackWavProcessing(short* samples, size_t sampleCount, int channels, std::vector<std::function<void(short*, size_t, uint8_t)>> processors); //#DOCS
	virtual ~playbackWavProcessing() {};
	//************************************
	// Method:    getSamples
	// FullName:  playbackBase::getSamples
	// Returns:   uint32_t availableSamples - the actual amount of samples available in data
	// Parameter: short * & data - will contain pointer to data after call
	// Description:	Used to retrieve a Pointer to the beginning of the internal buffer.	 
	//				After processing cleanSamples should be called with the amount of availableSamples returned by this function 
	//************************************
	virtual size_t getSamples(const short*& data);
	//************************************
	// Method:    cleanSamples
	// FullName:  playbackBase::cleanSamples
	// Returns:   uint32_t removedSamples - the amount of samples actually removed
	// Parameter: uint32_t sampleCount - the amount of samples to remove from the internal buffer
	// Description: This will remove sampleCount samples from the beginning of the internal buffer.
	//************************************
	virtual size_t cleanSamples(size_t sampleCount);
	//************************************
	// Method:    samplesReady
	// FullName:  playbackBase::samplesReady
	// Returns:   bool ready - If all samples are processed and ready for playback
	// Description: This can be used to determine if a playback that has effects applied to it 
	//				has all samples processed and is ready to output them.
	//				If this returns false then getSamples would block till the thread doing the processing is done. 
	//************************************
	virtual bool samplesReady();
	virtual bool isDone() { return currentPosition == sampleStore.size(); }
	virtual playbackType type() { return playbackType::processing; }
	std::chrono::high_resolution_clock::time_point creation;
	std::once_flag flag1;
private:
	std::vector<short> sampleStore;
	size_t currentPosition;
	std::atomic<bool> processingDone;
	std::vector<std::function<void(short*, size_t, uint8_t)>> functors;
	std::thread* myThread;
};








class playback_handler {
public:
	playback_handler();
	~playback_handler();

	void onEditMixedPlaybackVoiceDataEvent(short* samples, int sampleCount, int channels, const unsigned int* channelSpeakerArray, unsigned int* channelFillMask);
	void appendPlayback(std::string name, short* samples, int sampleCount, int channels);
	void appendPlayback(std::string name, std::string filePath, stereoMode stereo = stereoMode::stereo, float gain = 1.0f);
	//functors is short* samples,int sampleCount,int channels
	void appendPlayback(std::string name, std::string filePath, std::vector<std::function<void(short*, size_t, uint8_t)>> functors);
	//tangentReleased(serverconhandler,clientID) iterates through playbacks and calls their onTangentReleased funcs
	std::map<std::string, std::shared_ptr<playbackBase>> playbacks;
	std::map<std::string, std::shared_ptr<clunk::WavFile>> wavCache;
	CRITICAL_SECTION playbackCriticalSection;
};

