#define ADD_PLAYER_SELF_ACTIONS \
class ACE_SelfActions { \
    class TFAR_Radio { \
        condition = QUOTE((([] call TFAR_fnc_haveSWRadio) || {([] call TFAR_fnc_haveLRRadio) || !(_player isNil 'TFAR_ExternalIntercomVehicle')})); \
        insertChildren = QUOTE(([_player] call tfar_core_fnc_getOwnRadiosChildren) + (call TFAR_external_intercom_fnc_addWirelessIntercomMenu)); \
        statement = " "; \
    }; \
}
