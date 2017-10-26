#include "script_component.hpp"

#include "XEH_PREP.sqf"

[
    "TFAR_AICanHearPlayer",
    "CHECKBOX",
    [LSTRING(SETTING_HEADER), LSTRING(SETTING_DESC)],
    "Task Force Arrowhead Radio",
    false,
    1,
    FUNC(onSettingChanged)
] call CBA_Settings_fnc_init;
