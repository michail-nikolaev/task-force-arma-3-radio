/*
 	Name: TFAR_fnc_getDefaultRadioClasses
 	
 	Author(s):
		NKey

 	Description:
		Return array of default radio classes for player. 
	
	Parameters:
		Nothing
 	
 	Returns:
		ARRAY - [defaultLR, defaultPersonal, defaultRifleman, defaultAirborne]
 	
 	Example:
		_classes = call TFAR_fnc_getDefaultRadioClasses;
*/
private ["_personalRadio", "_riflemanRadio", "_lrRadio", "_airborne"];

switch (TFAR_currentUnit call BIS_fnc_objectSide) do {
	case west: {_personalRadio = TF_defaultWestPersonalRadio; _riflemanRadio = TF_defaultWestRiflemanRadio; _lrRadio = TF_defaultWestBackpack; _airborne = TF_defaultWestAirborneRadio;};
	case east: {_personalRadio = TF_defaultEastPersonalRadio; _riflemanRadio = TF_defaultEastRiflemanRadio;_lrRadio = TF_defaultEastBackpack; _airborne = TF_defaultEastAirborneRadio;};
	default {_personalRadio = TF_defaultGuerPersonalRadio; _riflemanRadio = TF_defaultGuerRiflemanRadio;_lrRadio = TF_defaultGuerBackpack; _airborne = TF_defaultGuerAirborneRadio;};
};

TFAR_tryResolveFactionClass = 
{
	private ["_prefix", "_faction", "_result", "_default"];
	_prefix = _this select 0;
	_default = _this select 1;
	_faction = faction TFAR_currentUnit;
	_result = missionNamespace getVariable (_faction + "_" + _prefix + "_tf_faction_radio");
	if (isNil "_result") then {		
		if (isText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"))) then {
			 _result = getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"));
		} else {
			if (isText (configFile >> "CfgFactionClasses" >> _faction >> _prefix + "_tf_faction_radio")) then {
				_result = getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio"));
			} else {
				_result = _default;
			};
		};		
	};
	_result
};

[["backpack", _lrRadio] call TFAR_tryResolveFactionClass , ["personal", _personalRadio] call TFAR_tryResolveFactionClass , ["rifleman", _riflemanRadio] call TFAR_tryResolveFactionClass, ["airborne", _airborne] call TFAR_tryResolveFactionClass];