#include "ProfilerTracy.hpp"
#if ENABLE_TRACY_PROFILING
#include <TracyClient.cpp>
#endif

ProfilerTracy GProfilerTracy{};


//class ScopeInfoTracy final : public ScopeInfo {
//public:
//    tracy::ScopedZone zone;
//};

#if ENABLE_TRACY_PROFILING
class RunningScopeTracy final : public RunningScope {
public:
    RunningScopeTracy(const ProfilerScope& info): zone(reinterpret_cast<const tracy::SourceLocationData*>(&info.data), 5) {}

    virtual ~RunningScopeTracy() {
        
    }
    virtual void setName(std::string_view name) {
        zone.Name(name.data(), name.length());
    }
    virtual void setDescription(std::string_view descr) {
        zone.Text(descr.data(), descr.length());
    }

    tracy::ScopedZone zone;
};
#endif

std::unique_ptr<RunningScope> ProfilerTracy::enterScope(const ProfilerScope& info) const {
    if (!tracy::s_token.ptr) {
        tracy::rpmalloc_thread_initialize();
        tracy::s_token_detail = tracy::moodycamel::ProducerToken(tracy::s_queue);
        tracy::s_token = tracy::ProducerWrapper{ tracy::s_queue.get_explicit_producer(tracy::s_token_detail) };
    }

#if ENABLE_TRACY_PROFILING
    return std::make_unique<RunningScopeTracy>(info);
#else
    return nullptr;
#endif
}

void ProfilerTracy::addLog(std::string_view message) {
    if (message.empty()) return;
#if ENABLE_TRACY_PROFILING
    tracy::Profiler::Message(message.data(), message.length());
#endif
}

void ProfilerTracy::setCounter(std::string_view name, float val) {
#if ENABLE_TRACY_PROFILING
    tracy::Profiler::PlotData(name.data(), val);
#endif
}

bool ProfilerTracy::isConnected() {
#if ENABLE_TRACY_PROFILING
    return tracy::s_profiler.IsConnected();
#endif
}
