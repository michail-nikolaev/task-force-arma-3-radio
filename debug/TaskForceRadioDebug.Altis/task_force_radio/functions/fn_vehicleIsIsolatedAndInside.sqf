private ["_result"];
_result = false;
if (vehicle _this != _this) then {
	if ((vehicle _this) call TFAR_fnc_isVehicleIsolated) then {
		if !([_this] call CBA_fnc_isTurnedOut) then {
			_result = true;
		};
	};
};
_result