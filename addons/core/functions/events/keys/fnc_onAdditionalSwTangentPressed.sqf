#include "script_component.hpp"

/*
  Name: TFAR_fnc_onAdditionalSwTangentPressed

  Author: NKey
    Fired when the additional keybinding for SR is pressed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onAdditionalSwTangentPressed;

  Public: No
*/
//#TODO overhaul Additional Tangent functions


if (((TF_tangent_lr_pressed or TF_tangent_sw_pressed)) or {!alive TFAR_currentUnit} or {!call TFAR_fnc_haveSWRadio}) exitWith {false};

if (!isMultiplayer) exitWith {_x = localize LSTRING(WM_Singleplayer);systemChat _x;hint _x;false};

if (!call TFAR_fnc_isAbleToUseRadio) exitWith {call TFAR_fnc_unableToUseHint;false};

private _radio = call TFAR_fnc_activeSwRadio;

private _additonalChannel = _radio call TFAR_fnc_getAdditionalSwChannel;
if (_additonalChannel < 0) exitWith {false}; //No Additional Channel set
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

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, true, true]] call TFAR_fnc_fireEventHandlers;
private _currentFrequency = [_radio, _additonalChannel + 1] call TFAR_fnc_getChannelFrequency;

private _hintText = format[
                            localize LSTRING(additional_transmit),
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    [_radio, "displayName", ""] call DFUNC(getWeaponConfigProperty),
                                    [_radio, "picture", ""] call DFUNC(getWeaponConfigProperty)
                                    ],
                            _additonalChannel + 1,
                            _currentFrequency
                        ];

private _pluginCommand = format[
                                "TANGENT	PRESSED	%1%2	%3	%4	%5",
                                _currentFrequency,
                                _radio call TFAR_fnc_getSwRadioCode,
                                ([_radio, "tf_range", 0] call DFUNC(getWeaponConfigProperty)) * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                ([_radio, "tf_subtype", ""] call DFUNC(getWeaponConfigProperty)),
                                _radio
                            ];

[_hintText,_pluginCommand, [0,-1] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

TF_tangent_sw_pressed = true;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, true, true]] call TFAR_fnc_fireEventHandlers;
false
