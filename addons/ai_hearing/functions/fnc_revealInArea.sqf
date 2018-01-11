#include "script_component.hpp"

/*
  Name: TFAR_fnc_revealInArea

  Author: Dimitri Yuri, 2600K, Dedmen, Dorbedo
    Event called upon receving a radio call

  Arguments:
    0: unit to be revealed <OBJECT>
    1: distance <OBJECT|ARRAY>

  Return Value:
    None
  
  Example:
    [_unit, 50] call TFAR_ai_hearing_fnc_revealInArea;
  
  Public: Yes
 */

params [["_unit", objNull, [objNull, []]], ["_distance", 5, [0]]];
TRACE_2(_unit,_distance);
{
    if (!(isPlayer _x) &&
        {!((vehicle _x) call TFAR_fnc_isVehicleIsolated)} &&
        {_x knowsAbout _unit <= 1.5} &&
        {((_x getVariable [QGVAR(lastReveal), 0]) - CBA_missiontime) < -20}) then {

        _x setVariable [QGVAR(lastReveal), CBA_missiontime];
        private _value = linearConversion [0, _distance, _unit distance _x, 3.5, 1.5, true];

        TRACE_3("Revealing Unit",_unit,_x,_value);

        [QGVAR(reveal), [_x, _unit, _value], _x] call CBA_fnc_targetEvent;
    };
    nil
} count (_unit nearEntities ["CAManBase", _distance * 0.95]);
