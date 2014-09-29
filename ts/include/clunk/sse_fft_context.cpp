#include <stdlib.h>
#include <stdio.h>
#include <new>
#include <clunk/fft_context.h>
#include <clunk/sse_fft_context.h>

using namespace clunk;

void * aligned_allocator::allocate(size_t size, size_t alignment) {
	void * ptr;
#ifdef _WINDOWS
	if ((ptr = _aligned_malloc(size, alignment)) == NULL)
		throw std::bad_alloc();
#else
	if (posix_memalign(&ptr, alignment, size) != 0)
		throw std::bad_alloc();
#endif
	return ptr;
}

void aligned_allocator::deallocate(void *ptr) {
#ifdef _WINDOWS
	_aligned_free(ptr);
#else
	free(ptr);
#endif
}
