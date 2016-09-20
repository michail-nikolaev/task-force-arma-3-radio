#pragma once
#include "DspFilters\Butterworth.h"
#include "DspFilters\RBJ.h"
#include <math.h>
#include <Windows.h>
#define SAMPLE_RATE 48000


#define PI_2     1.57079632679489661923f
#define DELAY_SAMPLES (SAMPLE_RATE / 20)

class RadioEffect
{
public:

	RadioEffect()
	{
		floatsSample[0] = new float[1];
		for (int q = 0; q < DELAY_SAMPLES; q++) delayLine[q] = 0.0f;
		delayPosition = 0;
	}
	
	virtual void process(float* buffer, int samplesNumber) = 0;

	float delay(float input)
	{
		delayLine[delayPosition] = input;
		int position = (delayPosition + 1) % DELAY_SAMPLES;
		float value = delayLine[position];
		delayPosition++;
		if (delayPosition >= DELAY_SAMPLES) delayPosition = 0;
		return value;
	}

	template<class T>
	void processFilter(T& filter, float* buffer, int samplesNumber)
	{
		for (int q = 0; q < samplesNumber; q++)
		{
			*floatsSample[0] = buffer[q];
			filter.process<float>(1, floatsSample);
			buffer[q] = *floatsSample[0];
		}
	}

	virtual void setErrorLeveL(float errorLevel) = 0;

	~RadioEffect()
	{
		delete floatsSample[0];
	}
private:
	float* floatsSample[1];
	float delayLine[DELAY_SAMPLES];
	int delayPosition;
};

class UnderWaterRadioEffect: public RadioEffect
{
public:
	UnderWaterRadioEffect()
	{
		filterDD.setup(2, 48000, 1000, 400);
		errorLevel = 0.0f;
		errorLessThan = 0;
	}

	virtual void process(float* buffer, int samplesNumber)
	{
		for (int q = 0; q < samplesNumber; q++)
		{
			if (rand() < errorLessThan)
			{
				buffer[q] = 0.0f;
			}
		}		
		processFilter(filterDD, buffer, samplesNumber);
		for (int q = 0; q < samplesNumber; q++) buffer[q] *= 30;
	}	

	virtual void setErrorLeveL(float errorLevel)
	{
		this->errorLevel = errorLevel;
		errorLessThan = (int) (RAND_MAX * errorLevel);
	}

private:
	Dsp::SimpleFilter<Dsp::Butterworth::BandPass<2>, 1> filterDD;
	float errorLevel;
	int errorLessThan;
};


class SimpleRadioEffect: public RadioEffect
{
public:
	SimpleRadioEffect()
	{						
		phase = 0;
		errorLevel = 0;	
	}

	virtual void process(float* buffer, int samplesNumber)
	{				
		double acc = 0.0;
		for (int q = 0; q < samplesNumber; q++) acc += fabs(buffer[q]);
		double avg = acc / samplesNumber;
		double base = 0.005;

		double x = avg / base;


		for (int q = 0; q < samplesNumber; q++) buffer[q] = delay(buffer[q]);
		for (int q = 0; q < samplesNumber; q++) buffer[q] = ringmodulation(buffer[q], errorLevel);
		for (int q = 0; q < samplesNumber; q++) buffer[q] = foldback(buffer[q], (float)(0.3f * (1.0f - errorLevel) * x));

		processFilter(filterSpeakerHP, buffer, samplesNumber);
		processFilter(filterSpeakerLP, buffer, samplesNumber);

		for (int q = 0; q < samplesNumber; q++) buffer[q] = buffer[q] *= 30;
	}



