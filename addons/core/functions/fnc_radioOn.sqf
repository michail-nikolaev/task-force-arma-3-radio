#include "script_component.hpp"

/*
  Name: TFAR_fnc_radioOn

  Author: Garth de Wet (L-H)
    Gets the passed radio's on status or switches the radio's status if a boolean is passed as the second parameter.

  Arguments:
    0: Radio <STRING|ARRAY>
    1: New power state <BOOL> (omit to read the current state)

  Return Value:
    On Status <BOOL>

  Example:
    [call TFAR_fnc_activeSWRadio,true] call TFAR_fnc_radioOn;

  Public: Yes
*/

params ["_radio", ["_status", false]];

private _isLrRadio = _radio isEqualType [];
private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);

if (isNil "_settings") exitWith {
    WARNING("Radio settings are unavailable");
    false
};

if (count _this == 2) then {
    _settings set [POWER_OFFSET, _status];
    [_radio, _settings] call ([TFAR_fnc_setSwSettings, TFAR_fnc_setLrSettings] select _isLrRadio);
};

isNil {_settings param [POWER_OFFSET]} || {_settings select POWER_OFFSET}
