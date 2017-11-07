#include "script_component.hpp"

/*
    Name: TFAR_fnc_showRadioVolume

    Author(s):
        L-H

    Description:

    Parameters:
    0: OBJECT/STRING - Radio

    Returns:
    Nothing

    Example:
    // LR radio
    [(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_showRadioVolume;
    // SW radio
    [(call TFAR_fnc_activeSwRadio)] call TFAR_fnc_showRadioVolume;
*/
params ["_radio"];

private _isLrRadio = _radio isEqualType [];
private _hintText = "";

private _name = if(_isLrRadio) then {[typeOf (_radio select 0), "displayName", ""] call DFUNC(getConfigProperty)} else {[_radio, "displayName", ""] call DFUNC(getConfigWeaponProperty)};
private _picture = if(_isLrRadio) then {[typeOf (_radio select 0), "picture", ""] call DFUNC(getConfigProperty)} else {[_radio, "picture", ""] call DFUNC(getConfigWeaponProperty)};
private _volume = formatText [localize "STR_radio_volume",if(_isLrRadio) then {((_radio call TFAR_fnc_getLrVolume) + 1) * 10} else {((_radio call TFAR_fnc_getSwVolume) + 1) * 10}];
private _stereo = localize format ["STR_stereo_settings_%1", if(_isLrRadio) then {_radio call TFAR_fnc_getLrStereo} else {_radio call TFAR_fnc_getSwStereo}];

private _additional = if (_isLrRadio) then {_radio call TFAR_fnc_getAdditionalLrChannel} else {_radio call TFAR_fnc_getAdditionalSwChannel};

private _add_stereo = "";
if (_additional > -1) then {
    _add_stereo =  localize format ["STR_additional_stereo_settings_%1", if(_isLrRadio) then {_radio call TFAR_fnc_getAdditionalLrStereo} else {_radio call TFAR_fnc_getAdditionalSwStereo}];
};
private _imagesize = "1.6";
if ((_isLrRadio) and {!((_radio select 0) isKindOf "Bag_Base")}) then {
    _imagesize = "1.0";
};
_hintText = format [("<t size='1' align='center'>%1 <img size='" + _imagesize + "' image='%2'/></t><br /><t align='center'>%3</t><br /><t align='center'>%4</t><br /><t size='0.8' align='center'>%5</t>"), _name,_picture,_volume, _stereo, _add_stereo];

[parseText (_hintText), 5] call TFAR_fnc_showHint;
