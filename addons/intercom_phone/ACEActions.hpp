#define ADD_ACTIONS(parent, child) \
class child : parent { \
    class ACE_Actions { \
        class ACE_MainActions { \
            class TFAR_Intercom_Phone_Activate { \
                displayName = CSTRING(PICKUP_PHONE); \
                distance = 4; \
                condition = "isNil {_player getVariable ""TFAR_vehicleIDOverride""} && ([(typeOf _target), ""TFAR_hasIntercom"", 0] call TFAR_fnc_getVehicleConfigProperty) > 0"; \
                exceptions[] = {}; \
                statement = "call TFAR_fnc_activate;"; \
                icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa); \
                modifierFunction = QUOTE(_this call TFAR_fnc_intercomBusyInteraction); \
            }; \
            class TFAR_Intercom_Phone_Deactivate { \
                displayName = CSTRING(PUT_AWAY_PHONE); \
                distance = 4; \
                condition = "!isNil {_player getVariable ""TFAR_vehicleIDOverride""} && ([(typeOf _target), ""TFAR_hasIntercom"", 0] call TFAR_fnc_getVehicleConfigProperty) > 0"; \
                exceptions[] = {}; \
                statement = "call TFAR_fnc_deactivate;"; \
                icon = QPATHTOF(ui\tfar_ace_interaction_intercom_phone.paa); \
            }; \
        }; \
    }; \
};
