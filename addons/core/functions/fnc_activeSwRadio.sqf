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
{
    if (_x call TFAR_fnc_isRadio) exitWith {_result = _x};
    true;
} count (assignedItems TFAR_currentUnit);

if (player != TFAR_currentUnit && !isNil "TFAR_usingRemote" && TFAR_usingRemote) then {
    _result = TFAR_remoteRadioItem;
};

_result
