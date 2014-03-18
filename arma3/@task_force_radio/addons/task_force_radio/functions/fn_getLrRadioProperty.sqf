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
private ["_radio", "_property", "_found", "_result", "_air"];
_radio = _this select 0;
_property = _this select 1;
_found = false;
_result = nil;

if (!(_radio isKindOf "Bag_Base")) then {
	_result = _radio getVariable "TF_RadioType";
	if (isNil "_result") then {
		_result = [typeof _radio, "tf_RadioType"] call TFAR_fnc_getConfigProperty;
		
		if (!isNil "_result" AND {_result != ""}) exitWith {_found = true;};
		_air = (typeof(_radio) isKindOf "Air");
		if ((_radio call TFAR_fnc_getVehicleSide) == west) then {			
			if (_air) then {
				_result = TF_defaultWestAirborneRadio;
			} else {
				_result = TF_defaultWestBackpack;
			};
		} else {
			if ((_radio call TFAR_fnc_getVehicleSide) == east) then {
				if (_air) then {
					_result = TF_defaultEastAirborneRadio;
				} else {
					_result = TF_defaultEastBackpack;
				};				
			} else {
				if (_air) then {
					_result = TF_defaultGuerAirborneRadio;
				} else {
					_result = TF_defaultGuerBackpack;
				};				
			};
		};
	};
	_radio = _result;
} else {
	_radio = typeof _radio;
};
if (_found) exitWith { _result };
[_radio, _property] call TFAR_fnc_getConfigProperty