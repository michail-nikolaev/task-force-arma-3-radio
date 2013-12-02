#include "DspFilters\Butterworth.h"
#include "DspFilters\RBJ.h"
#include <math.h>
#define SAMPLE_RATE 48000


#define PI_2     1.57079632679489661923f
#define DELAY_SAMPLES (SAMPLE_RATE / 20)

class RadioEffect
{
public:

	RadioEffect()
	{
		floatsSample[0] = new float[1];
	}

	virtual void reset()
	{
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
			*floatsSample[0]= buffer[q];
			filter.process<float>(1, floatsSample);			
			buffer[q] = *floatsSample[0];
		}
	}

	virtual void setErrorLeveL(float errorLevel) = 0;
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

	virtual void reset()
	{
		RadioEffect::reset();
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


class SimpleRadioEffect: public RadioEffect
{
public:
	virtual void reset()
	{		
		RadioEffect::reset();
		filterSpeakerHP.reset();
		filterSpeakerLP.reset();
		phase = 0;
		errorLevel = 0;	
	}

	virtual void process(float* buffer, int samplesNumber)
	{
		for (int q = 0; q < samplesNumber; q++) buffer[q] = delay(buffer[q]);
		for (int q = 0; q < samplesNumber; q++) buffer[q] = ringmodulation(buffer[q], 1.0f - 0.6f * (1.0f - errorLevel));
		for (int q = 0; q < samplesNumber; q++) buffer[q] = foldback(buffer[q], 0.5f * (1.0f - errorLevel));		

		processFilter(filterSpeakerHP, buffer, samplesNumber);
		processFilter(filterSpeakerLP, buffer, samplesNumber);

		for (int q = 0; q < samplesNumber; q++) buffer[q] *= 30;
	}

	virtual void setErrorLeveL(float errorLevel)
	{		
		this->errorLevel = (float) Spline_evaluation(errorLevel);	
	}


protected:

	double Spline_evaluation(double x_in)
	{
		double t [] = {0.0000000000000000E+00, 0.0000000000000000E+00, 0.0000000000000000E+00, 0.0000000000000000E+00, 1.0000000000000000E+00, 1.0000000000000000E+00, 1.0000000000000000E+00, 1.0000000000000000E+00};
		double coeff [] = {3.8741258741258715E-02, 7.0793317793317823E-01, 9.6570318570318514E-01, 9.9853146853146868E-01, 0.0000000000000000E+00, 0.0000000000000000E+00, 0.0000000000000000E+00, 0.0000000000000000E+00};
		int n = 8;
		int k = 3;
		double h [] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
		double hh [] = {0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
		int i, j, li, lj, ll;
		double f, temp;

		int k1 = k+1;
		int l = k1;
		int l1 = l+1;
		while ((x_in < t[l-1]) && (l1 != (k1+1)))
		{
			l1 = l;
			l = l-1;
		}
		while ((x_in >= t[l1-1]) && (l != (n-k1)))
		{
			l = l1;
			l1 += 1;
		}
		h[0] = 1.0;
		for (j = 1; j < k+1; j++)
		{
			for (i = 0; i < j; i++)
			{
				hh[i] = h[i];
			}
			h[0] = 0.0;
			for (i = 0; i < j; i++)
			{
				li = l+i;
				lj = li-j;
				if (t[li] != t[lj])
				{
					f = hh[i] / (t[li] - t[lj]);
					h[i] = h[i] + f * (t[li] - x_in);
					h[i+1] = f * (x_in - t[lj]);
				}
				else
				{
					h[i+1] = 0.0;
				}
			}
		}
		temp = 0.0;
		ll = l - k1;
		for (j = 0; j < k1; j++)
		{
			ll = ll + 1;
			temp = temp + coeff[ll-1] * h[j];
		}

		return temp;
	}	float foldback(float in, float threshold)
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

	virtual void reset()
	{
		filterMicHP.reset();
		filterMicLP.reset();
		SimpleRadioEffect::reset();
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


