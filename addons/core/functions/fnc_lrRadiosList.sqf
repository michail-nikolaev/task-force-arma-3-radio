#include "script_component.hpp"

private _result = [];
private _active_lr = missionNamespace getVariable ["TF_lr_active_radio",objNull];

private _vehicle_lr = _this call TFAR_fnc_vehicleLr;

if ((!isNil "_active_lr") && {_active_lr isEqualTo _vehicle_lr}) then {//No! isEqualTo doesn't crash when presented a nil variable ;)
    _result pushBack _active_lr;
    _result pushBack (_this call TFAR_fnc_backpackLr);
} else {
    _result pushBack (_this call TFAR_fnc_backpackLr);
    _result pushBack _vehicle_lr;
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
