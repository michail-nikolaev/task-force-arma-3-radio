#pragma once
#include "datatypes.hpp"
#include "Locks.hpp"
#include <memory>

using namespace dataType;
class Antenna {
public:
    Antenna(NetID _id, Position3D _pos, float _range) : id(_id), pos(_pos), range(_range), rangeSquared(_range*_range) {}
    Antenna(Antenna&& other) : id(std::move(other.id)), pos(std::move(other.pos)), range(std::move(other.range)), rangeSquared(std::move(other.rangeSquared)) { }

    float distanceTo(const Position3D& other) const { return pos.distanceTo(other); }
    float lossTo(const Position3D& other) const {
        if (!range) return 1.f;
        auto dist = pos.distanceTo(other);
        if (dist > range) return 1.f;
        return dist / range;
    };
    float lossFrom(const Position3D& from, float maxDistance) const {
        if (!maxDistance) return 1.f;
        auto dist = pos.distanceTo(from);
        if (dist > maxDistance) return 1.f;
        return dist / maxDistance;
    };
    bool canBeReachedBy(const Position3D& from, float maxDistanceSquared) const {
        return pos.distanceToSqr(from) < maxDistanceSquared;
    }
    bool canReach(const Position3D& to) const {
        return pos.distanceToSqr(to) < rangeSquared;
    }
    float connectionLoss(const Position3D& from, float maxDistanceToAnt, const Position3D& to) const {
        return lossTo(to) + lossFrom(from, maxDistanceToAnt);
    }
    //Operators
    void operator=(Antenna&& ant) {
        id = std::move(ant.id);
        pos = std::move(ant.pos);
        range = std::move(ant.range);
        rangeSquared = std::move(ant.rangeSquared);
        satUplink = std::move(ant.satUplink);
    }
    bool operator==(const NetID& antID) const {
        return id == antID;
    }
    //Conversions
    operator Position3D&() { return pos; }
    operator NetID&() { return id; }

    //Setters
    void setID(NetID _id) { id = _id; }
    void setPos(Position3D _pos) { pos = _pos; }
    void setRange(float _range) { range = _range; }
    void setSatelliteUplink(bool hasUplink) { satUplink = hasUplink; }
    //Getters
    NetID getID() const { return id; }
    Position3D getPos() const { return pos; }
    float getRange() const { return range; }
    bool hasSatelliteUplink() const { return satUplink; }

private:
    NetID id;
    Position3D pos;
    float range{ 0 };
    float rangeSquared{ 0 };
    bool satUplink{ 0 }; //future functionality
};

class AntennaConnection {
public:
    AntennaConnection(){}
    AntennaConnection(Position3D _from, std::shared_ptr<Antenna> _overAntenna,Position3D _to,float _loss) : from(_from),overAntenna(_overAntenna),to(_to),loss(_loss){}
    float getLoss() const { return loss; }
    bool isNull() const { return loss == 7.f; }//Magic number. Loss will never be >1
    std::shared_ptr<Antenna> getAntenna() const { return overAntenna; }
private:
    Position3D from;
    std::shared_ptr<Antenna> overAntenna;
    Position3D to;
    float loss {7.f};
};


class AntennaManager {
public:
    AntennaManager();
    ~AntennaManager();

    AntennaConnection findConnection(const Position3D& from, float maxDistanceToAnt, const Position3D& to);
    void addAntenna(Antenna ant);
    void removeAntenna(const NetID& antennaID);
private:
    std::vector<std::shared_ptr<Antenna>>::iterator findAntenna(const NetID& antennaID);


    //There are better containers for this. May rework this later
    std::vector<std::shared_ptr<Antenna>> antennas;

    using LockGuard_shared = LockGuard_shared<ReadWriteLock>;
    using LockGuard_exclusive = LockGuard_exclusive<ReadWriteLock>;
    ReadWriteLock m_lock;
};

