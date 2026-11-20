#include "script_component.hpp"

// Resolve the same dialog class used to open the radio, including vehicle overrides.
private _dialogClass = if (_this isEqualType []) then {
    [_this select 0, "tf_dialog"] call TFAR_fnc_getLrRadioProperty
} else {
    [_this, "tf_dialog"] call TFAR_fnc_getWeaponConfigProperty
};
if !(_dialogClass isEqualType "" && {_dialogClass isNotEqualTo ""}) exitWith {configNull};
private _missionDialog = missionConfigFile >> _dialogClass;
if (isClass _missionDialog) exitWith {_missionDialog};
private _campaignDialog = campaignConfigFile >> _dialogClass;
if (isClass _campaignDialog) exitWith {_campaignDialog};
configFile >> _dialogClass
