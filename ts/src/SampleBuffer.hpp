#pragma once
#include <algorithm>
#include <memory>
#include <variant>
#include <vector>

#define CAN_USE_SSE_ON(x) (IsProcessorFeaturePresent(PF_XMMI64_INSTRUCTIONS_AVAILABLE) && (reinterpret_cast<uintptr_t>(x) % 16 == 0))

class SampleBuffer {
    class SampleBufferInternal {
        struct SampleStruct {
            short* samples;
            uint32_t sampleCount;
        };
        std::variant < std::vector<short>, SampleStruct> samples;
        uint8_t channels;
    public:
        SampleBufferInternal(short* samples, uint32_t sampleCount, uint8_t channels) : samples(SampleStruct{ samples,sampleCount }), channels(channels) {}
        SampleBufferInternal(uint32_t sampleCount, uint8_t channels) : samples([sampleCount, channels]() {std::vector<short> vec; vec.resize(sampleCount*channels); return vec; }()), channels(channels) {}
        short* getSamples() {
            return begin();
        }
        uint32_t getSampleCount() const {
            if (auto vec = std::get_if<std::vector<short>>(&samples)) {
                return vec->size()/channels;
            }
            if (auto strct = std::get_if<SampleStruct>(&samples)) {
                return strct->sampleCount;
            }
            return 0;
        }
        uint8_t getChannels() const { return channels; }

        short* begin() {
            if (auto vec = std::get_if<std::vector<short>>(&samples)) {
                return vec->begin()._Ptr;
            }
            if (auto strct = std::get_if<SampleStruct>(&samples)) {
                return strct->samples;
            }
            return nullptr;
        }

        short* end() {
            if (auto vec = std::get_if<std::vector<short>>(&samples)) {
                return vec->end()._Ptr;
            }
            if (auto strct = std::get_if<SampleStruct>(&samples)) {
                return strct->samples + strct->sampleCount * channels;
            }
            return nullptr;
        }
        void copyTo(std::shared_ptr<SampleBufferInternal> target) {
            auto targetSpace = target->getSampleCount();
            if (targetSpace < getSampleCount()) __debugbreak();
            std::copy(begin(), end(), target->begin());
        }
    };
    std::shared_ptr<SampleBufferInternal> samples;

public:
    SampleBuffer() {}
    SampleBuffer(const SampleBuffer& other) : samples(other.samples) {}
    SampleBuffer(SampleBuffer&& other) : samples(std::move(other.samples)) {}
    SampleBuffer(short* samples, uint32_t sampleCount, uint8_t channels) : samples(std::make_shared<SampleBufferInternal>(samples, sampleCount, channels)) {}
    SampleBuffer(uint32_t sampleCount, uint8_t channels) : samples(std::make_shared<SampleBufferInternal>(sampleCount, channels)) {}


    class StereoIterator {
        using iterator_category = std::random_access_iterator_tag;
        using value_type = std::pair<short, short>;
        using difference_type = size_t;
        using pointer = std::pair<std::reference_wrapper<short>, std::reference_wrapper<short>>*;
        using reference = std::pair<short&, short&>;
        short* curSample{ nullptr };
        uint8_t channels{ 2 };
    public:
        explicit StereoIterator(short* sample, uint8_t channels) : curSample(sample), channels(channels) {}
        StereoIterator& operator++() {
            curSample += channels;
            return *this;
        }
        StereoIterator operator++(int) { StereoIterator retval = *this; ++(*this); return retval; }
        bool operator==(StereoIterator other) const { return curSample == other.curSample; }
        bool operator!=(StereoIterator other) const { return !(*this == other); }
        reference operator*() const { return std::pair<std::reference_wrapper<short>, std::reference_wrapper<short>>(*curSample, *(curSample + 1)); }
    };

    SampleBuffer copy() const {
        SampleBuffer outbuf(samples->getSampleCount(), samples->getChannels());
        samples->copyTo(outbuf.samples);
        return outbuf;
    }
    void mixInto(SampleBuffer& target) const {
        std::transform(target.samples->begin(), target.samples->end(), samples->begin(), target.samples->begin(), [](short left, short right)
        {
            return std::clamp(static_cast<int>(left) + static_cast<int>(right), SHRT_MIN, SHRT_MAX);
        });
    }

    void applyStereoGain(float gainFrontLeft, float gainFrontRight);
    void applyMonoGain(float gain);
    ///Has checks for 0/1 gain to not actually do processing
    void applyGain(float gain) {
        if (gain == 0.f) return setToNull();
        if (gain == 1.f) return;
        return applyMonoGain(gain);
    }

    void setToNull() {
        std::fill(samples->begin(), samples->end(), 0);
    }

    const short* getSamples() const {
        return samples->getSamples();
    }
    short* getSamples() {
        return samples->getSamples();
    }
    uint8_t getChannels() const {
        return samples->getChannels();
    }
    uint32_t getSampleCount() const {
        return samples->getSampleCount();
    }
    struct SIterHelper {
        StereoIterator begIt;
        StereoIterator endIt;
        StereoIterator begin() { return begIt; }
        StereoIterator end() { return endIt; }
    };
    SIterHelper iterateStereo() {
        return SIterHelper{
            StereoIterator(getSamples(), getChannels()),
            StereoIterator(getSamples() + getSampleCount() + getChannels(), getChannels())
        };
    }
    short* begin() { return samples->begin(); }
    short* end() { return samples->end(); }
    short& operator[](size_t offset) { return *(samples->begin() + offset); }

};

