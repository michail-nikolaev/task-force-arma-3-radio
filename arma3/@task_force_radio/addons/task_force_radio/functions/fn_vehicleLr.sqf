/*
 	Name: TFAR_fnc_VehicleLR
 	
 	Author(s):
		NKey
 	
 	Description:
		Gets the LR radio of the vehicle and the settings for it depending on the player's
		position within the vehicle
 	
 	Parameters: 
		Nothing
 	
 	Returns:
		ARRAY: 0 - Object - Vehicle, 1 - String - Radio Settings ID
 	
 	Example:
		_radio = call TFAR_fnc_VehicleLR;
 */
private ["_result"];
_result = [];
if (((vehicle currentUnit) != currentUnit) and {(vehicle currentUnit) call TFAR_fnc_hasVehicleRadio}) then {
	switch (currentUnit) do {
		case (gunner (currentUnit)): {
			_result = [vehicle currentUnit, "gunner_radio_settings"];
		};
		case (driver (vehicle currentUnit)): {
			_result = [vehicle currentUnit, "driver_radio_settings"];
		};
		case (commander (vehicle currentUnit)): {
			_result = [vehicle currentUnit, "commander_radio_settings"];
		};
		case ((vehicle currentUnit) turretUnit [0]): {
			_result = [vehicle currentUnit, "turretUnit_0_radio_setting"];
		};
	};
};
_result