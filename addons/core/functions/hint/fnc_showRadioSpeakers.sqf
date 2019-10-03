#include "script_component.hpp"

/*
  Name: TFAR_fnc_showRadioSpeakers

  Author: Garth de Wet (L-H), Nkey
    shows the speaker hint

  Arguments:
    0: Radio <OBJECT|STRING>

  Return Value:
    None

  Example:
    // LR radio
    [(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_showRadioSpeakers;
    // SW radio
    [(call TFAR_fnc_activeSwRadio)] call TFAR_fnc_showRadioSpeakers;

  Public: Yes
*/
params ["_radio"];

private _isLrRadio = _radio isEqualType [];
private _hintText = "";
private _name = if(_isLrRadio) then {[typeOf (_radio select 0), "displayName", ""] call DFUNC(getVehicleConfigProperty)} else {[_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)};
private _picture = if(_isLrRadio) then {[typeOf (_radio select 0), "picture", ""] call DFUNC(getVehicleConfigProperty)} else {[_radio, "picture", ""] call DFUNC(getWeaponConfigProperty)};
private _volume = formatText [localize LSTRING(radio_volume),if(_isLrRadio) then {((_radio call TFAR_fnc_getLrVolume) + 1) * 10} else {((_radio call TFAR_fnc_getSwVolume) + 1) * 10}];
private _speakers = localize format [LSTRING(speakers_settings_%1), if(_isLrRadio) then {_radio call TFAR_fnc_getLrSpeakers} else {_radio call TFAR_fnc_getSwSpeakers}];

private _imagesize = "1.6";
if ((_isLrRadio) and {!((_radio select 0) isKindOf "Bag_Base")}) then {
    _imagesize = "1.0";
};
_hintText = format [("<t size='1' align='center'>%1 <img size='" + _imagesize + "' image='%2'/></t><br /><t align='center'>%3</t><br /><t align='center'>%4</t><br /><t size='0.8' align='center'>%5</t>"), _name select [0, 22], _picture, _volume, _speakers];


[parseText (_hintText), 5] call TFAR_fnc_showHint;
