#include "script_component.hpp"

/*
    Name: TFAR_fnc_showHint

    Author(s):
        L-H

    Description:
        Displays a hint at the bottom right of the screen.

    Parameters:
        0: Structured Text - Text to display
        1: Number - Time to display the hint (-1 for infinite)

    Returns:
        Nothing

    Example:
        [parseText "Hello", 3] call TFAR_fnc_showHint;
        [parseText "Hello", -1] call TFAR_fnc_showHint;
 */

params ["_text", "_time"];
if (_time == 0) exitWith {};

if (isNull (uiNamespace getVariable ["TFAR_Hint_Display", displayNull])) then {
    ("TFAR_HintLayer" call BIS_fnc_rscLayer) cutRsc["RscTaskForceHint", "PLAIN",0,true];
};
((uiNamespace getVariable ["TFAR_Hint_Display", displayNull]) displayCtrl 1100) ctrlSetStructuredText _text;

if !(isNil "TF_HintFnc") then {
    terminate TF_HintFnc;
};
if (_time == -1) exitWith {};

TF_HintFnc = [_time] spawn {
    sleep (_this select 0);
    call TFAR_fnc_hideHint;
};

nil;
