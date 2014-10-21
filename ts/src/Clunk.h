#pragma once

#include <clunk/hrtf.h>
#include <deque>

class Clunk
{
public:


	void process(short * samples, int channels, int sampleCount, TS3_VECTOR pos, float direction)
	{
		float x = pos.x;
		float y = pos.y;
		float z = pos.z;
		

		//| cos θ - sin θ   0 | | x | | x cos θ - y sin θ | | x'|
		//| sin θ    cos θ   0 | | y | = | x sin θ + y cos θ | = | y'|
		//| 0       0      1 | | z | | z | | z'|

		float rad = direction / 180.0f * (float) M_PI;

		float x_ = x * cos(rad) - y * sin(rad);
		float y_ = x * sin(rad) + y * cos(rad);
		float z_ = z;	

		for (int q = 0; q < channels * sampleCount; q++)
		{
			input_buffer.push_back(samples[q]);			
		}

		if (input_buffer.size() > clunk::Hrtf::WINDOW_SIZE * (unsigned int) channels * 2)
		{

			const int to_process = (int) input_buffer.size();

			clunk::Buffer src(to_process * sizeof(short));
			short* src_s = new short[input_buffer.size()];

			for (int q = 0; q < to_process; q++)
			{
				src_s[q] = input_buffer.at(0);
				input_buffer.pop_front();
			}
			src.set_data(src_s, to_process * sizeof(short), true);


			int output_size = to_process;
			output_size -= clunk::Hrtf::WINDOW_SIZE * channels * 2;


			short* dst_s = new short[output_size];
			memset(dst_s, 0, output_size * sizeof(short));
			clunk::Buffer dst(output_size * sizeof(short));
			dst.set_data(dst_s, output_size * sizeof(short), true);

			int processed = hrft.process(SAMPLE_RATE, dst, channels, src, channels, clunk::v3f(x_, y_, z_), 1.0f);

			for (int q = processed * channels; q < to_process; q++)
			{
				input_buffer.push_back(src_s[q]);
			}

			for (int q = 0; q < output_size; q++)
			{
				output_buffer.push_back(dst_s[q]);
			}
		}

		int q = 0;
		while (q < sampleCount * channels)
		{
			if (output_buffer.size() > 0)
			{
				samples[q] = output_buffer.at(0);	
				output_buffer.pop_front();
			}
			else
			{
				samples[q] = 0;
			}
			q++;
		}
	}
	
	
private:
	clunk::Hrtf hrft;
	std::deque<short> input_buffer;
	std::deque<short> output_buffer;	
};