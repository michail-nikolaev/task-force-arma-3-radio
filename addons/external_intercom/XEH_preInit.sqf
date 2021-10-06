#include "script_component.hpp"

#include "XEH_PREP.sqf"

[
    "TFAR_setting_externalIntercomWirelessHeadgear",
    "EDITBOX",
    [LSTRING(SETTING_WIRELESS_HEADGEAR_HEADER), LSTRING(SETTING_WIRELESS_HEADGEAR_DESC)],
    [localize ELSTRING(settings,global), localize LSTRING(SETTINGS_CATEGORY_EXTERNAL_INTERCOM)],
    ["", false, FUNC(settingForceAlphaNumericArray)],
    1,
    {
        if (isServer) then {
            TFAR_externalIntercomWirelessHeadgear = ((configFile >> "TFAR_External_Intercom_Wireless_Headgear") call BIS_fnc_getCfgSubClasses) + ([_this] call FUNC(parseClassnamesInput));
            publicVariable "TFAR_externalIntercomWirelessHeadgear";
        };
    }
] call CBA_Settings_fnc_init;

[
    "TFAR_externalIntercomEnable",
    "LIST",
    [LSTRING(SETTING_ENABLE_FOR_HEADER), LSTRING(SETTING_ENABLE_FOR_DESC)],
    [localize ELSTRING(settings,global), localize LSTRING(SETTINGS_CATEGORY_EXTERNAL_INTERCOM)],
    [[0,1,2], [LSTRING(SETTING_ENABLE_FOR_ENABLED), LSTRING(SETTING_ENABLE_FOR_SIDE), LSTRING(SETTING_ENABLE_FOR_DISABLED)], 0],
    1,
    {
        _vehicle = ACE_Player getVariable "TFAR_ExternalIntercomVehicle";
        if (_this > 0 && !isNil "_vehicle") then {
            private _preChangeSpeakers = +(_vehicle getVariable ["TFAR_ExternalIntercomSpeakers", [objNull, []]]);
            [_vehicle, ACE_Player] call TFAR_external_intercom_fnc_disconnect;

            [
                _vehicle,
                ACE_Player,
                [(_preChangeSpeakers select 1) find ACE_Player > -1] // Is wireless?
            ] call TFAR_external_intercom_fnc_connect;
            [parseText CSTRING(RESET)] call TFAR_fnc_showHint;
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
