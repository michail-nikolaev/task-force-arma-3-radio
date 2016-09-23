/*
 	Name: TFAR_fnc_isVehicleIsolated
 	
 	Author(s):
		NKey

 	Description:
		Checks whether the vehicle is isolated.
	
	Parameters:
		OBJECT - The vehicle
 	
 	Returns:
		BOOLEAN
 	
 	Example:
		_isolated = (vehicle player) call TFAR_fnc_isVehicleIsolated;
*/
private ["_isolated"];

_isolated = [(typeof _this), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty;

_isolated > 0.5