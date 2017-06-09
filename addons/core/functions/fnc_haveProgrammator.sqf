#include "script_component.hpp"

/*
    Name: TFAR_fnc_haveProgrammator

    Author(s):

    Description:
    Returns whether the player has a programmer

    Parameters:
    Nothing

    Returns:
    BOOLEAN

    Example:
    _hasProgrammer = call TFAR_fnc_haveProgrammator;
*/

if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith {false};

_result = "TFAR_microdagr" in (assignedItems TFAR_currentUnit);

if (player != TFAR_currentUnit && {TFAR_remoteRadio}) then {
    _result = "TFAR_microdagr" in (assignedItems player);
};

_result
