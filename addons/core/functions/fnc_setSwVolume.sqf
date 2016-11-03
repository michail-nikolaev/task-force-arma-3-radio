#include "script_component.hpp"

/*
    Name: TFAR_fnc_setSwVolume

    Author(s):
        NKey

    Description:
        Sets the volume for the SW radio

    Parameters:
    0: STRING - Radio
    1: NUMBER - Volume : Range (0,10)

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeSWRadio, 10] call TFAR_fnc_setSwVolume;
*/

params ["_radio_id", "_value"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [VOLUME_OFFSET, _value];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;

//							Unit, radio ID, volume
["OnSWvolumeSet", [TFAR_currentUnit, _radio_id, _value]] call TFAR_fnc_fireEventHandlers;
