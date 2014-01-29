private ["_result", "_active_lr", "_vehicle_lr", "_backpack_lr"];
_result = [];
_active_lr = nil;
if (!isNil "lr_active_radio") then {
	_active_lr = lr_active_radio;
};
_vehicle_lr = call TFAR_fnc_vehicleLr;
_backpack_lr = call TFAR_fnc_backpackLr;

if (!(isNil "_active_lr") and {(count _vehicle_lr > 0)} and {(_active_lr select 0) == (_vehicle_lr select 0)} and {(_active_lr select 1) == (_vehicle_lr select 1)}) then {
	_result set [count _result, _active_lr];
	if (count _backpack_lr > 0) then {
		_result set [count _result, _backpack_lr];
	};
} else {
	if (count _backpack_lr > 0) then {
		_result set [count _result, _backpack_lr];
	};
	if (count _vehicle_lr > 0) then {
		_result set [count _result, _vehicle_lr];
	};
};

_result