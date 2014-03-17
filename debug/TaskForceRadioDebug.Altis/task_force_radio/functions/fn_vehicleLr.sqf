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