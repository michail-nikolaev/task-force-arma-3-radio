#include <clunk/hrtf.h>
#include <clunk/buffer.h>
#include <clunk/clunk_ex.h>
#include <stddef.h>

#include "kemar.h"

#if defined _MSC_VER || __APPLE__ || __FreeBSD__
#	define pow10f(x) powf(10.0f, (x))
#	define log2f(x) (logf(x) / M_LN2)
#endif

namespace clunk
{

clunk_static_assert(Hrtf::WINDOW_BITS > 2);

Hrtf::Hrtf()
{
	for(int i = 0; i < 2; ++i) {
		for(int j = 0; j < WINDOW_SIZE / 2; ++j) {
			overlap_data[i][j] = 0;
		}
	}
}

void Hrtf::idt_iit(const v3f &position, float &idt_offset, float &angle_gr, float &left_to_right_amp) {
	float head_r = 0.093f;

	float angle = (float)(M_PI_2 - atan2f(position.y, position.x));

	angle_gr = angle * 180 / float(M_PI);
	while (angle_gr < 0)
		angle_gr += 360;

	//LOG_DEBUG(("relative position = (%g,%g,%g), angle = %g (%g)", position.x, position.y, position.z, angle, angle_gr));

	float idt_angle = fmodf(angle, 2 * (float)M_PI);

	if (idt_angle < 0)
		idt_angle += 2 * (float)M_PI;
	if (idt_angle >= float(M_PI_2) && idt_angle < (float)M_PI) {
		idt_angle = float(M_PI) - idt_angle;
	} else if (idt_angle >= float(M_PI) && idt_angle < 3 * float(M_PI_2)) {
		idt_angle = (float)M_PI - idt_angle;
	} else if (idt_angle >= 3 * (float)M_PI_2) {
		idt_angle -= (float)M_PI * 2;
	}

	//LOG_DEBUG(("idt_angle = %g (%d)", idt_angle, (int)(idt_angle * 180 / M_PI)));
	idt_offset = - head_r * (idt_angle + sin(idt_angle)) / 344;
	left_to_right_amp = pow10f(-sin(idt_angle));
	//LOG_DEBUG(("idt_offset %g, left_to_right_amp: %g", idt_offset, left_to_right_amp));
}

void Hrtf::get_kemar_data(kemar_ptr & kemar_data, int & elev_n, const v3f &pos) {
	
	kemar_data = 0;
	elev_n = 0;
	if (pos.is0())
		return;

#ifdef _WINDOWS
       float len = (float)_hypot(pos.x, pos.y);
#else
       float len = (float)hypot(pos.x, pos.y);
#endif

	int elev_gr = (int)(180 * atan2f(pos.z, len) / (float)M_PI);
	//LOG_DEBUG(("elev = %d (%g %g %g)", elev_gr, pos.x, pos.y, pos.z));

	for(size_t i = 0; i < KemarElevationCount; ++i)
	{
		const kemar_elevation_data &elev = ::kemar_data[i];
		if (elev_gr < elev.elevation + KemarElevationStep / 2)
		{
			//LOG_DEBUG(("used elevation %d", elev.elevation)); 
			kemar_data = elev.data;
			elev_n = elev.samples;
			break;
		}
	}
}

void Hrtf::process(
	unsigned sample_rate, clunk::Buffer &dst_buf, unsigned dst_ch,
	const clunk::Buffer &src_buf, unsigned src_ch,
	const v3f &delta_position, float fx_volume)
{
	s16 * const dst = static_cast<s16*>(dst_buf.get_ptr());
	const unsigned dst_n = (unsigned)dst_buf.get_size() / dst_ch / 2;

	const s16 * const src = static_cast<const s16 *>(src_buf.get_ptr());
	const unsigned src_n = (unsigned)src_buf.get_size() / src_ch / 2;
	assert(dst_n <= src_n);

	kemar_ptr kemar_data;
	int angles;
	get_kemar_data(kemar_data, angles, delta_position);

	if (delta_position.is0() || kemar_data == NULL) {
		//2d stereo sound!
		if (src_ch == dst_ch) {
			memcpy(dst_buf.get_ptr(), src_buf.get_ptr(), dst_buf.get_size());
			return;
		}
		else
			throw_ex(("unsupported sample conversion"));
		return;
	}
	
	//LOG_DEBUG(("data: %p, angles: %d", (void *) kemar_data, angles));

	float t_idt, angle_gr, left_to_right_amp;
	idt_iit(delta_position, t_idt, angle_gr, left_to_right_amp);

	const int kemar_sector_size = 360 / angles;
	const int kemar_idx_right = ((int)angle_gr + kemar_sector_size / 2) / kemar_sector_size;
	const int kemar_idx_left = ((360 - (int)angle_gr + kemar_sector_size / 2) / kemar_sector_size) % angles;
	//LOG_DEBUG(("%g (of %d)-> left: %d, right: %d", angle_gr, angles, kemar_idx_left, kemar_idx_right));
	
	int idt_offset = (int)(t_idt * sample_rate);

	int window = 0;
	while(sample3d[0].get_size() < dst_n * 2 || sample3d[1].get_size() < dst_n * 2) {
		hrtf(window, 0, sample3d[0], src, src_ch, src_n, idt_offset, kemar_data, kemar_idx_left, left_to_right_amp > 1? 1: 1 / left_to_right_amp);
		hrtf(window, 1, sample3d[1], src, src_ch, src_n, idt_offset, kemar_data, kemar_idx_right, left_to_right_amp > 1? left_to_right_amp: 1);
		++window;
	}
	assert(sample3d[0].get_size() >= dst_n * 2 && sample3d[1].get_size() >= dst_n * 2);
	
	//LOG_DEBUG(("angle: %g", angle_gr));
	//LOG_DEBUG(("idt offset %d samples", idt_offset));
	s16 * src_3d[2] = { static_cast<s16 *>(sample3d[0].get_ptr()), static_cast<s16 *>(sample3d[1].get_ptr()) };
	
	//LOG_DEBUG(("size1: %u, %u, needed: %u\n%s", (unsigned)sample3d[0].get_size(), (unsigned)sample3d[1].get_size(), dst_n, sample3d[0].dump().c_str()));
	
	for(unsigned i = 0; i < dst_n; ++i) {
		for(unsigned c = 0; c < dst_ch; ++c) {
			dst[i * dst_ch + c] = src_3d[c][i];
		}
	}
	skip(dst_n);
}

void Hrtf::skip(unsigned samples) {
	for(int i = 0; i < 2; ++i) {
		Buffer & buf = sample3d[i];
		buf.pop(samples * 2);
	}
}

template <typename T> inline T clunk_min(T a, T b) {
	return a < b ? a : b;
}

template <typename T> inline T clunk_max(T a, T b) {
	return a > b ? a : b;
}

void Hrtf::hrtf(int window, const unsigned channel_idx, clunk::Buffer &result, const s16 *src, int src_ch, int src_n, int idt_offset, const kemar_ptr& kemar_data, int kemar_idx, float freq_decay) {
	assert(channel_idx < 2);

	size_t result_start = result.get_size();
	result.reserve(WINDOW_SIZE);

	//LOG_DEBUG(("channel %d: window %d: adding %d, buffer size: %u, decay: %g", channel_idx, window, WINDOW_SIZE, (unsigned)result.get_size(), freq_decay));

	mdct_type mdct __attribute__ ((aligned (16)));

	if (channel_idx <= 1) {
		bool left = channel_idx == 0;
		if (!left && idt_offset > 0) {
			idt_offset = 0;
		} else if (left && idt_offset < 0) {
			idt_offset = 0;
		}
		if (idt_offset < 0)
			idt_offset = - idt_offset;
	} else 
		idt_offset = 0;

	assert(clunk_min(0, idt_offset) + (window * WINDOW_SIZE / 2 + 0) >= 0);
	assert(clunk_max(0, idt_offset) + (window * WINDOW_SIZE / 2 + WINDOW_SIZE) <= src_n);

	for(int i = 0; i < WINDOW_SIZE; ++i) {
		//-1 0 1 2 3
		int p = idt_offset + (window * WINDOW_SIZE / 2 + i); //overlapping half
		assert(p >= 0 && p < src_n);
		//printf("%d of %d, ", p, src_n);
		int v = src[p * src_ch];
		mdct.data[i] = v / 32768.0f;
		//fprintf(stderr, "%g ", mdct.data[i]);
	}
	
	mdct.apply_window();
	mdct.mdct();
	{
		for(size_t i = 0; i < mdct_type::M; ++i)
		{
			const int kemar_sample = i * 257 / mdct_type::M;
			std::complex<float> fir(kemar_data[kemar_idx][0][kemar_sample][0], kemar_data[kemar_idx][0][kemar_sample][1]);
			mdct.data[i] *= std::abs(fir);
		}
	}

	//LOG_DEBUG(("kemar angle index: %d\n", kemar_idx));
	assert(freq_decay >= 1);
	
	mdct.imdct();
	mdct.apply_window();

	s16 *dst = static_cast<s16 *>(static_cast<void *>((static_cast<u8 *>(result.get_ptr()) + result_start)));

	float max_v = 1.0f, min_v = -1.0f;
	
	for(int i = 0; i < WINDOW_SIZE / 2; ++i) {
		float v = (mdct.data[i] + overlap_data[channel_idx][i]);

		if (v < min_v)
			min_v = v;
		else if (v > max_v)
			max_v = v;
	}

	{
		//stupid msvc
		int i;
		for(i = 0; i < WINDOW_SIZE / 2; ++i) {
			float v = ((mdct.data[i] + overlap_data[channel_idx][i]) - min_v) / (max_v - min_v) * 2 - 1;
			
			if (v < -1) {
				LOG_DEBUG(("clipping %f [%f-%f]", v, min_v, max_v));
				v = -1;
			} else if (v > 1) {
				LOG_DEBUG(("clipping %f [%f-%f]", v, min_v, max_v));
				v = 1;
			}
			*dst++ = (int)(v * 32767);
		}
		for(; i < WINDOW_SIZE; ++i) {
			overlap_data[channel_idx][i - WINDOW_SIZE / 2] = mdct.data[i];
		}
	}
}

	
}
