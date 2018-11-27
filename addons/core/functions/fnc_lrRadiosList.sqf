#include "script_component.hpp"

/*
  Name: TFAR_fnc_lrRadiosList

  Author: NKey
    List of all the players LR radios

  Arguments:
    unit <OBJECT>

  Return Value:
    List of all the player's LR radios <ARRAY>

  Example:
    _radios = TFAR_currentUnit call TFAR_fnc_LRRadiosList;

  Public: Yes
*/


private _backpackLR = (_this call TFAR_fnc_backpackLr); 
private _activeLR = missionNamespace getVariable ["TF_lr_active_radio", _backpackLR];
private _overrideLR = missionNamespace getVariable ["TFAR_OverrideActiveLRRadio", _activeLR];
private _vehicleLR = _this call TFAR_fnc_vehicleLr;


private _result = [];

_result pushBackUnique _overrideLR; //This is either override or active
_result pushBackUnique _activeLR; //This is either active or backpack
_result pushBackUnique _backpackLR; //if active one was already backpack, this will do nothing
if (!isNil "_vehicleLR") then {_result pushBackUnique _vehicleLR};

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

//If Player is remote Controlling return Player and controlled Unit's radios.
if (_this isEqualTo TFAR_currentUnit && {player != TFAR_currentUnit}) exitWith {
        _result + (player call TFAR_fnc_LRRadiosList);
};


_result
