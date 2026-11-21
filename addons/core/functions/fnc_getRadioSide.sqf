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

private _isLrRadio = _radio isEqualType [];
if (!TFAR_VALID_NAME_RADIO(_radio)) exitWith {sideUnknown};
private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);
if (isNil "_settings") exitWith {sideUnknown};

private _radioCode = _settings param [TFAR_CODE_OFFSET, "", [""]];
private _codes = [
    missionNamespace getVariable ["tf_west_radio_code", "_bluefor"],
    missionNamespace getVariable ["tf_east_radio_code", "_opfor"],
    missionNamespace getVariable ["tf_independent_radio_code", "_independent"]
];
if (_radioCode isNotEqualTo "" && {{_x isEqualTo _radioCode} count _codes == 1}) exitWith {
    [west, east, independent] select (_codes find _radioCode)
};

private _encryptionCodeProperty = if (_isLrRadio) then {
    [_radio select 0, "tf_encryptionCode", ""] call TFAR_fnc_getLrRadioProperty
} else {
    [_radio, "tf_encryptionCode", ""] call TFAR_fnc_getWeaponConfigProperty
};

if !(_encryptionCodeProperty isEqualType "") exitWith {sideUnknown};
switch (toLower _encryptionCodeProperty) do {
    case "tf_west_radio_code": {west};
    case "tf_east_radio_code": {east};
    case "tf_guer_radio_code": {independent};
    case "tf_independent_radio_code": {independent};
    default {sideUnknown};
}
