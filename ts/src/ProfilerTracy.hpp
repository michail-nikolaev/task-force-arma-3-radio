#pragma once
#include <string_view>
#include <memory>
#define TRACY_ENABLE
#define TRACY_ON_DEMAND
#include <Tracy.hpp>

struct SourceLocationData
{
    const char* name;
    const char* function;
    const char* file;
    uint32_t line;
    uint32_t color;
};


class ProfilerScope {
public:
    constexpr ProfilerScope(std::string_view scopeName, uint32_t line) : data({ scopeName.data(), scopeName.data(), nullptr, line, 0 }) {}
    constexpr ProfilerScope(const char* funcName, uint32_t line) : data({ funcName, nullptr, nullptr, line, 0 }) {}
    constexpr ProfilerScope(const char* scopeName, const char* funcName,  uint32_t line) : data({scopeName, funcName, nullptr, line, 0}) {}

    const SourceLocationData data;
};


//class ScopeInfo {
//public:
//    virtual ~ScopeInfo() = default;
//};


class RunningScope {
public:
    virtual ~RunningScope() = default;
    virtual void setName(std::string_view name) = 0;
    virtual void setDescription(std::string_view descr) = 0;
};


class ProfilerTracy {
public:

    //ScopeInfo createScope(std::string_view name, std::string_view filename,
    //    uint32_t fileline);

    std::unique_ptr<RunningScope> enterScope(const ProfilerScope& info) const;


    void addLog(std::string_view message);
    void setCounter(std::string_view name, float val);

    static bool isConnected();
};


extern ProfilerTracy GProfilerTracy;

#define __CONCAT(x,y) x##y
#define _CONCAT(x,y) __CONCAT(x,y)
#define ProfileFunction static constexpr ProfilerScope _CONCAT(prof_scopeData_, __LINE__) (__FUNCTION__, __LINE__); auto _CONCAT(prof_run_, __LINE__) = GProfilerTracy.enterScope(_CONCAT(prof_scopeData_, __LINE__));
#define ProfileFunctionN(name) static constexpr ProfilerScope _CONCAT(prof_scopeData_, __LINE__) (name, __FUNCTION__, __LINE__); auto _CONCAT(prof_run_, __LINE__) = GProfilerTracy.enterScope(_CONCAT(prof_scopeData_, __LINE__));
#define ProfileScopeN(name) static constexpr ProfilerScope _CONCAT(prof_scopeData_, __LINE__) (name, __FUNCTION__, __LINE__); auto _CONCAT(prof_run_, __LINE__) = GProfilerTracy.enterScope(_CONCAT(prof_scopeData_, __LINE__));
#define ProfilerLog(msg) GProfilerTracy.addLog(msg)
