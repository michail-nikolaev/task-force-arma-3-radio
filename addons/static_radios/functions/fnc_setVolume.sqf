#include "script_component.hpp"

/*
    Name: TFAR_static_radios_fnc_setVolume

    Author(s):
        Dedmen

    Description:
        Sets the static Radio's Volume

    Parameters:
        0: OBJECT - The weaponholder containing the Radio
        1: SCALAR - selected Volume

    Returns:
        NOTHING

    Example:
        ["TFAR_anprc_152_3",1] call TFAR_static_radios_fnc_setVolume;
*/

params ["_radioContainer","_volume"];

_radio_id = _radioContainer call TFAR_static_radios_fnc_instanciatedRadio;

if (_radio_id call TFAR_fnc_isLRRadio) then {
    _radio_id = [_radio_id, "radio_settings"];
    private _settings = _radio_id call TFAR_fnc_getLrSettings;

    _settings set [VOLUME_OFFSET, _volume];

    [_radio_id, _settings] call TFAR_fnc_setLrSettings;
} else {
    private _settings = _radio_id call TFAR_fnc_getSwSettings;

    _settings set [VOLUME_OFFSET, _volume];

    [_radio_id, _settings] call TFAR_fnc_setSwSettings;
};

if (_volume+10 > TF_speakerDistance) then { //If volume is bigger than normal hearing Range.. Increase hearing range.
    missionNamespace setVariable ["TF_speakerDistance",_volume+20,true];
};
