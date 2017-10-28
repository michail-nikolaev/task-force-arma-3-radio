#include "script_component.hpp"

/*
    Name: TFAR_fnc_canTakeRadio

    Author(s):
        Dorbedo

    Description:
        Checks if a radio from the target unit can be taken

    Parameters:
        0: OBJECT - the unit who gets the radio
        1: OBJECT - the unit who loses the radio
        2: STRING/ARRAY - the radio to be taken

    Returns:
        BOOL - the radio can be taken

    Example:
        [_target, _player, "TFAR_anprc_152"] call TFAR_fnc_canTakeRadio;
*/

params ["_target", "_unit", "_radio"];

If (TFAR_takingRadio < 1) exitWith {false};

If ((TFAR_takingRadio isEqualTo 1) && {alive _target}) exitWith {false};

If ((TFAR_takingRadio > 1) && {!([_unit, _target, ["isNotSwimming", "isNotDead", "isNotUnconscious"]] call ace_common_fnc_canInteractWith)}) exitWith {false};

If (_radio isEqualType "") then {
    _unit canAdd _radio
} else {
    (backpack _unit) isEqualTo ""
};
