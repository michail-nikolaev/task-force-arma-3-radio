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
        "TFAR_anprc148jem_1" call TFAR_fnc_setActiveSwRadio;
*/
private _old = (call TFAR_fnc_activeSwRadio);
if (_this in (items TFAR_currentUnit)) then {
    TFAR_currentUnit unassignItem _old;
    TFAR_currentUnit assignItem _this;
    TFAR_usingRemote = false;
} else {
    TFAR_usingRemote = true;
    TFAR_remoteRadioItem = _this;
};
["OnSWChange", [TFAR_currentUnit, _this, _old]] call TFAR_fnc_fireEventHandlers;
