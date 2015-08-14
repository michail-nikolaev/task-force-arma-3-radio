/*
 	Name: TFAR_fnc_VehicleLR
 	
 	Author(s):
		NKey
 	
 	Description:
		Gets the LR radio of the vehicle and the settings for it depending on the player's
		position within the vehicle
 	
 	Parameters: 
<<<<<<< HEAD
		0: Object - unit
=======
		Nothing
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Returns:
		ARRAY: 0 - Object - Vehicle, 1 - String - Radio Settings ID
 	
 	Example:
<<<<<<< HEAD
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
=======
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
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
		};
	};
};
_result