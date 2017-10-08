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
"TFAR_microdagr" in (assignedItems TFAR_currentUnit) || {"ACE_microDAGR" in (assignedItems TFAR_currentUnit)};//#TODO use arrayIntersect
