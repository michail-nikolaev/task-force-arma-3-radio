class CfgVehicles {
    #include "ACEActions.hpp"

    class LandVehicle;
    ADD_ACTIONS(LandVehicle, Car)
    ADD_ACTIONS(LandVehicle, Tank)

    // class Air;
    // ADD_ACTIONS(Air, Helicopter)
    // ADD_ACTIONS(Air, Plane)
};
