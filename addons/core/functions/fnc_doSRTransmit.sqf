#include "script_component.hpp"

/*
  Name: TFAR_fnc_doSRTransmit

  Author: Dedmen, NKey
    Start a SR Transmission manually, this is internal function.
    This doesn't contain human factor checks like 500ms delay between pressdown,
    singleplayer mode or transmitting on multiple radios simultaniously.
    Also doesn't check that channel matches frequency or that either match the specific radio.
    It also doesn't handle some variables that are required to stop the transmission via hotkey.

  Arguments:
    0: Radio <STRING>
    1: Radio channel <NUMBER>
    2: Radio frequency <STRING>
    3: Is Additional Channel <BOOL>

  Return Value:
    None

  Example:
   [_radio, _channel, _currentFrequency, false] call TFAR_fnc_doSRTransmit;

  Public: No
*/

params ["_radio", "_channel", "_frequency", "_additional"];

if (!([_radio] call TFAR_fnc_RadioOn)) exitWith {false};

private _depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
private _isolatedAndInside = TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside;

if !([  TFAR_currentUnit,
        _isolatedAndInside,
        [_isolatedAndInside,_depth] call TFAR_fnc_canSpeak,
        _depth
    ] call TFAR_fnc_canUseSWRadio
    ||
    {([_depth,_isolatedAndInside] call TFAR_fnc_canUseDDRadio)}
    ) exitWith {call TFAR_fnc_inWaterHint;false};

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, _additional, true]] call TFAR_fnc_fireEventHandlers;

private _hintText = format[
                            localize ([LSTRING(transmit), LSTRING(additional_transmit)] select _additional),
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    ([_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty)) select [0, MAX_RADIONAME_LEN],
                                    ([_radio, "picture", ""] call DFUNC(getWeaponConfigProperty))
                                    ],
                            _channel + 1,
                            _frequency
                        ];

private _pluginCommand = format[
                                "TANGENT	PRESSED	%1%2	%3	%4	%5",
                                _frequency,
                                _radio call TFAR_fnc_getSwRadioCode,
                                ([_radio, "tf_range", 0] call DFUNC(getWeaponConfigProperty)) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                ([_radio, "tf_subtype", "digital"] call DFUNC(getWeaponConfigProperty)),
                                _radio
                            ];

[_hintText,_pluginCommand, [0,-1] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, _additional, true]] call TFAR_fnc_fireEventHandlers;
