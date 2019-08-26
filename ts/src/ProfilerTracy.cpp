#include "ProfilerTracy.hpp"
#include <TracyClient.cpp>

ProfilerTracy GProfilerTracy{};


//class ScopeInfoTracy final : public ScopeInfo {
//public:
//    tracy::ScopedZone zone;
//};

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


std::unique_ptr<RunningScope> ProfilerTracy::enterScope(const ProfilerScope& info) const {
    return std::make_unique<RunningScopeTracy>(info);
}

void ProfilerTracy::addLog(std::string_view message) {
    if (message.empty()) return;
    tracy::Profiler::Message(message.data(), message.length());
}

void ProfilerTracy::setCounter(std::string_view name, float val) {
    tracy::Profiler::PlotData(name.data(), val);
}

bool ProfilerTracy::isConnected() {
    return tracy::s_profiler.IsConnected();
    LockableBase()
}
