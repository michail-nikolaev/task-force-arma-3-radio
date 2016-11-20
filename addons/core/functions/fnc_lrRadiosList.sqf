#include "script_component.hpp"

private _result = [];
private _active_lr = nil;
if (!isNil "TF_lr_active_radio") then {
    _active_lr = TF_lr_active_radio;
};
private _vehicle_lr = _this call TFAR_fnc_vehicleLr;

private _backpack_check = {
    _backpack_lr = _this call TFAR_fnc_backpackLr;
    if (count _backpack_lr > 0) then {
        _result pushBack _backpack_lr;
    };
};

if ((!isNil "_active_lr") && {_active_lr isEqualTo _vehicle_lr}) then {
    _result pushBack _active_lr;
    call _backpack_check;
} else {
    call _backpack_check;
    if (count _vehicle_lr > 0) then {
        _result pushBack _vehicle_lr;
    };
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
