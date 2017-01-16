#include "script_component.hpp"

/*
    Name: TFAR_fnc_lrRadiosList

    Author(s):
        NKey

    Description:
        List of all the player's LR radios.

    Parameters:
        0: OBJECT: unit

    Returns:
        ARRAY - List of all the player's LR radios.

    Example:
        _radios = TFAR_currentUnit call TFAR_fnc_LRRadiosList;
*/


private _result = [];
private _active_lr = missionNamespace getVariable ["TF_lr_active_radio",objNull];

private _vehicle_lr = [_this call TFAR_fnc_vehicleLr];

//I know that stuff with param is ugly hackerino stuff... But It's still faster than isNil or count check that was done before

if (_active_lr isEqualTo (_vehicle_lr param [0,scriptNull])) then {//No! isEqualTo doesn't crash when presented a nil variable ;)
    _result pushBack _active_lr;
    _result pushBack (_this call TFAR_fnc_backpackLr);
} else {
    _result pushBack (_this call TFAR_fnc_backpackLr);
    _result pushBack (_vehicle_lr param [0,nil]);
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
