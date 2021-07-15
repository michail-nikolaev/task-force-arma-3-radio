class CfgVehicles {
    #include "ACEActions.hpp"

    class AllVehicles;
    class Land;
    class LandVehicle : Land {
        class EventHandlers;
    };
    ADD_PHONE_ACTIONS(LandVehicle, Car)
    ADD_WIRELESS_ACTIONS(LandVehicle, Car)

    ADD_PHONE_ACTIONS(LandVehicle, Tank)
    ADD_WIRELESS_ACTIONS(LandVehicle, Tank)

    ADD_WIRELESS_ACTIONS(LandVehicle, Tank_F)

    class Air : AllVehicles {
        class EventHandlers;
    };
    ADD_WIRELESS_ACTIONS(Air, Helicopter)
    ADD_WIRELESS_ACTIONS(Air, Plane)
};
