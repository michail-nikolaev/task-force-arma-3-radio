/*
 	Name: TFAR_fnc_getLrRadioProperty
 	
 	Author(s):
		L-H
 	
 	Description:
 	
 	Parameters: 
 	0: OBJECT - Backpack/vehicle
	1: STRING - Property name
 	
 	Returns:
	NUMBER - Value of property
 	
 	Example:
	[(vehicle player), "TF_hasLRradio"] call TFAR_fnc_getLrRadioProperty;
*/
private ["_radio", "_property"];
_radio = _this select 0;
_property = _this select 1;

if (!(_radio isKindOf "Bag_Base")) then
{
	private "_actualRadio";
	_actualRadio = _radio getVariable "TF_RadioType";
	if (isNil "_actualRadio") then
	{
		_actualRadio = [typeof _radio, _property] call TFAR_fnc_getConfigProperty;
		if (!isNil "_actualRadio" AND {_actualRadio != ""}) exitWith { _actualRadio };
		
		if ((_radio call TFAR_fnc_getVehicleSide) == west) then {
			_actualRadio = TF_defaultWestBackpack;
		} else {
			if ((_radio call TFAR_fnc_getVehicleSide) == east) then {
				_actualRadio = TF_defaultEastBackpack;
			} else {
				_actualRadio = TF_defaultGuerBackpack;
			};
		};
	};
	_radio = _actualRadio;
}
else
{
	_radio = typeof _radio;
};

[_radio, _property] call TFAR_fnc_getConfigProperty