#define ADD_PHONE_ACTIONS \
class TFAR_External_Intercom_Phone_Base { \
    distance = 4; \
    icon = QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone.paa); \
    position = QUOTE([_target] call TFAR_external_intercom_fnc_getInteractionPoint); \
    selection = ""; \
}; \
class TFAR_External_Intercom_Phone_Connect : TFAR_External_Intercom_Phone_Base { \
    displayName = CSTRING(PICKUP_PHONE); \
    condition = QUOTE((alive _target && ([ARR_3((typeOf _target), 'TFAR_hasIntercom', 0)] call TFAR_fnc_getVehicleConfigProperty) > 0) \
            && ( \
                ( \
                    (_target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 0) isEqualTo objNull \
                    && TFAR_externalIntercomEnable isEqualTo 0 \
                ) || ( \
                    (_target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 0) isEqualTo objNull \
                    && [ARR_2(side _player, side _target)] call BIS_fnc_sideIsFriendly \
                    && TFAR_externalIntercomEnable isEqualTo 1 \
                ) \
            )); \
    statement = QUOTE(call TFAR_external_intercom_fnc_connect;); \
}; \
class TFAR_External_Intercom_Phone_Disconnect : TFAR_External_Intercom_Phone_Base { \
    displayName = CSTRING(PUT_AWAY_PHONE); \
    condition = alive _target \
    && (_target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 0) isEqualTo _player; \
    statement = QUOTE(call TFAR_external_intercom_fnc_disconnect;); \
    insertChildren = QUOTE(call TFAR_external_intercom_fnc_addIntercomChannels;); \
}; \
class TFAR_External_Intercom_Phone_Busy : TFAR_External_Intercom_Phone_Base { \
    displayName = CSTRING(PHONE_BUSY); \
    condition = QUOTE(_targetPhoneSpeaker = _target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 0; \
            alive _target && !isNull _targetPhoneSpeaker && !(_targetPhoneSpeaker isEqualTo _player)); \
    statement = " "; \
    icon = QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone_busy.paa); \
};

#define ADD_WIRELESS_ACTIONS \
class ACE_MainActions { \
    class TFAR_External_Intercom_Wireless_Base { \
        distance = 4; \
        icon = QPATHTOF(ui\tfar_ace_interaction_external_intercom_wireless.paa); \
    }; \
    class TFAR_External_Intercom_Wireless_Connect : TFAR_External_Intercom_Wireless_Base { \
        displayName = CSTRING(CONNECT_WIRELESS); \
        condition = QUOTE((alive _target && ([ARR_3((typeOf _target), 'TFAR_hasIntercom', 0)] call TFAR_fnc_getVehicleConfigProperty) > 0) \
                    && ( \
                        ( \
                            !(_player in (_target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 1)) \
                            && [_player] call FUNC(hasWirelessHeadgear) \
                            && TFAR_externalIntercomEnable isEqualTo 0 \
                         ) || ( \
                            !(_player in (_target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 1)) \
                            && [_player] call FUNC(hasWirelessHeadgear) \
                            && [ARR_2(side _player, side _target)] call BIS_fnc_sideIsFriendly \
                            && TFAR_externalIntercomEnable isEqualTo 1 \
                        ) \
                    )); \
        statement = QUOTE(_this set [ARR_2(2, [true])]; call TFAR_external_intercom_fnc_connect;); \
    }; \
    class TFAR_External_Intercom_Wireless_Disconnect : TFAR_External_Intercom_Wireless_Base { \
        displayName = CSTRING(DISCONNECT_WIRELESS); \
        condition = QUOTE(alive _target \
            && _player in (_target getVariable [ARR_2('TFAR_ExternalIntercomSpeakers', [ARR_2(objNull, [])])] select 1)); \
        statement = QUOTE(call TFAR_external_intercom_fnc_disconnect;); \
        icon = QPATHTOF(ui\tfar_ace_interaction_external_intercom_wireless_disconnect.paa); \
    }; \
};

#define ADD_PLAYER_SELF_ACTIONS \
class ACE_SelfActions { \
    class TFAR_Radio; \
    class TFAR_Radio : TFAR_Radio { \
        condition = QUOTE((([] call TFAR_fnc_haveSWRadio) || {([] call TFAR_fnc_haveLRRadio) || !isNil {_player getVariable 'TFAR_ExternalIntercomVehicle'}})); \
        insertChildren = QUOTE(([_player] call tfar_core_fnc_getOwnRadiosChildren) + (call TFAR_external_intercom_fnc_addWirelessIntercomMenu)); \
        statement = " "; \
    }; \
};
