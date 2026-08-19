#include "script_component.hpp"

/*
  Name: TFAR_fnc_ShowRadioVolume

  Author: Garth de Wet (L-H)
    shows the radio volume

  Arguments:
    0: Radio <OBJECT|STRING>
    1: Show additional channel volume first <BOOL> (default: false)

  Return Value:
    None

  Example:
    // LR radio
    [(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_showRadioVolume;
    // SW radio
    [(call TFAR_fnc_activeSwRadio)] call TFAR_fnc_showRadioVolume;

  Public: Yes
*/
params ["_radio", ["_additionalFirst", false, [true]]];

private _isLrRadio = _radio isEqualType [];
private _hintText = "";

private _name = if(_isLrRadio) then {[typeOf (_radio select 0), "displayName", ""] call DFUNC(getVehicleConfigProperty)} else {[_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)};
private _picture = if(_isLrRadio) then {[typeOf (_radio select 0), "picture", ""] call DFUNC(getVehicleConfigProperty)} else {[_radio, "picture", ""] call DFUNC(getWeaponConfigProperty)};
private _mainVolumeValue = if (_isLrRadio) then {_radio call TFAR_fnc_getLrVolume} else {_radio call TFAR_fnc_getSwVolume};
private _volume = formatText [localize LSTRING(radio_volume), (_mainVolumeValue + 1) * 10];
private _stereo = localize format [LSTRING(stereo_settings_%1), if(_isLrRadio) then {_radio call TFAR_fnc_getLrStereo} else {_radio call TFAR_fnc_getSwStereo}];

private _additional = if (_isLrRadio) then {_radio call TFAR_fnc_getAdditionalLrChannel} else {_radio call TFAR_fnc_getAdditionalSwChannel};

private _add_stereo = "";
private _additionalVolume = "";
if (_additional > -1) then {
    _add_stereo =  localize format [LSTRING(additional_stereo_settings_%1), if(_isLrRadio) then {_radio call TFAR_fnc_getAdditionalLrStereo} else {_radio call TFAR_fnc_getAdditionalSwStereo}];
    private _additionalVolumeValue = if (_isLrRadio) then {_radio call TFAR_fnc_getAdditionalLrVolume} else {_radio call TFAR_fnc_getAdditionalSwVolume};
    _additionalVolume = formatText [localize LSTRING(additional_radio_volume), (_additionalVolumeValue + 1) * 10];
};
private _imagesize = "1.6";
if ((_isLrRadio) and {!((_radio select 0) isKindOf "Bag_Base")}) then {
    _imagesize = "1.0";
};
private _volumeLines = if (_additionalFirst && {_additional > -1}) then {
    format ["%1<br />%2", _additionalVolume, _volume]
} else {
    format ["%1%2", _volume, ["", format ["<br />%1", _additionalVolume]] select (_additional > -1)]
};
_hintText = format [("<t size='1' align='center'>%1 <img size='" + _imagesize + "' image='%2'/></t><br /><t align='center'>%3</t><br /><t align='center'>%4</t><br /><t size='0.8' align='center'>%5</t>"), _name select [0, MAX_RADIONAME_LEN], _picture, _volumeLines, _stereo, _add_stereo];

[parseText (_hintText), 5] call TFAR_fnc_showHint;
