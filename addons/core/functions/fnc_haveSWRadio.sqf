#include "script_component.hpp"

/*
    Name: TFAR_fnc_haveSWRadio

    Author(s):

    Description:
        Returns whether the player has a SW radio

    Parameters:
    Nothing

    Returns:
    BOOLEAN

    Example:
    _hasSW = call TFAR_fnc_haveSWRadio;
 */
if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith{false};

private _result = false;
{
    if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
    true;
} count (assignedItems TFAR_currentUnit);
_result
