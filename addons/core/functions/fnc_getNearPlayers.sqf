#include "script_component.hpp"

/*
  Name: TFAR_fnc_getNearPlayers

  Author: NKey, Garth de Wet (L-H), Dedmen
    returns near players

  Arguments:
    None

  Return Value:
    near players (Contains duplicates) <ARRAY>

  Example:
    call TFAR_fnc_getNearPlayers;

  Public: No
*/

if ((!alive TFAR_currentUnit) && {!(TFAR_currentUnit getVariable ["TFAR_forceSpectator",false])}) exitWith {[]};

private _unitsInPlayerGroup = units (group TFAR_currentUnit);
private _allUnits = (TFAR_currentUnit nearEntities ["Man", TF_max_voice_volume+40]);//+40 because he won't be updated fast enough when coming into region

//Some missions might have everyone in the same group. In that case we don't want to flood nearPlayers
if (count _unitsInPlayerGroup < 10) then {
    _allUnits append _unitsInPlayerGroup;
};

_allUnits pushBackUnique TFAR_currentUnit;//Will be duplicate in normal play but in spectator the group units will be missing

{
    _allUnits append (crew _x);
} forEach (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_max_voice_volume+40]);


//We have duplicates in here. But fnc_processPlayerPositions takes care of them.
_allUnits select {((isPlayer _x) && (alive _x)) || {_x getVariable ["TFAR_forceSpectator",false]}}