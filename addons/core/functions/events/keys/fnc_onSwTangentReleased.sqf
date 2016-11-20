#include "script_component.hpp"

if ((!TF_tangent_sw_pressed) or {!alive TFAR_currentUnit}) exitWith {true};
private _radio = call TFAR_fnc_activeSwRadio;

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers;

private _currentFrequency = call TFAR_fnc_currentSWFrequency;
private _hintText = format[
                            localize "STR_transmit_end",
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    getText (configFile >> "CfgWeapons" >> _radio >> "displayName"),
                                    getText(configFile >> "CfgWeapons"  >> _radio >> "picture")
                                ],
                            (_radio call TFAR_fnc_getSwChannel) + 1,
                            _currentFrequency
                        ];

private _pluginCommand = format[
                                "TANGENT	RELEASED	%1%2	%3	%4",
                                _currentFrequency,
                                (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode,
                                getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range") * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")
                            ];

[_hintText,_pluginCommand] call TFAR_fnc_processTangent;

TF_tangent_sw_pressed = false;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, false, false]] call TFAR_fnc_fireEventHandlers;

true
