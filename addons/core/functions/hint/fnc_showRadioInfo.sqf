#include "script_component.hpp"

/*
  Name: TFAR_fnc_showRadioInfo

  Author: Garth de Wet (L-H)
    shows the radio info

  Arguments:
    0: Radio <OBJECT/STRING>
    1: is LR radio <BOOL>

  Return Value:
    None

  Example:
    // LR radio
    [(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_showRadioInfo;
    // SW radio
    [(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_showRadioInfo;

  Public: Yes
 */

params ["_radio", "_isLrRadio"];

private _name = if(_isLrRadio) then {[typeOf (_radio select 0), "displayName", ""] call DFUNC(getVehicleConfigProperty)} else {[_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)};
private _picture = if(_isLrRadio) then {[typeOf (_radio select 0), "picture", ""] call DFUNC(getVehicleConfigProperty)} else {[_radio, "picture", ""] call DFUNC(getWeaponConfigProperty)};

private _channel = if(_isLrRadio) then {format[localize LSTRING(active_lr_channel), (_radio call TFAR_fnc_getLrChannel) + 1]} else {format[localize LSTRING(active_sw_channel), (_radio call TFAR_fnc_getSwChannel) + 1]};
private _additional = nil;
if (_isLrRadio) then {
    _additional = _radio call TFAR_fnc_getAdditionalLrChannel;
} else {
    _additional = _radio call TFAR_fnc_getAdditionalSwChannel;
};
private _add_channel = "";
if (_additional > -1) then {
    _add_channel = if(_isLrRadio) then {format[localize LSTRING(active_additional_lr_channel), (_radio call TFAR_fnc_getAdditionalLrChannel) + 1]} else {format[localize LSTRING(active_additional_sw_channel), (_radio call TFAR_fnc_getAdditionalSwChannel) + 1]};
};

private _imagesize = "1.6";
if ((_isLrRadio) and {!((_radio select 0) isKindOf "Bag_Base")}) then {
    _imagesize = "1.0";
};
private _hintText = format [("<t size='1' align='center'>%1 <img size='" + _imagesize + "' image='%2'/></t><br /><t align='center'>%3</t><br /><t align='center'>%4</t><br /><t align='center'>%5</t>"), _name,_picture,_channel,
    format[localize LSTRING(active_frequency), if(_isLrRadio) then {_radio call TFAR_fnc_getLrFrequency} else {_radio call TFAR_fnc_getSwFrequency}], _add_channel];

[parseText (_hintText), 5] call TFAR_fnc_showHint;
