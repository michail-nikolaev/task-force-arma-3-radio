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
		ARRAY:
			0 - Object - Vehicle
			1 - String - Radio Settings ID
 	
 	Example:
		_radio = call TFAR_fnc_VehicleLR;
 */
private ["_result"];
_result = [];
if (((vehicle player) != player) and {(vehicle player) call TFAR_fnc_hasVehicleRadio}) then {
	switch (player) do {
		case (gunner (vehicle player)): {
			_result = [vehicle player, "gunner_radio_settings"];
		};
		case (driver (vehicle player)): {
			_result = [vehicle player, "driver_radio_settings"];
		};
		case (commander (vehicle player)): {
			_result = [vehicle player, "commander_radio_settings"];
		};
		case ((vehicle player) turretUnit [0]): {
			_result = [vehicle player, "turretUnit_0_radio_setting"];
		};
	};
};
_result