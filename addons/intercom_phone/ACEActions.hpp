#define ADD_ACTIONS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        class ACE_MainActions { \
            class TFAR_Intercom_Phone_Activate { \
                displayName = CSTRING(PICKUP); \
                distance = 4; \
                condition = "isNil {_player getVariable 'TFAR_vehicleIDOverride'} && ([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && isNil {_target getVariable 'TFAR_IntercomPhoneSpeaker'}"; \
                exceptions[] = {}; \
                statement = "call TFAR_intercom_phone_fnc_activate;"; \
                icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa); \
            }; \
            class TFAR_Intercom_Phone_Deactivate { \
                displayName = CSTRING(PUT_AWAY); \
                distance = 4; \
                condition = "!isNil {_player getVariable 'TFAR_vehicleIDOverride'} && ([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0"; \
                exceptions[] = {}; \
                statement = "call TFAR_intercom_phone_fnc_deactivate;"; \
                icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa); \
            }; \
            class TFAR_Intercom_Phone_Busy { \
                displayName = CSTRING(BUSY); \
                distance = 4; \
                condition = "isNil {_player getVariable 'TFAR_vehicleIDOverride'} && ([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && !isNil {_target getVariable 'TFAR_IntercomPhoneSpeaker'}"; \
                exceptions[] = {}; \
                statement = " "; \
                icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone_busy.paa); \
            }; \
        }; \
    }; \
};
