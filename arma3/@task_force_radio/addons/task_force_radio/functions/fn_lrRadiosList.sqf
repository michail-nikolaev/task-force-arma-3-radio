private ["_result", "_active_lr", "_vehicle_lr", "_backpack_lr", "_backpack_check", "_vehicle_check"];
_result = [];
_active_lr = nil;
if (!isNil "TF_lr_active_radio") then {
	_active_lr = TF_lr_active_radio;
};
_vehicle_lr = _this call TFAR_fnc_vehicleLr;

_backpack_check = {
	_backpack_lr = _this call TFAR_fnc_backpackLr;
	if (count _backpack_lr > 0) then {
		_result set [count _result, _backpack_lr];
	};
};

_vehicle_check = {
	if (count _this > 0) then {
		_result set [count _result, _this];
	};
};

if (!(isNil "_active_lr") and {count _vehicle_lr > 0} and {(_active_lr select 0) == (_vehicle_lr select 0)} and {(_active_lr select 1) == (_vehicle_lr select 1)}) then {
	_result set [count _result, _active_lr];
	call _backpack_check;
} else {
	call _backpack_check;
	_vehicle_lr call _vehicle_check;
};

if ((player call TFAR_fnc_isForcedCurator) and {TFAR_currentUnit == player}) then {
	if !(isNil "TF_curator_backpack_1") then {
		_result pushBack [TF_curator_backpack_1, "TF_curatorBackPack"];
	};
	if !(isNil "TF_curator_backpack_2") then {
		_result pushBack [TF_curator_backpack_2, "TF_curatorBackPack"];
	};
	if !(isNil "TF_curator_backpack_3") then {
		_result pushBack [TF_curator_backpack_3, "TF_curatorBackPack"];
	};
};

_result