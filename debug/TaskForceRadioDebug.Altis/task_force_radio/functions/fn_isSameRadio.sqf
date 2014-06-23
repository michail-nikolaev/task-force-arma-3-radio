/*
 	Name: TFAR_fnc_isSameRadio
 	
 	Author(s):
		L-H
 	
 	Description:
		Checks whether the two passed radios have the same prototype radio
 	
 	Parameters:
		0: STRING - radio classname
		1: STRING - radio classname
 	
 	Returns:
		BOOLEAN - same parent radio
 	
 	Example:
		if([(call TFAR_fnc_activeSwRadio),"tf_fadak"] call TFAR_fnc_isSameRadio) then {
			hint "same parent radio";
		};
*/
private ["_radio1", "_radio2"];
_radio1 = _this select 0;
_radio2 = _this select 1;

if !(_radio1 call TFAR_fnc_isPrototypeRadio) then {
	_radio1 = configName inheritsFrom (configFile >> "CfgWeapons" >> _radio1);
};
if !(_radio2 call TFAR_fnc_isPrototypeRadio) then {
	_radio2 = configName inheritsFrom (configFile >> "CfgWeapons" >> _radio2);
};

(_radio2 == _radio1)