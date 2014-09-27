#ifndef CLUNK_HRTF_H
#define	CLUNK_HRTF_H

#include <clunk/buffer.h>
#include <clunk/export_clunk.h>
#include <clunk/mdct_context.h>
#include <clunk/types.h>
#include <clunk/v3.h>

namespace clunk {

//window function used in ogg/vorbis
template<int N, typename T>
struct vorbis_window_func : public clunk::window_func_base<N, T> {
	inline T operator()(int x) const {
		T s = sin(T(M_PI) * (x + 0.5f) / N);
		return sin(T(M_PI_2) * s * s); 
	}
};

template<int N, typename T>
struct sin_window_func : public clunk::window_func_base<N, T> {
	inline T operator()(int x) const {
		return sin(T(M_PI) * x / N);
	}
};

class CLUNKAPI Hrtf {
public: 
	enum { WINDOW_BITS = 9 };

private: 
	typedef mdct_context<WINDOW_BITS, vorbis_window_func, float> mdct_type;

public:
	enum { WINDOW_SIZE = mdct_type::N };

	Hrtf();

	void process(unsigned sample_rate, clunk::Buffer &dst_buf, unsigned dst_ch,
			const clunk::Buffer &src_buf, unsigned src_ch,
			const v3f &position, float fx_volume);

	void skip(unsigned samples);

private:
	static void idt_iit(const v3f &position, float &idt_offset, float &angle_gr, float &left_to_right_amp);
	typedef const float (*kemar_ptr)[2][257][2];
	void get_kemar_data(kemar_ptr & kemar_data, int & samples, const v3f &delta_position);

	//generate hrtf response for channel idx (0 left), in result.
	void hrtf(int window, const unsigned channel_idx, clunk::Buffer &result, const s16 *src, int src_ch, int src_n, int idt_offset, const kemar_ptr& kemar_data, int kemar_idx, float freq_decay);

private:
	clunk::Buffer sample3d[2];
	float overlap_data[2][WINDOW_SIZE / 2];
};

}

#endif
