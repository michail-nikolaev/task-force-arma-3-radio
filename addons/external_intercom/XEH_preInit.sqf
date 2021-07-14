#include "script_component.hpp"

#include "XEH_PREP.sqf"

[
    "TFAR_externalIntercomWirelessHeadgear",
    "EDITBOX",
    [LSTRING(SETTING_WIRELESS_HEADGEAR_HEADER), LSTRING(SETTING_WIRELESS_HEADGEAR_DESC)],
    [localize ELSTRING(settings,global), localize LSTRING(SETTINGS_CATEGORY_EXTERNAL_INTERCOM)],
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            #include "baseHeadgear.hpp"
            TFAR_externalIntercomWirelessHeadgear = BASE_HEADGEAR + ([_this] call FUNC(parseClassnamesInput));
            publicVariable "TFAR_externalIntercomWirelessHeadgear";
        };
    }
] call CBA_Settings_fnc_init;

[
    "TFAR_externalIntercomMaxRange_Wireless",
    "SLIDER",
    [LSTRING(SETTING_WIRELESS_RANGE_HEADER), LSTRING(SETTING_WIRELESS_RANGE_DESC)],
    [localize ELSTRING(settings,global), localize LSTRING(SETTINGS_CATEGORY_EXTERNAL_INTERCOM)],
    [1, 20, 15, 0],
    1
] call CBA_Settings_fnc_init;

[
    "TFAR_externalIntercomMaxRange_Phone",
    "SLIDER",
    [LSTRING(SETTING_PHONE_RANGE_HEADER), LSTRING(SETTING_PHONE_RANGE_DESC)],
    [localize ELSTRING(settings,global), localize LSTRING(SETTINGS_CATEGORY_EXTERNAL_INTERCOM)],
    [1, 20, 5, 0],
    1
] call CBA_Settings_fnc_init;
