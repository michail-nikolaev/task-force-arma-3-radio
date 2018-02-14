#include "script_component.hpp"

/*
  Name: TFAR_fnc_getNearPlayers
 
  Author: NKey, Garth de Wet (L-H), Dedmen
    returns near players

  Arguments:
    None

  Return Value:
    near players <ARRAY>

  Example:
    call TFAR_fnc_getNearPlayers;

  Public: No
 */

if ((!alive TFAR_currentUnit) && {!(TFAR_currentUnit getVariable ["TFAR_forceSpectator",false])}) exitWith {[]};

private _players_in_group = count (units (group TFAR_currentUnit));
private _result = [];

private _allUnits = (TFAR_currentUnit nearEntities ["Man", TF_max_voice_volume+40]);//+40 because he won't be updated fast enough when coming into region

if (_players_in_group < 10) then {
    _allUnits append (units (group TFAR_currentUnit));
};

_allUnits pushBackUnique TFAR_currentUnit;//Will be duplicate in normal play but in spectator the group units will be missing

{
    _allUnits append (crew _x);
    true
} count  (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_max_voice_volume+40]);

{
    if (((isPlayer _x) and (alive _x)) or {_x getVariable ["TFAR_forceSpectator",false]}) then {
        _result pushBackUnique _x;
    };
    true
} count _allUnits;

(_result arrayIntersect _result) //prevents duplicates that can happen due to the usage of append
