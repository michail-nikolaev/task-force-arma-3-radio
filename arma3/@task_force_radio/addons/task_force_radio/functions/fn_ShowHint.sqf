/*
 	Name: TFAR_fnc_ShowHint
 	
 	Author(s):
		L-H
 	
 	Description:
	Displays a hint at the bottom right of the screen.
 	
 	Parameters: 
 	0: STRING - Text to display
	1: Number - Time to display the hint (-1 for infinite)
 	
 	Returns:
	Nothing
 	
 	Example:
	["Hello", 3] call TFAR_fnc_ShowHint;
	["Hello", -1] call TFAR_fnc_ShowHint;
 */
private ["_text","_time"];
_text = _this select 0;
_time = _this select 1;

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
	call TFAR_fnc_HideHint;
};