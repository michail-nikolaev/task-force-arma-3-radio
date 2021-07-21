#include "ACEActions.hpp"

#define ADD_EVENTHANDLERS \
class EventHandlers : EventHandlers { \
    class TFAR_ExternalIntercomWireless { \
        getOut = "if ((alive (_this select 2)) && (headgear (_this select 2)) in TFAR_externalIntercomWirelessHeadgear && !((_this select 1) isEqualTo 'cargo')) then { [_this select 0, _this select 2, [true]] call TFAR_external_intercom_fnc_connect; };"; \
    }; \
};

#define LAND_CLASS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        ADD_PHONE_ACTIONS \
        ADD_WIRELESS_ACTIONS \
    }; \
    ADD_EVENTHANDLERS \
};

#define AIR_CLASS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        ADD_WIRELESS_ACTIONS \
    }; \
    ADD_EVENTHANDLERS \
};

class CfgVehicles {
    class Man;
    class CAManBase : Man {
        ADD_PLAYER_SELF_ACTIONS
    };

    class AllVehicles;
    class Land;
    class LandVehicle : Land {
        class EventHandlers;
    };
    LAND_CLASS(LandVehicle, Car)
    LAND_CLASS(LandVehicle, Tank)
    LAND_CLASS(Tank, Tank_F)

    class Air : AllVehicles {
        class EventHandlers;
    };
    AIR_CLASS(Air, Helicopter)
    AIR_CLASS(Air, Plane)

    // Custom Interaction Points
    #include "CustomInteractionPoints.hpp"
};
