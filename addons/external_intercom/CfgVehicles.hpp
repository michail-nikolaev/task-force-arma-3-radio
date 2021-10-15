#define LAND_INTERACTIONS \
init = QUOTE(call FUNC(addWirelessInteractions);call FUNC(addPhoneInteractions));

#define AIR_INTERACTIONS \
init = QUOTE(call FUNC(addWirelessInteractions));

class CfgVehicles {
    class Man;
    class CAManBase : Man {
        ADD_PLAYER_SELF_ACTIONS
    };

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
            ) then { TRACE_2('%1 is getting out of %2', _player, _vehicle); [ARR_3(_vehicle, _player, [true])] call TFAR_external_intercom_fnc_connect; };);
        };
    };
};

class Extended_InitPost_Eventhandlers {
    class Car {
        class TFAR_ExternalIntercom_Interactions {
            LAND_INTERACTIONS
        };
    };
    class Tank {
        class TFAR_ExternalIntercom_Interactions {
            LAND_INTERACTIONS
        };
    };
    class Helicopter {
        class TFAR_ExternalIntercom_Interactions {
            AIR_INTERACTIONS
        };
    };
    class Plane {
        class TFAR_ExternalIntercom_Interactions {
            AIR_INTERACTIONS
        };
    };
};
