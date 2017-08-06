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

if (player != TFAR_currentUnit && {TFAR_remoteRadio}) then {
    exitWith {"TFAR_microdagr" in (assignedItems player)};
};

exitWith {"TFAR_microdagr" in (assignedItems TFAR_currentUnit)};
