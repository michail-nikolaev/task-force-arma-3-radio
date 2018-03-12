#pragma once

#include <Windows.h>
//#CStandart On C++17 use http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2016/p0091r2.html for lock guards
/*
This will make
using LockGuard_shared = LockGuard_shared<ReadWriteLock>;
using LockGuard_exclusive = LockGuard_exclusive<ReadWriteLock>;
not needed anymore

could also use std::shared_lock and std::unique_lock from
#include <shared_mutex>
#include <mutex>
This would make it easier to switch from our lock types to std::mutex types and keep one pair of functions to lock stuff...
But i already created this new one so.... nah

*/

template<class LOCK>
class LockGuard_exclusive;

template<class LOCK>
class LockGuard_shared;

class ReadWriteLock {  //Consider SRW locks if you are reading at least 4:1 vs writing
    friend class LockGuard_exclusive<ReadWriteLock>;
    friend class LockGuard_shared<ReadWriteLock>;
    SRWLOCK m_lock{ SRWLOCK_INIT };
};

class CriticalSectionLock {  //Consider SRW locks if you are reading at least 4:1 vs writing
    friend class LockGuard_exclusive<CriticalSectionLock>;
    friend class LockGuard_shared<CriticalSectionLock>;
    CRITICAL_SECTION m_lock;
public:
    CriticalSectionLock() { InitializeCriticalSection(&m_lock); }
    ~CriticalSectionLock() {
        DeleteCriticalSection(&m_lock);
    }
};

template<>
class LockGuard_exclusive<CriticalSectionLock> {
    CriticalSectionLock* m_lock;
    bool isLocked;
public:
    explicit LockGuard_exclusive(CriticalSectionLock* _cs) : m_lock(_cs) { EnterCriticalSection(&m_lock->m_lock); isLocked = true; }
    ~LockGuard_exclusive() { if (isLocked) LeaveCriticalSection(&m_lock->m_lock); }
    void unlock() {
        if (isLocked) {
            LeaveCriticalSection(&m_lock->m_lock);
            isLocked = false;
        };
    }
};

template<>
class LockGuard_exclusive<ReadWriteLock> {
    ReadWriteLock* m_lock;
    bool isLocked;
public:
    explicit LockGuard_exclusive(ReadWriteLock* _cs) : m_lock(_cs) { AcquireSRWLockExclusive(&m_lock->m_lock); isLocked = true; }
    ~LockGuard_exclusive() { if (isLocked) ReleaseSRWLockExclusive(&m_lock->m_lock); }
    void unlock() {
        if (isLocked) {
            ReleaseSRWLockExclusive(&m_lock->m_lock);
            isLocked = false;
        };
    }
};

template<>
class LockGuard_shared<CriticalSectionLock> {   //There is no "shared" CriticalSection. So we do the same as exclusive
    CriticalSectionLock* m_lock;
    bool isLocked;
public:
    explicit LockGuard_shared(CriticalSectionLock* _cs) : m_lock(_cs) { EnterCriticalSection(&m_lock->m_lock); isLocked = true; }
    ~LockGuard_shared() { if (isLocked) LeaveCriticalSection(&m_lock->m_lock); }
    void unlock() {
        if (isLocked) {
            LeaveCriticalSection(&m_lock->m_lock);
            isLocked = false;
        };
    }
};

template<>
class LockGuard_shared<ReadWriteLock> {
    ReadWriteLock* m_lock;
    bool isLocked;
public:
    explicit LockGuard_shared(ReadWriteLock* _cs) : m_lock(_cs) { AcquireSRWLockShared(&m_lock->m_lock); isLocked = true; }
    ~LockGuard_shared() { if (isLocked) ReleaseSRWLockShared(&m_lock->m_lock); }
    void unlock() {
        if (isLocked) {
            ReleaseSRWLockShared(&m_lock->m_lock);
            isLocked = false;
        };
    }
};
