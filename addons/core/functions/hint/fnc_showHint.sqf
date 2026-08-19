#include "script_component.hpp"

/*
  Name: TFAR_fnc_showHint

  Author: Garth de Wet (L-H)
    Displays a hint at the bottom right of the screen.

  Arguments:
    0: structured text to display <TEXT>
    1:  Time to display the hint (-1 for infinite) <SCALAR>

  Return Value:
    None

  Example:
    [parseText "Hello", 3] call TFAR_fnc_showHint;
    [parseText "Hello", -1] call TFAR_fnc_showHint;

  Public: Yes
*/

params ["_text", "_time"];
if (_time == 0) exitWith {};

if (isNull (uiNamespace getVariable ["TFAR_Hint_Display", displayNull])) then {
    ("TFAR_HintLayer" call BIS_fnc_rscLayer) cutRsc["RscTaskForceHint", "PLAIN",0,true];
};
private _control = (uiNamespace getVariable ["TFAR_Hint_Display", displayNull]) displayCtrl 1100;
_control ctrlSetStructuredText _text;

// Keep multiline hints fully visible while preserving the original bottom-right anchor.
private _position = ctrlPosition _control;
private _height = (ctrlTextHeight _control) max (0.1 * safezoneH);
_position set [1, safezoneY + safezoneH - _height];
_position set [3, _height];
_control ctrlSetPosition _position;
_control ctrlCommit 0;

if !(isNil "TF_HintFnc") then {
    terminate TF_HintFnc;
};
if (_time == -1) exitWith {};

TF_HintFnc = [_time] spawn {
    sleep (_this select 0);
    call TFAR_fnc_hideHint;
};

nil;
