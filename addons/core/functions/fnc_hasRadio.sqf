#include "script_component.hpp"

/*
    Name: TFAR_fnc_hasRadio

    Author(s):
        Dorbedo

    Description:
        Check if a unit has a radio

    Parameters:
        0: OBJECT - the unit

    Returns:
        the unit has a radio

    Example:
    _hasRadio = [_player] call TFAR_fnc_hasRadio;
 */

params [["_unit", objNull, [objNull]]];

if !(_unit isKindOf "CAManBase") exitWith {false};

(!((_unit call TFAR_fnc_backpackLr) isEqualTo []))
||{(count ([_unit] call TFAR_fnc_getRadioItems))>0}
