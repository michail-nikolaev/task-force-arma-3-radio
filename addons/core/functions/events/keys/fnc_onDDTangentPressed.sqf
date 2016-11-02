#include "script_component.hpp"

/*
    Name: TFAR_fnc_onDDTangentPressed

    Author(s):
        NKey

    Description:
        Fired when the keybinding for DD is pressed.

    Parameters:

    Returns:
        BOOLEAN

    Example:
        call TFAR_fnc_onDDTangentPressed;
*/
if (time - TF_last_dd_tangent_press < 0.1) exitWith {TF_last_dd_tangent_press = time;true};
TF_last_dd_tangent_press = time;

if ((TF_tangent_dd_pressed) or {!alive TFAR_currentUnit} or {!call TFAR_fnc_haveDDRadio}) exitWith {true};
if (!call TFAR_fnc_isAbleToUseRadio) exitWith {call TFAR_fnc_onGroundHint;true};


if !([
        TFAR_currentUnit call TFAR_fnc_eyeDepth,
        TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside
    ] call TFAR_fnc_canUseDDRadio) exitWith {call TFAR_fnc_unableToUseHint;true};

["OnBeforeTangent", [TFAR_currentUnit, "DD", 2, false, true]] call TFAR_fnc_fireEventHandlers;

[
    format[localize "STR_transmit", "DD", "1", TF_dd_frequency],
    format["TANGENT_DD	PRESSED	%1	0	dd	dd", TF_dd_frequency],
    -1
] call TFAR_fnc_processTangent;

TF_tangent_dd_pressed = true;
//						unit, radio, radioType, additional, buttonDown
["OnTangent", [TFAR_currentUnit, "DD", 2, false, true]] call TFAR_fnc_fireEventHandlers;
true
