#include "antennaManager.h"
#include "task_force_radio.hpp"


AntennaManager::AntennaManager() {
    TFAR::getInstance().doDiagReport.connect([this](std::stringstream& diag) {
        diag << "AM:\n";
        for (auto& it : antennas) {
            auto [x, y, z] = it->getPos().get();
            diag << TS_INDENT << it->getID().getCreator() << " "<< it->getID().getObjID() << " (" << x << "," << y << "," << z << ") " << it->getRange() << " " << it->hasSatelliteUplink() << "\n";
        }
    });
}

AntennaConnection AntennaManager::findConnection(const Position3D& from, float maxDistanceToAnt, const Position3D& to) {
    LockGuard_shared slock(&m_lock);
    //Prefilter antennas that can be reached by sender / reach to receiver
    std::vector<std::shared_ptr<Antenna>> reachableAntennas;
    std::shared_ptr<Antenna> bestAntenna = nullptr;
    float lowestLoss = 1.f;

    //#TODO better algo...?
    const float maxDistToAntSquared = maxDistanceToAnt*maxDistanceToAnt;
    for (auto& ant : antennas) {
        if (ant->canBeReachedBy(from, maxDistToAntSquared) && ant->canReach(to))
            reachableAntennas.push_back(ant);
    }

    for (auto& ant : reachableAntennas) {
        const auto loss = ant->connectionLoss(from, maxDistanceToAnt, to);
        if (loss < lowestLoss) {
            bestAntenna = ant;
            lowestLoss = loss;
        }
            
    }
    if (bestAntenna)
        return AntennaConnection(from, bestAntenna, to, lowestLoss);
    else
        return AntennaConnection();
}

void AntennaManager::addAntenna(Antenna ant) {
    if (ant.getID().isNull()) return;
    LockGuard_shared slock(&m_lock);
    const auto found = findAntenna(ant);
    slock.unlock();
    LockGuard_exclusive lock(&m_lock);
    if (found != antennas.end()) {
        **found = std::move(ant);
        return;
    }
    antennas.push_back(std::make_shared<Antenna>(std::move(ant)));
}

void AntennaManager::removeAntenna(const NetID& antennaID) {
    if (antennaID.isNull()) return;
    LockGuard_shared slock(&m_lock);
    const auto found = findAntenna(antennaID);
    slock.unlock();
    LockGuard_exclusive lock(&m_lock);
    if (found == antennas.end()) return;
    antennas.erase(found);
}

std::vector<std::shared_ptr<Antenna>>::iterator AntennaManager::findAntenna(const NetID& antennaID) {
    return std::_Find_pr(antennas.begin(), antennas.end(), antennaID, [](const auto& left, const NetID & right) {return *left == right; });
}
