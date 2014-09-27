#ifndef CLUNK_STATIC_ASSERT_H__
#define CLUNK_STATIC_ASSERT_H__

#define CLUNK_JOIN(x, y) CLUNK_JOIN_AGAIN(x, y)
#define CLUNK_JOIN_AGAIN(x, y) x ## y

#define clunk_static_assert(e) \
typedef char CLUNK_JOIN(assertion_failed_at_line_, __LINE__) [(e) ? 1 : -1]

#endif

