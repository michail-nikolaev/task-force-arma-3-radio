/**
 * Returns side of vehicle, based on model of vehicle, not on who is captured
 * Used for radio model
 * @param vehicle
 * @return side
 */
private ["_result", "_side"];
_side = _this getVariable "tf_side";
if !(isNil "_side") then {
	switch(_side) do {
		case "west": {
			_result = west;
		};
		case "east": {
			_result = east;
		};
		default {
			_result = resistance;
		};
	};
} else {
	_result = [getNumber(configFile >> "CfgVehicles" >> typeOf(_this) >> "side")] call BIS_fnc_sideType;
};
_result