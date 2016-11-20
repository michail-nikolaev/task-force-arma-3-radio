#include "script_component.hpp"

/*
    Name: TFAR_fnc_setRadioOwner

    Author(s):
        L-H

    Description:
        Sets the owner of a SW radio.

    Parameters:
        0: STRING - radio classname
        1: STRING - UID of owner
        2: BOOLEAN - Local only

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeSwRadio, getPlayerUID player] call TFAR_fnc_setRadioOwner;
*/

params ["_radio", "_owner", ["_local", false, [true]]];

private _settings = _radio call TFAR_fnc_getSwSettings;
_settings set [RADIO_OWNER, _owner];
[_radio, _settings, _local] call TFAR_fnc_setSwSettings;

//							owner, radio ID
["OnRadioOwnerSet", [TFAR_currentUnit, _radio]] call TFAR_fnc_fireEventHandlers;
