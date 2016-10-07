#include "script_component.hpp"

/*
    Name: TFAR_fnc_getRadioOwner

    Author(s):
        L-H

    Description:
        Gets the owner of a SW radio.

    Parameters:
        STRING - radio classname

    Returns:
        STRING - UID of owner of radio

    Example:
        _owner = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioOwner;
*/

private _settings = (_this call TFAR_fnc_getSwSettings);
if (count _settings > RADIO_OWNER) exitWith {
    ((_this call TFAR_fnc_getSwSettings) select RADIO_OWNER)
};

""
