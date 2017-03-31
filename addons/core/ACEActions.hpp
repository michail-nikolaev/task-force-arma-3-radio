class Man;
class CAManBase: Man {
    class ACE_SelfActions {
        class ACE_Equipment {
            class TFAR_Radio {
                displayName = "Radios";
                condition = "call TFAR_fnc_haveSWRadio";
                exceptions[] = {};
                statement = "";
                icon = QPATHTOF(ui\ACE_Interaction_Radio_Icon.paa);
                insertChildren = "[_player] call TFAR_fnc_addRadiosToACE";
            };
            class TFAR_LowerHeadset {
                displayName = "Lower Headset";
                condition = "(!(missionNamespace getVariable ['TFAR_core_isHeadsetLowered',false])) && (call TFAR_fnc_haveSWRadio || call TFAR_fnc_haveLRRadio)";
                //exceptions[] = {};
                statement = "true call TFAR_fnc_setHeadsetLowered;";
                //showDisabled = 0;
                icon = "";
            };
            class TFAR_RaiseHeadset {
                displayName = "Raise Headset";
                condition = "(missionNamespace getVariable ['TFAR_core_isHeadsetLowered',false]) && (call TFAR_fnc_haveSWRadio || call TFAR_fnc_haveLRRadio)";
                //exceptions[] = {};
                statement = "false call TFAR_fnc_setHeadsetLowered;";
                //showDisabled = 0;
                icon = "";
            };
        };
    };
};
