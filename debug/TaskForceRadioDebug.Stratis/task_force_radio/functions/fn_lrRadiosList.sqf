private ["_result", "_active_lr", "_vehicle_lr", "_backpack_lr", "_backpack_check", "_vehicle_check"];
_result = [];
_active_lr = nil;
if (!isNil "TF_lr_active_radio") then {
	_active_lr = TF_lr_active_radio;
};
_vehicle_lr = call TFAR_fnc_vehicleLr;
_backpack_lr = call TFAR_fnc_backpackLr;

_backpack_check = {
	if (count _backpack_lr > 0) then {
		_result set [count _result, _backpack_lr];
	};
};

_vehicle_check = {
	if (count _vehicle_lr > 0) then {
		_result set [count _result, _vehicle_lr];
	};
};

if (!(isNil "_active_lr") and (count _vehicle_lr > 0) and ((_active_lr select 0) == (_vehicle_lr select 0)) and ((_active_lr select 1) == (_vehicle_lr select 1))) then {
	_result set [count _result, _active_lr];
	call _backpack_check;
} else {
	call _backpack_check;
	call _vehicle_check;
};

_result