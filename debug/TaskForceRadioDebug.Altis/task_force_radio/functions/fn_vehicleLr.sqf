/*
 	Name: TFAR_fnc_VehicleLR
 	
 	Author(s):
		NKey
 	
 	Description:
		Gets the LR radio of the vehicle and the settings for it depending on the player's
		position within the vehicle
 	
 	Parameters: 
		0: Object - unit
 	
 	Returns:
		ARRAY: 0 - Object - Vehicle, 1 - String - Radio Settings ID
 	
 	Example:
		_radio = player call TFAR_fnc_VehicleLR;
 */
private ["_result"];
_result = [];
if (((vehicle _this) != _this) and {(vehicle _this) call TFAR_fnc_hasVehicleRadio}) then {
	switch (_this) do {
		case (gunner (vehicle _this)): {
			_result = [vehicle _this, "gunner_radio_settings"];
		};
		case (driver (vehicle _this)): {
			_result = [vehicle _this, "driver_radio_settings"];
		};
		case (commander (vehicle _this)): {
			_result = [vehicle _this, "commander_radio_settings"];
		};
		case ((vehicle _this) turretUnit [0]): {
			_result = [vehicle _this, "turretUnit_0_radio_setting"];
		};
	};
};
_result