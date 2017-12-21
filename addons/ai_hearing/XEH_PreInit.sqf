#include "script_component.hpp"

#include "XEH_PREP.sqf"

[
    "TFAR_AICanHearPlayer",
    "CHECKBOX",
    [LSTRING(SETTING_HEADER), LSTRING(SETTING_DESC)],
    localize ELSTRING(settings,global),
    false,
    1,
    FUNC(onSettingChanged)
] call CBA_Settings_fnc_init;
[
    "TFAR_AICanHearSpeaker",
    "CHECKBOX",
    [LSTRING(SETTING_SPEAKER_HEADER), LSTRING(SETTING_SPEAKER_DESC)],
    "Task Force Arrowhead Radio",
    false,
    1,
    FUNC(onSettingChanged)
] call CBA_Settings_fnc_init;

[
    QGVAR(reveal),
    {
        (_this select 0) reveal [(_this select 1), (_this select 2)];
    }
] call CBA_fnc_addEventHandler;
