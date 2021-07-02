#define ADD_ACTIONS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        class TFAR_Intercom_Phone_Base { \
            distance = 4; \
            exceptions = []; \
            icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa); \
            position = "[_target] call TFAR_intercom_phone_fnc_getInteractionPoint"; \
            selection = ""; \
        }; \
        class TFAR_Intercom_Phone_Activate : TFAR_Intercom_Phone_Base { \
            displayName = CSTRING(PICKUP); \
            condition = "([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && isNil {_target getVariable 'TFAR_IntercomPhoneSpeaker'}"; \
            statement = "call TFAR_intercom_phone_fnc_activate;"; \
        }; \
        class TFAR_Intercom_Phone_Deactivate : TFAR_Intercom_Phone_Base { \
            displayName = CSTRING(PUT_AWAY); \
            condition = "([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && _target isEqualTo (_player getVariable ['TFAR_IntercomPhoneVehicle', objNull])"; \
            statement = "call TFAR_intercom_phone_fnc_deactivate;"; \
        }; \
        class TFAR_Intercom_Phone_Busy : TFAR_Intercom_Phone_Base { \
            displayName = CSTRING(BUSY); \
            condition = "([(typeOf _target), 'TFAR_hasIntercom', 0] call TFAR_fnc_getVehicleConfigProperty) > 0 && !(_player isEqualTo (_target getVariable ['TFAR_IntercomPhoneSpeaker', objNull])) && !isNil {_target getVariable 'TFAR_IntercomPhoneSpeaker'}"; \
            statement = " "; \
            icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone_busy.paa); \
        }; \
    }; \
};
