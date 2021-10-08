#include "ACEActions.hpp"

#define LAND_CLASS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        ADD_PHONE_ACTIONS \
        ADD_WIRELESS_ACTIONS \
    }; \
};

#define AIR_CLASS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        ADD_WIRELESS_ACTIONS \
    }; \
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

class Extended_GetOutMan_EventHandlers {
    class CAManBase {
        class TFAR_ExternalIntercom {
            clientGetOutMan = QUOTE(params[ARR_3('_player', '_role', '_vehicle')]; if ( \
                alive (_player) \
                && isPlayer _player \
                && (headgear (_player)) in TFAR_externalIntercomWirelessHeadgear \
                && !((_role) isEqualTo 'cargo') \
                && local _player \
                && [ARR_3((typeOf _vehicle), 'TFAR_hasIntercom', 0)] call TFAR_fnc_getVehicleConfigProperty == 1 \
            ) then { diag_log format[ARR_3('%1 is getting out of %2', _player, _vehicle)]; [ARR_3(_vehicle, _player, [true])] call TFAR_external_intercom_fnc_connect; };);
        };
    };
};
