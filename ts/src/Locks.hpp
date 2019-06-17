#pragma once

#include <Windows.h>
/*
could also use std::shared_lock and std::unique_lock from
#include <shared_mutex>
#include <mutex>
This would make it easier to switch from our lock types to std::mutex types and keep one pair of functions to lock stuff...
But i already created this new one so.... nah

*/

template<class LOCK>
class LockGuard_exclusive {
    LOCK* m_lock;
    bool isLocked;
public:
    explicit LockGuard_exclusive(LOCK& _cs) : m_lock(&_cs) { m_lock->lockExclusive(); isLocked = true; }
    ~LockGuard_exclusive() { if (isLocked)  m_lock->unlockExclusive(); }
    void unlock() {
        if (isLocked) {
            m_lock->unlockExclusive();
            isLocked = false;
        }
    }
};

template<class LOCK>
class LockGuard_shared {
    LOCK* m_lock;
    bool isLocked;
public:
    explicit LockGuard_shared(LOCK& _cs) : m_lock(&_cs) { m_lock->lockShared(); isLocked = true; }
    ~LockGuard_shared() { if (isLocked) m_lock->unlockShared(); }
    void unlock() {
        if (isLocked) {
            m_lock->unlockShared();
            isLocked = false;
        }
    }

};

class ReadWriteLock {  //Consider SRW locks if you are reading at least 4:1 vs writing
    SRWLOCK m_lock{ SRWLOCK_INIT };
public:
    void lockExclusive() {
        AcquireSRWLockExclusive(&m_lock);
    }
    void lockShared() {
        AcquireSRWLockShared(&m_lock);
    }
    void unlockExclusive() {
        ReleaseSRWLockExclusive(&m_lock);
    }
    void unlockShared() {
        ReleaseSRWLockShared(&m_lock);
    }
};

class CriticalSectionLock {  //Consider SRW locks if you are reading at least 4:1 vs writing
    CRITICAL_SECTION m_lock;
public:
    CriticalSectionLock() { InitializeCriticalSection(&m_lock); }
    ~CriticalSectionLock() {
        DeleteCriticalSection(&m_lock);
    }
    void lockExclusive() {
        EnterCriticalSection(&m_lock);
    }
    void lockShared() {
        EnterCriticalSection(&m_lock);
    }
    void unlockExclusive() {
        LeaveCriticalSection(&m_lock);
    }
    void unlockShared() {
        LeaveCriticalSection(&m_lock);
    }
};
