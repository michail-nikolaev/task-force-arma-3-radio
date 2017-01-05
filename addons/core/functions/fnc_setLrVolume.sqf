#include "script_component.hpp"

/*
    Name: TFAR_fnc_setLrVolume

    Author(s):
        NKey

    Description:
        Sets the volume for the passed radio

    Parameters:
        0: ARRAY - Radio
            0: OBJECT- Radio object
            1: STRING - Radio ID
        1: NUMBER - Volume : Range (0,10)

    Returns:
        Nothing

    Example:
        [call TFAR_fnc_activeLrRadio, 5] call TFAR_fnc_setLrVolume;
*/
params [["_radio",[],[[]],2],["_value",0,[0]]];
_radio params ["_radio_object", "_radio_qualifier"];

private _settings = _radio call TFAR_fnc_getLrSettings;
_settings set [VOLUME_OFFSET, _value];
[_radio, _settings] call TFAR_fnc_setLrSettings;

//							Unit, radio object, radio ID, volume
["OnLRvolumeSet", [TFAR_currentUnit, _radio_object, _radio_qualifier, _value]] call TFAR_fnc_fireEventHandlers;
