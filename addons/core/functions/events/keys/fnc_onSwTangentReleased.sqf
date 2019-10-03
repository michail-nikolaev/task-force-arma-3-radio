#include "script_component.hpp"

/*
  Name: TFAR_fnc_onSwTangentReleased

  Author: NKey
    Fired when the keybinding for SR is released.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onSwTangentReleased;

  Public: No
*/

if ((!TF_tangent_sw_pressed) or {!alive TFAR_currentUnit}) exitWith {false};
private _radio = call TFAR_fnc_activeSwRadio;

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers;

private _currentFrequency = call TFAR_fnc_currentSWFrequency;
private _hintText = format[
                            localize LSTRING(transmit_end),
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    ([_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)) select [0, 22],
                                    ([_radio, "picture", ""] call DFUNC(getWeaponConfigProperty))
                                ],
                            (_radio call TFAR_fnc_getSwChannel) + 1,
                            _currentFrequency
                        ];

private _pluginCommand = format[
                                "TANGENT	RELEASED	%1%2	%3	%4",
                                _currentFrequency,
                                _radio call TFAR_fnc_getSwRadioCode,
                                ([_radio, "tf_range", 0] call DFUNC(getWeaponConfigProperty)) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                ([_radio, "tf_subtype", "digital"] call DFUNC(getWeaponConfigProperty))
                            ];

[_hintText,_pluginCommand, [0,nil] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

TF_tangent_sw_pressed = false;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers;
false
