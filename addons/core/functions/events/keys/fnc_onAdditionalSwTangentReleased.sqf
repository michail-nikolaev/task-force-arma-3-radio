#include "script_component.hpp"

/*
    Name: TFAR_fnc_onAdditionalSwTangentReleased

    Author(s):
        NKey

    Description:
        Fired when the additional keybinding for SW is released.

    Parameters:

    Returns:
        BOOLEAN

    Example:
        call TFAR_fnc_onAdditionalSwTangentReleased;
*/


if ((!TF_tangent_sw_pressed) or {!alive TFAR_currentUnit}) exitWith {true};
private _radio = call TFAR_fnc_activeSwRadio;

private _additonalChannel = _radio call TFAR_fnc_getAdditionalSwChannel;
if (_additonalChannel < 0) exitWith {true}; //No Additional Channel set

["OnBeforeTangent", [TFAR_currentUnit, _radio, 0, true, false]] call TFAR_fnc_fireEventHandlers;

private _currentFrequency = [_radio, _additonalChannel + 1] call TFAR_fnc_getChannelFrequency;

private _hintText = format[
                            localize "STR_additional_transmit_end",
                            format [
                                    "%1<img size='1.5' image='%2'/>",
                                    getText (configFile >> "CfgWeapons" >> _radio >> "displayName"),
                                    getText (configFile >> "CfgWeapons"  >> _radio >> "picture")
                                ],
                            _additonalChannel + 1,
                            _currentFrequency
                        ];

private _pluginCommand = format[
                                "TANGENT	RELEASED	%1%2	%3	%4",
                                _currentFrequency,
                                _radio call TFAR_fnc_getSwRadioCode,
                                getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range") * (call TFAR_fnc_getTransmittingDistanceMultiplicator),
                                getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")
                            ];

[_hintText,_pluginCommand] call TFAR_fnc_processTangent;

TF_tangent_sw_pressed = false;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, _radio, 0, true, false]] call TFAR_fnc_fireEventHandlers;

true
