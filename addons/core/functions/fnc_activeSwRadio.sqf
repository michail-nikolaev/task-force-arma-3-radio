#include "script_component.hpp"

/*
    Name: TFAR_fnc_activeSwRadio

    Author(s):
        NKey

    Description:
        Returns the active SW radio.

    Parameters:
        Nothing

    Returns:
        STRING: Active SW radio

    Example:
        _radio = call TFAR_fnc_activeSwRadio;
*/

private _result = nil;

if (player != TFAR_currentUnit && {TFAR_remoteRadio}) then {
    exitWith {_result = TFAR_removeRadioItem};
};

if (_result == nil) then {
    {
        if (_x call TFAR_fnc_isRadio) exitWith {_result = _x};
        true;
    } count (assignedItems TFAR_currentUnit);
};

_result
