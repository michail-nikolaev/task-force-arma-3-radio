class Man;
class CAManBase: Man {
    class ACE_SelfActions {
        class TFAR_Radio {
            displayName = CSTRING(RADIOS);
            condition = "(([] call TFAR_fnc_haveSWRadio)||([] call TFAR_fnc_haveLRRadio))";
            exceptions[] = {"isNotInside", "isNotSitting", "isNotSwimming"};
            statement = "";
            icon = QPATHTOF(ui\ACE_Interaction_Radio_Icon.paa);
            insertChildren = QUOTE([_player] call FUNC(getOwnRadiosChildren));
        };
    };
    class ACE_Actions {
        class ACE_MainActions {
            class TFAR_Radio {
                displayName = CSTRING(RADIOS);
                distance = 2;
                condition = "_player call TFAR_fnc_hasRadio";
                exceptions[] = {};
                statement = "";
                icon = QPATHTOF(ui\ACE_Interaction_Radio_Icon.paa);
                insertChildren = QUOTE(_this call FUNC(getRadiosChildren));
            };
        };
    };
};
