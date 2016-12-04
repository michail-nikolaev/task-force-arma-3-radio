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

if (isNil "_settings") then {//TFAR_fnc_getLrSettings may return Nil if some script in there is screwed up
    WARNING("_settings was Nil!");
};

if (count _this == 2) then {//want to set status
    _settings set [POWER_OFFSET, _status];
    if (_isLRRadio) then {
        [_radio, _settings] call TFAR_fnc_setLrSettings;
    } else {
        [_radio, _settings] call TFAR_fnc_setSwSettings;
    };
};

_settings param [POWER_OFFSET,true]
