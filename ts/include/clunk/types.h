#ifndef CLUNK_TYPES_H
#define CLUNK_TYPES_H

#include <stdint.h>

#ifndef _USE_MATH_DEFINES
#	define _USE_MATH_DEFINES
#endif

#include <math.h>

namespace clunk
{
	typedef uint8_t		u8;
	typedef uint16_t	u16;
	typedef uint32_t	u32;

	typedef int8_t		s8;
	typedef int16_t		s16;
	typedef int32_t		s32;
}

#if !(defined(__GNUC__) || defined(__GNUG__) || defined(__attribute__))
#	define __attribute__(p) /* nothing */
#endif

#endif
