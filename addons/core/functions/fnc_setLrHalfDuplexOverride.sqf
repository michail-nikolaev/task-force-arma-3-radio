#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrHalfDuplexOverride

    Author(s):
        MorpheusXAUT

    Description:
        Allows toggling of individual LR radio's capabilities to use full-duplex mode although global half-duplex has been enabled.

    Parameters:
        0: ARRAY - Radio
            0: OBJECT - Radio object
            1: STRING - Radio ID
        1: BOOLEAN - Half-duplex override enabled

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeLrRadio, true] call TFAR_fnc_setLrHalfDuplexOverride;
*/

params [["_radio",[],[[]],2],["_halfDuplexOverride",false,[false]]];
_radio params ["_radio_object", "_radio_qualifier"];

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [HALFDUPLEX_OVERRIDE_OFFSET, _halfDuplexOverride];
[_radio, _settings] call TFAR_fnc_setLrSettings;
