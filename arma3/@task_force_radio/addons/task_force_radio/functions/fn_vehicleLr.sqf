private ["_result"];
_result = [];
if (((vehicle player) != player) and {(vehicle player) call TFAR_fnc_hasVehicleRadio}) then {
	if (gunner (vehicle player) == player) then {
		_result = [vehicle player, "gunner_radio_settings"];
	};
	if (driver (vehicle player) == player) then {
		_result = [vehicle player, "driver_radio_settings"];
	};
	if (commander (vehicle player) == player) then {
		_result = [vehicle player, "commander_radio_settings"];
	};
	if ((vehicle player) turretUnit [0] == player) then {
		_result = [vehicle player, "turretUnit_0_radio_setting"];
	};
};
_result