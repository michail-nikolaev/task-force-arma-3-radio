#include "script_component.hpp"

/*
  Name: TFAR_fnc_getRadioSide

  Author: Darojax
    Returns the TFAR side affiliation of an SW or LR radio. The current radio
    code is preferred when it uniquely matches a configured side code. Shared
    codes and custom codes fall back to the radio type's encryption property.

  Arguments:
    Radio <ARRAY|STRING>

  Return Value:
    Radio side, or sideUnknown when no affiliation can be determined <SIDE>

  Example:
    (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioSide;

  Public: Yes
*/

private _radio = _this;
if !(_radio isEqualType [] || {_radio isEqualType ""}) exitWith {sideUnknown};

private _isLrRadio = _radio isEqualType [];
private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);
if (isNil "_settings") exitWith {sideUnknown};

private _radioCode = _settings param [TFAR_CODE_OFFSET, "", [""]];
private _sides = [west, east, independent];
private _matchingSides = [];
if (_radioCode isNotEqualTo "") then {
    {
        if (_radioCode isEqualTo _x) then {
            _matchingSides pushBack (_sides select _forEachIndex);
        };
    } forEach [
        missionNamespace getVariable ["tf_west_radio_code", "_bluefor"],
        missionNamespace getVariable ["tf_east_radio_code", "_opfor"],
        missionNamespace getVariable ["tf_independent_radio_code", "_independent"]
    ];
};
if (count _matchingSides == 1) exitWith {_matchingSides select 0};

private _encryptionCodeProperty = if (_isLrRadio) then {
    [_radio select 0, "tf_encryptionCode", ""] call TFAR_fnc_getLrRadioProperty
} else {
    [_radio, "tf_encryptionCode", ""] call TFAR_fnc_getWeaponConfigProperty
};

switch (toLower _encryptionCodeProperty) do {
    case "tf_west_radio_code": {west};
    case "tf_east_radio_code": {east};
    case "tf_guer_radio_code": {independent};
    case "tf_independent_radio_code": {independent};
    default {sideUnknown};
}
