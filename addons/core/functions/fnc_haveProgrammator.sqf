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

_result = false;

if (player == TFAR_currentUnit) then {
    exitWith {_result = "TFAR_microdagr" in (assignedItems TFAR_currentUnit)};
} else {
    if (player != TFAR_currentUnit && {TFAR_remoteRadio}) then {
        exitWith {_result = "TFAR_microdagr" in (assignedItems player)};
    };
};

_result
