/*
 	Name: TFAR_fnc_vehicleIsIsolatedAndInside
 	
 	Author(s):
		NKey
 	
 	Description:
		Checks whether a unit is in an isolated vehicle and not turned out.
 	
 	Parameters: 
		0: OBJECT - The unit to check.
 	
 	Returns:
		BOOLEAN - True if isolated and not turned out, false if turned out or vehicle is not isolated.
 	
 	Example:
		_isolated = player call TFAR_fnc_vehicleIsIsolatedAndInside;
*/
private ["_result"];
_result = false;
if (vehicle _this != _this) then {
	if ((vehicle _this) call TFAR_fnc_isVehicleIsolated) then {
		if !([_this] call TFAR_fnc_isTurnedOut) then {
			_result = true;
		};
	};
};
_result