	virtual void setErrorLeveL(float errorLevel)
	{		
		this->errorLevel = calcErrorLevel(errorLevel);
	}


protected:
	
	
	/*	
	0.0	0.0
	0.1	0.150000006
	0.2	0.300000012
	0.3	0.600000024
	0.4	0.899999976
	0.5	0.950000048
	0.6	0.960000038
	0.7	0.970000029
	0.8	0.980000019
	0.9	0.995000005
	1.0	0.997799993*/
	float calcErrorLevel(float errorLevel)
	{
		double levels[] = { 0.0, 0.150000006, 0.300000012, 0.600000024, 0.899999976, 0.950000048, 0.960000038, 0.970000029, 0.980000019, 0.995000005, 0.997799993, 0.998799993, 0.999 };

		int part = (int)(errorLevel * 10.0);
		double from = levels[part];
		double to = levels[part + 1];

		double result = from + (from - to) * (errorLevel - part / 10.0);
		return (float)result;
	}


	float foldback(float in, float threshold)
	{
		if (threshold < 0.00001) return 0.0f;
		if (in>threshold || in<-threshold)
		{
			in = fabs(fabs(fmod(in - threshold, threshold*4)) - threshold*2) - threshold;
		}
		return in;
	}

	float ringmodulation(float in, float mix) 
	{
		float multiple = in * sin(phase * PI_2);
		phase += (90.0f * 1.0f / (float) SAMPLE_RATE);
		if (phase > 1.0f) phase = 0.0f;
		return in * (1.0f - mix) + multiple * mix;
	}


	float errorLevel;
	float phase;

	Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> filterSpeakerHP;	
	Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> filterSpeakerLP;
};

class LongRangeRadioffect: public SimpleRadioEffect
{
public:
	LongRangeRadioffect()
	{		
		filterSpeakerHP.setup(SAMPLE_RATE, 520, 0.97);
		filterSpeakerLP.setup(SAMPLE_RATE, 1300, 1.0);
	}		
};


class PersonalRadioEffect: public SimpleRadioEffect
{
public:
	PersonalRadioEffect()
	{
		filterSpeakerHP.setup(SAMPLE_RATE, 520, 0.97);
		filterSpeakerLP.setup(SAMPLE_RATE, 4300, 2.0);

		filterMicHP.setup(SAMPLE_RATE, 900, 0.85);
		filterMicLP.setup(SAMPLE_RATE, 3000, 2.0);		
	}	

	virtual void process(float* buffer, int samplesNumber)
	{
		processFilter(filterMicHP, buffer, samplesNumber);
		processFilter(filterMicLP, buffer, samplesNumber);
		SimpleRadioEffect::process(buffer, samplesNumber);
	}

private:
	Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> filterMicHP;
	Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> filterMicLP;
};
extern CRITICAL_SECTION serverDataCriticalSection;
template<class T>
void processRadioEffect(short* samples, int channels, int sampleCount, float gain, T* effect, int stereoMode) {
	int startChannel = 0;
	int endChannel = channels;
	if (stereoMode == 1) {
		startChannel = 0;
		endChannel = 1;
		gain *= 1.5f;
	} else if (stereoMode == 2) {
		startChannel = 1;
		endChannel = 2;
		gain *= 1.5f;
	}
	float* buffer = new float[sampleCount];
	for (int i = 0; i < sampleCount * channels; i += channels) {
		// prepare mono for radio						
		long long no3D = 0;
		for (int j = 0; j < channels; j++) {
			no3D += samples[i + j];
		}

		short to_process = (short) (no3D / channels);
		buffer[i / channels] = ((float) to_process / (float) SHRT_MAX) * gain;
	}
	EnterCriticalSection(&serverDataCriticalSection);
	effect->process(buffer, sampleCount);
	LeaveCriticalSection(&serverDataCriticalSection);
	for (int i = 0; i < sampleCount * channels; i += channels) {
		// put mixed output to stream			
		for (int j = 0; j < channels; j++) samples[i + j] = 0;

		for (int j = startChannel; j < endChannel; j++) {
			float sample = buffer[i / channels];
			short newValue;
			if (sample > 1.0) newValue = SHRT_MAX;
			else if (sample < -1.0) newValue = SHRT_MIN;
			else newValue = (short) (sample * (SHRT_MAX - 1));
			samples[i + j] = newValue;
		}
	}
	delete[] buffer;
}
