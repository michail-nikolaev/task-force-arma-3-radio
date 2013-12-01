#include "DspFilters\Butterworth.h"
#include "DspFilters\RBJ.h"
#include <math.h>
#define SAMPLE_RATE 48000


#define PI_2     1.57079632679489661923f


class RadioEffect
{
public:

	RadioEffect()
	{
		floatsSample[0] = new float[1];
	}

	virtual void reset() = 0; 
	virtual void process(float* buffer, int samplesNumber) = 0;

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
private:
	float* floatsSample[1];
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

	virtual void reset()
	{
		filterDD.reset();
		errorLevel = 0.0f;
		errorLessThan = 0;
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


class LongRangeRadioffect: public RadioEffect
{
public:
	LongRangeRadioffect()
	{		
		filterSpeakerHP.setup(SAMPLE_RATE, 520, 0.97);
		filterSpeakerLP.setup(SAMPLE_RATE, 4300, 2.0);		
	}

	virtual void reset()
	{		
		filterSpeakerHP.reset();
		filterSpeakerLP.reset();
		phase = 0;
		errorLevel = 0;
	}


	float foldback(float in, float threshold)
	{
		if (threshold < 0.001) return 0.0f;
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

	virtual void process(float* buffer, int samplesNumber)
	{
		for (int q = 0; q < samplesNumber; q++) buffer[q] = ringmodulation(buffer[q], 1.0f - 0.6f * (1.0f - errorLevel));
		for (int q = 0; q < samplesNumber; q++) buffer[q] = foldback(buffer[q], 0.5f * (1.0f - errorLevel));		

		processFilter(filterSpeakerHP, buffer, samplesNumber);
		processFilter(filterSpeakerLP, buffer, samplesNumber);

		for (int q = 0; q < samplesNumber; q++) buffer[q] *= 30;
	}

	virtual void setErrorLeveL(float errorLevel)
	{
		if (errorLevel < 0.001) 
			this->errorLevel = 0;
		else 
			this->errorLevel = log10((errorLevel) * 10.0f);
	}

private:
	float errorLevel;
	float phase;

	Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> filterSpeakerHP;	
	Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> filterSpeakerLP;
};


class PersonalRadioEffect: public LongRangeRadioffect
{
public:
	PersonalRadioEffect()
	{
		filterMicHP.setup(SAMPLE_RATE, 900, 0.85);
		filterMicLP.setup(SAMPLE_RATE, 3000, 2.0);		
	}

	virtual void reset()
	{
		filterMicHP.reset();
		filterMicLP.reset();
		LongRangeRadioffect::reset();
	}

	virtual void process(float* buffer, int samplesNumber)
	{
		processFilter(filterMicHP, buffer, samplesNumber);
		processFilter(filterMicLP, buffer, samplesNumber);
		LongRangeRadioffect::process(buffer, samplesNumber);
	}

private:
	Dsp::SimpleFilter<Dsp::RBJ::HighPass, 1> filterMicHP;
	Dsp::SimpleFilter<Dsp::RBJ::LowPass, 1> filterMicLP;
};



