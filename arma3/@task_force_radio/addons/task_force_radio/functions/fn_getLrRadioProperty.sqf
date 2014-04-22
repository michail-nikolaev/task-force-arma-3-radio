/*
 	Name: TFAR_fnc_getLrRadioProperty
 	
 	Author(s):
		L-H
 	
 	Description:
 	
 	Parameters: 
 	0: OBJECT - Backpack/vehicle
	1: STRING - Property name
 	
 	Returns:
	NUMBER or TEXT- Value of property
 	
 	Example:
	[(vehicle player), "TF_hasLRradio"] call TFAR_fnc_getLrRadioProperty;
*/
private ["_radio", "_property", "_result", "_air"];
_radio = _this select 0;
_property = _this select 1;
_result = _radio getVariable _property;

if (isNil "_result") then {
	if (!(_radio isKindOf "Bag_Base")) then {
		if (isNumber (ConfigFile >> "CfgVehicles" >> (typeof _radio) >> _property) 
		    or {isText (configFile >> "CfgVehicles" >> (typeof _radio) >> _property)}
		    or {isNumber (ConfigFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
		    or {isText (ConfigFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
		    ) exitWith {
			_radio = typeof _radio;
		    };
		_result = _radio getVariable "TF_RadioType";
		if (isNil "_result") then {
			_result = [typeof _radio, "tf_RadioType"] call TFAR_fnc_getConfigProperty;
			
			if (!isNil "_result" AND {_result != ""}) exitWith {};
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
	_result = [_radio, _property] call TFAR_fnc_getConfigProperty;
};

_result
