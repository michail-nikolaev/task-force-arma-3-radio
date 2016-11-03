#include "script_component.hpp"

/*
   Name: TFAR_fnc_radioOn

   Author(s):
    L-H

   Description:
    Gets the passed radio's on status or switches the radio's status if a boolean is passed as the second parameter.

  Parameters:
    0: STRING/Array - Radio
    1: BOOLEAN - (Optional) On Status

   Returns:
    BOOLEAN - On Status

   Example:
    [call TFAR_fnc_activeSWRadio,true] call TFAR_fnc_radioOn;
*/

params ["_radio", ["_status", false]];

_isLRRadio = _radio isEqualType [];
_settings = [];

if (_isLRRadio) then {
    _settings = (_radio call TFAR_fnc_getLrSettings);
} else {
    _settings = (_radio call TFAR_fnc_getSwSettings);
};

if (count _this == 2) then {
    _settings set [POWER_OFFSET, _status];
    if (_isLRRadio) then {
        [_radio select 0, _radio select 1, _settings] call TFAR_fnc_setLrSettings;
    } else {
        [_radio, _settings] call TFAR_fnc_setSwSettings;
    };
};

_settings select POWER_OFFSET
