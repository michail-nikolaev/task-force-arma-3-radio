#include "script_component.hpp"

/*
  Name: TFAR_fnc_setRadioOwner

  Author: Garth de Wet (L-H)
    Sets the owner of a SW radio.

  Arguments:
    0: radio classname <STRING>
    1: UID of owner <STRING>
    2: Local only <BOOL>

  Return Value:
    None

  Example:
    [call TFAR_fnc_activeSwRadio, getPlayerUID player] call TFAR_fnc_setRadioOwner;

  Public: Yes
*/

params ["_radio", "_owner", ["_local", false, [true]]];

if !(GVAR(SettingsInitialized)) exitWith {
    [{GVAR(SettingsInitialized)}, TFAR_fnc_setRadioOwner, _this] call CBA_fnc_waitUntilAndExecute;
};

private _settings = _radio call TFAR_fnc_getSwSettings;
_settings set [RADIO_OWNER, _owner];
[_radio, _settings, _local] call TFAR_fnc_setSwSettings;

// owner, radio ID
["OnRadioOwnerSet", [TFAR_currentUnit, _radio]] call TFAR_fnc_fireEventHandlers;
