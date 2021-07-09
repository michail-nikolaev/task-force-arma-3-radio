#define ADD_ACTIONS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        class TFAR_External_Intercom_Phone_Base { \
            distance = 4; \
            exceptions = []; \
            icon = QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone.paa); \
            position = "[_target] call TFAR_external_intercom_fnc_getInteractionPoint"; \
            selection = ""; \
        }; \
        class TFAR_External_Intercom_Phone_Connect : TFAR_External_Intercom_Phone_Base { \
            displayName = CSTRING(PICKUP_PHONE); \
            condition = "([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && isNil {_target getVariable 'TFAR_ExternalIntercomSpeaker'}"; \
            statement = "call TFAR_external_intercom_fnc_connect;"; \
        }; \
        class TFAR_External_Intercom_Phone_Disconnect : TFAR_External_Intercom_Phone_Base { \
            displayName = CSTRING(PUT_AWAY_PHONE); \
            condition = "([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && _target isEqualTo (_player getVariable ['TFAR_ExternalIntercomVehicle', objNull])"; \
            statement = "call TFAR_external_intercom_fnc_disconnect;"; \
        }; \
        class TFAR_External_Intercom_Phone_Busy : TFAR_External_Intercom_Phone_Base { \
            displayName = CSTRING(PHONE_BUSY); \
            condition = "([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && !(_player isEqualTo (_target getVariable ['TFAR_ExternalIntercomSpeaker', objNull])) && !isNil {_target getVariable 'TFAR_ExternalIntercomSpeaker'}"; \
            statement = " "; \
            icon = QPATHTOF(ui\tfar_ace_interaction_external_intercom_phone_busy.paa); \
        }; \
    }; \
};
