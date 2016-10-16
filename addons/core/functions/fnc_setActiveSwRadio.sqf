#include "script_component.hpp"

/*
    Name: TFAR_fnc_setActiveSwRadio

    Author(s):
        NKey

    Description:
        Sets the active SW radio.

    Parameters:
        STRING - Radio ID

    Returns:
        Nothing

    Example:
        "tf_anprc148jem_1" call TFAR_fnc_setActiveSwRadio;
*/
private _old = (call TFAR_fnc_activeSwRadio);
TFAR_currentUnit unassignItem _old;
TFAR_currentUnit assignItem _this;
["OnSWChange", [TFAR_currentUnit, _this, _old]] call TFAR_fnc_fireEventHandlers;
