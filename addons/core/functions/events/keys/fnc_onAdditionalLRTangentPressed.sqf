#include "script_component.hpp"

/*
  Name: TFAR_fnc_onAdditionalLRTangentPressed

  Author: NKey
    Fired when the additional keybinding for LR is pressed.

  Arguments:
    None

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_onAdditionalLRTangentPressed;

  Public: No
*/

if ((TF_tangent_lr_pressed or TF_tangent_sw_pressed) or {!alive TFAR_currentUnit} or {!call TFAR_fnc_haveLRRadio}) exitWith {false};

if (!isMultiplayer) exitWith {_x = localize LSTRING(WM_Singleplayer);systemChat _x;hint _x; false};

if (!call TFAR_fnc_isAbleToUseRadio) exitWith {call TFAR_fnc_unableToUseHint;false};

private _radio = call TFAR_fnc_activeLrRadio;
private _additionalChannel = _radio call TFAR_fnc_getAdditionalLrChannel;
if (_additionalChannel < 0) exitWith {false}; // No Additional Channel set
if (!([_radio] call TFAR_fnc_RadioOn)) exitWith {false};

if !([  TFAR_currentUnit,
        TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside,
        TFAR_currentUnit call TFAR_fnc_eyeDepth
    ] call TFAR_fnc_canUseLRRadio) exitWith {call TFAR_fnc_inWaterHint;false};



["OnBeforeTangent", [TFAR_currentUnit, _radio, 1, true, true]] call TFAR_fnc_fireEventHandlers;

private _currentFrequency = [_radio, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency;

private _hintText = format[
                            localize LSTRING(additional_transmit),
                            format ["%1<img size='1.5' image='%2'/>",
                                    [_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty,
                                    getText(configFile >> "CfgVehicles" >> typeOf (_radio select 0) >> "picture")
                                    ],
                            _additionalChannel + 1,
                            _currentFrequency
                        ];
private _pluginCommand = format[
                                "TANGENT_LR	PRESSED	%1%2	%3	%4	%5",
                                _currentFrequency,
                                _radio call TFAR_fnc_getLrRadioCode,
                                ([_radio select 0, "tf_range"] call TFAR_fnc_getLrRadioProperty)  * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                [_radio select 0, "tf_subtype", "digital_lr"] call TFAR_fnc_getLrRadioProperty,
                                typeOf (_radio select 0)
                            ];

[_hintText, _pluginCommand, [0,-1] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;
TF_tangent_lr_pressed = true;
//				unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 1, true, true]] call TFAR_fnc_fireEventHandlers;
false
