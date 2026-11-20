#include "script_component.hpp"

/*
  Name: TFAR_static_radios_fnc_setVolume

  Author: Dedmen
    sets the static radio's volume

  Arguments:
    0: the weaponholder containing the radio <OBJECT>
    1: selected volume <SCALAR>

  Return Value:
    None

  Example:
    ["TFAR_anprc_152_3",1] call TFAR_static_radios_fnc_setVolume;

  Public: Yes
*/

params ["_radioContainer","_volume"];

CBA_SETTINGS_GUARD(TFAR_static_radios_fnc_setVolume);

private _radio = _radioContainer call TFAR_static_radios_fnc_instanciatedRadio;
if (_radio call TFAR_fnc_isLRRadio) then {
    _radio = [_radio, "radio_settings"];
};
[_radio, _volume] call TFAR_fnc_setRadioVolume;

if (_volume+10 > TF_speakerDistance) then { //If volume is bigger than normal hearing Range.. Increase hearing range.
    missionNamespace setVariable ["TF_speakerDistance",_volume+20,true];
};
