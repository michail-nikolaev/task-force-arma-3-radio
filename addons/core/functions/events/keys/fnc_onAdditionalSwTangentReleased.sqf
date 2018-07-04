#include "script_component.hpp"

/*
  Name: TFAR_fnc_onAdditionalSwTangentReleased

  Author: NKey
    Fired when the additional keybinding for SR is relesed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onAdditionalSwTangentReleased;

  Public: No
*/


if ((!TF_tangent_sw_pressed) or {!alive TFAR_currentUnit}) exitWith {false};
private _radio = call TFAR_fnc_activeSwRadio;

private _additonalChannel = _radio call TFAR_fnc_getAdditionalSwChannel;
if (_additonalChannel < 0) exitWith {false}; //No Additional Channel set

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, true, false]] call TFAR_fnc_fireEventHandlers;

private _currentFrequency = [_radio, _additonalChannel + 1] call TFAR_fnc_getChannelFrequency;

private _hintText = format[
                            localize LSTRING(additional_transmit_end),
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    ([_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)),
                                    ([_radio, "picture", ""] call DFUNC(getWeaponConfigProperty))
                                ],
                            _additonalChannel + 1,
                            _currentFrequency
                        ];

private _pluginCommand = format[
                                "TANGENT	RELEASED	%1%2	%3	%4",
                                _currentFrequency,
                                _radio call TFAR_fnc_getSwRadioCode,
                                ([_radio, "tf_range", 0] call DFUNC(getWeaponConfigProperty)) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                ([_radio, "tf_subtype", ""] call DFUNC(getWeaponConfigProperty))
                            ];

[_hintText,_pluginCommand, [0,nil] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

TF_tangent_sw_pressed = false;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, true, false]] call TFAR_fnc_fireEventHandlers;
false
