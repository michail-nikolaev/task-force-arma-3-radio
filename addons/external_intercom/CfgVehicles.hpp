class CfgVehicles {
    #include "ACEActions.hpp"

    class LandVehicle;
    ADD_PHONE_ACTIONS(LandVehicle, Car)
    ADD_WIRELESS_ACTIONS(LandVehicle, Car)

    ADD_PHONE_ACTIONS(LandVehicle, Tank)
    ADD_WIRELESS_ACTIONS(LandVehicle, Tank)

    class Air;
    ADD_WIRELESS_ACTIONS(Air, Helicopter)
    ADD_WIRELESS_ACTIONS(Air, Plane)
};
