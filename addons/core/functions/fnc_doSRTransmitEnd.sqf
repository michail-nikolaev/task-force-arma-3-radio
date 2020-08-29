#include "script_component.hpp"

/*
  Name: TFAR_fnc_doSRTransmitEnd

  Author: Dedmen, NKey
    End a SR Transmission manually, this is internal function.
    It also doesn't handle some variables that are required to stop the transmission via hotkey.

  Arguments:
    0: Radio <STRING>
    1: Radio channel <NUMBER>
    2: Radio frequency <STRING>
    3: Was Additional Channel <BOOL>

  Return Value:
    None

  Example:
   [_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmitEnd;

  Public: No
*/

params ["_radio", "_channel", "_frequency", "_additional"];

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, _additional, false]] call TFAR_fnc_fireEventHandlers;

private _hintText = format[
                            localize ([LSTRING(transmit_end), LSTRING(additional_transmit_end)] select _additional),
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    ([_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)) select [0, MAX_RADIONAME_LEN],
                                    ([_radio, "picture", ""] call DFUNC(getWeaponConfigProperty))
                                ],
                            _channel + 1,
                            _frequency
                        ];

private _pluginCommand = format[
                                "TANGENT	RELEASED	%1%2	%3	%4",
                                _frequency,
                                _radio call TFAR_fnc_getSwRadioCode,
                                ([_radio, "tf_range", 0] call DFUNC(getWeaponConfigProperty)) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                ([_radio, "tf_subtype", "digital"] call DFUNC(getWeaponConfigProperty))
                            ];

[_hintText,_pluginCommand, [0,nil] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, _additional, false]] call TFAR_fnc_fireEventHandlers;
