class Man;
class CAManBase: Man {
    class ACE_SelfActions {
        class ACE_Equipment {
            class TFAR_Radio {
                displayName = CSTRING(RADIOS);
                condition = "(([] call TFAR_fnc_haveSWRadio)||([] call TFAR_fnc_haveLRRadio))";
                exceptions[] = {"isNotInside", "isNotSitting", "isNotSwimming"};
                statement = "";
                icon = QPATHTOF(ui\ACE_Interaction_Radio_Icon.paa);
                insertChildren = "[_player] call TFAR_fnc_addRadiosToACE";
            };
            class TFAR_LowerHeadset {
                displayName = "Lower Headset";
                condition = "(!(missionNamespace getVariable ['TFAR_core_isHeadsetLowered',false])) && (call TFAR_fnc_haveSWRadio || call TFAR_fnc_haveLRRadio)";
                exceptions[] = {"isNotInside", "isNotSitting", "isNotSwimming"};
                statement = "true call TFAR_fnc_setHeadsetLowered;";
                //showDisabled = 0;
                icon = "";
            };
            class TFAR_RaiseHeadset {
                displayName = "Raise Headset";
                condition = "(missionNamespace getVariable ['TFAR_core_isHeadsetLowered',false]) && (call TFAR_fnc_haveSWRadio || call TFAR_fnc_haveLRRadio)";
                exceptions[] = {"isNotInside", "isNotSitting", "isNotSwimming"};
                statement = "false call TFAR_fnc_setHeadsetLowered;";
                //showDisabled = 0;
                icon = "";
            };
        };
    };
    class ACE_Actions {
        class ACE_MainActions {
            class TFAR_Radio {
                displayName = CSTRING(RADIOS);
                distance = 2;
                condition = "[_this select 1] call TFAR_fnc_hasRadio";
                exceptions[] = {};
                statement = "";
                icon = QPATHTOF(ui\ACE_Interaction_Radio_Icon.paa);
                insertChildren = "_this call TFAR_fnc_addTakeToACE";
            };
        };
    };
};
