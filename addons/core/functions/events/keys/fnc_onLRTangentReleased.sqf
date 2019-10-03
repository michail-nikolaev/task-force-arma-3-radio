#include "script_component.hpp"

/*
  Name: TFAR_fnc_onLRTangentReleased

  Author: NKey
    Fired when the keybinding for LR is released.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onLRTangentReleased;

  Public: No
*/

if (!(TF_tangent_lr_pressed) or {!alive TFAR_currentUnit}) exitWith {false};
private _radio = call TFAR_fnc_activeLrRadio;

["OnBeforeTangent", [TFAR_currentUnit, _radio, 1, false, false]] call TFAR_fnc_fireEventHandlers;

private _currentFrequency = call TFAR_fnc_currentLRFrequency;

private _hintText = format[
                            localize LSTRING(transmit_end),
                            format [
                                "%1<img size='1.5' image='%2'/>",
                                ([_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty) select [0, MAX_RADIONAME_LEN],
                                getText(configFile >> "CfgVehicles"  >> typeOf (_radio select 0) >> "picture")
                            ],
                            (_radio call TFAR_fnc_getLrChannel) + 1,
                            _currentFrequency
                        ];

private _pluginCommand = format[
                                "TANGENT_LR	RELEASED	%1%2	%3	%4",
                                _currentFrequency,
                                _radio call TFAR_fnc_getLrRadioCode,
                                ([_radio select 0, "tf_range", 0] call TFAR_fnc_getLrRadioProperty) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                [_radio select 0, "tf_subtype", "digital_lr"] call TFAR_fnc_getLrRadioProperty
                            ];

[_hintText,_pluginCommand, [0,nil] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;
TF_tangent_lr_pressed = false;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 1, false, false]] call TFAR_fnc_fireEventHandlers;
false
