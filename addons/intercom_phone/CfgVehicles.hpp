class CfgVehicles {
    #include "ACEActions.hpp"

    class LandVehicle;
    ADD_ACTIONS(LandVehicle, Car)
    ADD_ACTIONS(LandVehicle, Tank)
    ADD_ACTIONS(LandVehicle, Motorcycle)
    ADD_ACTIONS(LandVehicle, StaticWeapon)

    // class Air;
    // ADD_ACTIONS(Air, Helicopter)
    // ADD_ACTIONS(Air, Plane)

    // class Ship;
    // ADD_ACTIONS(Ship, Ship_F)
};
