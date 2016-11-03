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
params[["_radio","",[""]]];

(_radio call TFAR_fnc_getSwSettings) param [RADIO_OWNER,""]
