/*
 	Name: TFAR_fnc_isForcedCurator
 	
 	Author(s):
		Nkey

 	Description:
		Return if unit if forced curator.
	
	Parameters:
		OBJECT: unit to check
 	
 	Returns:
		BOOLEN: is unit forced curator
 	
 	Example:
		player call TFAR_fnc_isForcedCurator;
*/
private ["_result"];
_result = _this getVariable "tf_forcedCurator";
if (isNil "_result") then {
	_result = ((typeof _this) == "VirtualCurator_F") || ([configFile >> "CfgVehicles" >> (typeof _this), configFile >> "CfgVehicles" >> "VirtualCurator_F"] call CBA_fnc_inheritsFrom);
	_this setVariable ["tf_forcedCurator", _result];
};
 _result