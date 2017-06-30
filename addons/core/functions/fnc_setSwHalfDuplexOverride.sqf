#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwHalfDuplexOverride

    Author(s):
        MorpheusXAUT

    Description:
        Allows toggling of individual SW radio's capabilities to use full-duplex mode although global half-duplex has been enabled.

    Parameters:
        0: STRING - Radio classname
        1: BOOLEAN - Half-duplex override enabled

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeSwRadio, true] call TFAR_fnc_setSwHalfDuplexOverride;
*/

params [
    ["_radio_id", "", [""]],
    ["_halfDuplexOverride", false, [false]]
];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [HALFDUPLEX_OVERRIDE_OFFSET, _halfDuplexOverride];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;
