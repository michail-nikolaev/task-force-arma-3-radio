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
if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith{false};
"tf_microdagr" in (assignedItems TFAR_currentUnit);
