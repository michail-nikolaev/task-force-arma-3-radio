#include "script_component.hpp"

/*
  Name: TFAR_fnc_doLRTransmit

  Author: Dedmen, NKey
    Start a LR Transmission manually, this is internal function.
    This doesn't contain human factor checks like 500ms delay between pressdown,
    singleplayer mode or transmitting on multiple radios simultaniously.
    Also doesn't check that channel matches frequency or that either match the specific radio.
    It also doesn't handle some variables that are required to stop the transmission via hotkey.

  Arguments:
    0: Radio <ARRAY>
    1: Radio channel <NUMBER>
    2: Radio frequency <STRING>
    3: Is Additional Channel <BOOL>

  Return Value:
    None

  Example:
   [_radio, _channel, _currentFrequency, false] call TFAR_fnc_doLRTransmit;

  Public: No
*/

params ["_radio", "_channel", "_frequency", "_additional"];

if (!([_radio] call TFAR_fnc_RadioOn)) exitWith {false};

if !([  TFAR_currentUnit,
        TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside,
        TFAR_currentUnit call TFAR_fnc_eyeDepth
    ] call TFAR_fnc_canUseLRRadio) exitWith {call TFAR_fnc_inWaterHint;false};

["OnBeforeTangent", [TFAR_currentUnit, _radio, 1, _additional, true]] call TFAR_fnc_fireEventHandlers;



private _hintText = format[
                            localize ([LSTRING(transmit), LSTRING(additional_transmit)] select _additional),
                            format ["%1<img size='1.5' image='%2'/>",
                                    ([_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty) select [0, MAX_RADIONAME_LEN],
                                    getText(configFile >> "CfgVehicles" >> typeOf (_radio select 0) >> "picture")
                                    ],
                            _channel + 1,
                            _frequency
                        ];
private _pluginCommand = format[
                                "TANGENT_LR	PRESSED	%1%2	%3	%4	%5",
                                _frequency,
                                _radio call TFAR_fnc_getLrRadioCode,
                                ([_radio select 0, "tf_range"] call TFAR_fnc_getLrRadioProperty)  * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                [_radio select 0, "tf_subtype", "digital_lr"] call TFAR_fnc_getLrRadioProperty,
                                typeOf (_radio select 0)
                            ];

[_hintText, _pluginCommand, [0,-1] select TFAR_showTransmittingHint] call TFAR_fnc_processTangent;

//				unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 1, _additional, true]] call TFAR_fnc_fireEventHandlers;
