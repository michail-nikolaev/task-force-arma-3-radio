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

<<<<<<< HEAD
if (isNull (uiNamespace getVariable ["TFAR_Hint_Display", displayNull])) then {
=======
if (isNull (uiNamespace getVariable ["TFAR_Hint_Display", displayNull])) then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	("TFAR_HintLayer" call BIS_fnc_rscLayer) cutRsc["RscTaskForceHint", "PLAIN",0,true];
};
((uiNamespace getVariable ["TFAR_Hint_Display", displayNull]) displayCtrl 1100) ctrlSetStructuredText _text;

<<<<<<< HEAD
if !(isNil "TF_HintFnc") then {
=======
if !(isNil "TF_HintFnc") then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	terminate TF_HintFnc;
};
if (_time == -1) exitWith {};

TF_HintFnc = [_time] spawn {
	sleep (_this select 0);
	call TFAR_fnc_HideHint;
};