#ifndef FFT_CONTEXT_H__
#define FFT_CONTEXT_H__

#include <complex>
#include <assert.h>

namespace clunk {

template<int N, typename T>
class danielson_lanczos {
	typedef danielson_lanczos<N / 2, T> next_type;
	next_type _next;

	T _sin_a, _sin_a2;

public:
	danielson_lanczos()
	{
		T a = (T)(-2 * M_PI / N);
		_sin_a = sin(a);
		_sin_a2 = -sin(a / 2);
	}

	template<int SIGN>
	void apply(std::complex<T>* data) {
		_next.template apply<SIGN>(data);
		_next.template apply<SIGN>(data + N / 2);
		
		std::complex<T> wp(-2 * _sin_a2 * _sin_a2, _sin_a * SIGN), w(1, 0);

		for (unsigned i = 0; i < N / 2 ; ++i) {
			int j = i + N / 2;

			std::complex<T> temp = data[j] * w;

			data[j] = data[i] - temp;
			data[i] += temp;

			w += w * wp;
		}
	}
};

template<typename T>
struct danielson_lanczos<4, T> {
	typedef danielson_lanczos<2, T> next_type;

	template<int SIGN>
	static inline void apply(std::complex<T>* data) {
		next_type::template apply<SIGN>(data);
		next_type::template apply<SIGN>(data + 2);
		
		std::complex<T> temp = data[2];
		data[2] = data[0] - temp;
		data[0] += temp;

		temp = data[3] * std::complex<T>(0, -SIGN);
		data[3] = data[1] - temp;
		data[1] += temp;
	}
};


template<typename T>
struct danielson_lanczos<8, T> {
	typedef danielson_lanczos<4, T> next_type;
	next_type _next;

	static inline void rotate(std::complex<T>* data, int i, const std::complex<T>& w) {
		int j = i + 4;

		std::complex<T> temp = data[j] * w;

		data[j] = data[i] - temp;
		data[i] += temp;
	}

	template<int SIGN>
	inline void apply(std::complex<T>* data) {
		_next.template apply<SIGN>(data);
		_next.template apply<SIGN>(data + 4);
		
		rotate(data, 0, std::complex<T>(1, 0));
		rotate(data, 1, std::complex<T>(float(M_SQRT1_2), -float(M_SQRT1_2) * SIGN));
		rotate(data, 2, std::complex<T>(0, -1));
		rotate(data, 3, std::complex<T>(-float(M_SQRT1_2), -float(M_SQRT1_2) * SIGN));
	}
};


template<typename T>
struct danielson_lanczos<2, T> {
	template<int SIGN>
	static inline void apply(std::complex<T>* data) {
		std::complex<T> temp = data[1];

		data[1] = data[0] - temp;
		data[0] += temp;
	}
};


template<typename T>
struct danielson_lanczos<1, T> {
	template<int SIGN>
	static inline void apply(std::complex<T>*) {}
};


template<int BITS, typename T = float>
class fft_context : private danielson_lanczos<1 << BITS, T> {
public: 
	enum { N = 1 << BITS };

private:
	typedef danielson_lanczos<N, T> next_type;

public:
	typedef std::complex<T> value_type;
	value_type data[N];

	fft_context(): data() { }
	
	inline void fft() {
		scramble(data);
		next_type::template apply<1>(data);
	}

	inline void ifft() {
		scramble(data);
		next_type::template apply<-1>(data);
		for(unsigned i = 0; i < N; ++i) {
			data[i] /= N;
		}
	}
	
private:
	static inline void scramble(std::complex<T> * data) {
		int j = 0;
		for(int i = 0; i < N; ++i) {
			if (i > j) {
				std::swap(data[i], data[j]);
			}
			int m = N / 2;
			while(j >= m && m >= 2) {
				j -= m;
				m >>= 1;
			}
			j += m;
		}
	}
};

}

#ifdef CLUNK_USES_SSE
#	include "sse_fft_context.h"
#endif

#endif
