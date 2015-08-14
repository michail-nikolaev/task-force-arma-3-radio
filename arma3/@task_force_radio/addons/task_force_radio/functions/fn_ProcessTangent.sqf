/*
 	Name: TFAR_fnc_ProcessTangent
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Called when tangent is released.
	
	Parameters:
		0: STRING - Hint text
		1: STRING - Request string
		(Optional)2: NUMBER  - Hint display time
 	
 	Returns:
		Nothing
 	
 	Example:
		_hintText = format[localize "STR_transmit_end",format ["%1<img size='1.5' image='%2'/>",[_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty, getText(configFile >> "CfgVehicles" 
			>> typeof (_radio select 0) >> "picture")],(_radio call TFAR_fnc_getLrChannel) + 1, call TFAR_fnc_currentLRFrequency];	
		_request = format["TANGENT_LR	RELEASED	%1%2	%3	%4", call TFAR_fnc_currentLRFrequency, (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrRadioCode, ([_radio select 0, "tf_range"]
			call TFAR_fnc_getLrRadioProperty) * (call TFAR_fnc_getTransmittingDistanceMultiplicator), [_radio select 0, "tf_subtype"] call TFAR_fnc_getLrRadioProperty];
		
		[_hintText, _request] call TFAR_fnc_ProcessTangent;
*/
private "_timer";
_timer = 2.5;
if ((count _this) == 3) then{
	_timer = _this select 2;
};
[parseText (_this select 0), _timer] call TFAR_fnc_showHint;
if (isMultiplayer) then {
	"task_force_radio_pipe" callExtension (_this select 1);
};