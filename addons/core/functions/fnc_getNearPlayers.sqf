#include "script_component.hpp"

if (!alive TFAR_currentUnit) exitWith {[]};

private _players_in_group = count (units (group TFAR_currentUnit));
private _result = [];

private _allUnits = TFAR_currentUnit nearEntities ["Man", TF_max_voice_volume+40];//+40 because he won't be updated fast enough when coming into region

if (_players_in_group < 10) then {
    {
        if (_x != TFAR_currentUnit) then {
            _allUnits pushBack _x;
        };
        true;
    } count (units (group TFAR_currentUnit));
};

{
    private _v = _x;
    {
        _allUnits pushBack _x;
        true
    } count (crew _v);
    true
} count  (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_max_voice_volume+40]);

{
    if ((isPlayer _x) and {alive _x}) then {
        if (!(_x getVariable ["tf_forceSpectator",false])) then {
            _result pushBack _x;
        };
    };
    true;
} count _allUnits;

_result
