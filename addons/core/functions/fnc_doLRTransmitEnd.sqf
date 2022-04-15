#include "script_component.hpp"

/*
  Name: TFAR_fnc_doSRTransmitEnd

  Author: Dedmen, NKey
    End a LR Transmission manually, this is internal function.
    It also doesn't handle some variables that are required to stop the transmission via hotkey.

  Arguments:
    0: Radio <ARRAY>
    1: Radio channel <NUMBER>
    2: Radio frequency <STRING>
    3: Was Additional Channel <BOOL>

  Return Value:
    None

  Example:
   [_radio, _channel, _currentFrequency, false] call TFAR_fnc_doLRTransmitEnd;

  Public: No
*/

params ["_radio", "_channel", "_frequency", "_additional"];

["OnBeforeTangent", [TFAR_currentUnit, _radio, 1, _additional, false]] call TFAR_fnc_fireEventHandlers;

private _hintText = format[
                            localize ([LSTRING(transmit_end), LSTRING(additional_transmit_end)] select _additional),
                            format [
                                "%1<img size='1.5' image='%2'/>",
                                ([_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty) select [0, MAX_RADIONAME_LEN],
                                getText(configFile >> "CfgVehicles"  >> typeOf (_radio select 0) >> "picture")
                            ],
                            _channel + 1,
                            _frequency
                        ];

private _pluginCommand = format[
                                "TANGENT_LR	RELEASED	%1%2	%3	%4",
                                _frequency,
                                _radio call TFAR_fnc_getLrRadioCode,
                                ([_radio select 0, "tf_range", 0] call TFAR_fnc_getLrRadioProperty) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                [_radio select 0, "tf_subtype", "digital_lr"] call TFAR_fnc_getLrRadioProperty
                            ];

[_hintText,_pluginCommand, [0,nil] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 1, _additional, false]] call TFAR_fnc_fireEventHandlers;
