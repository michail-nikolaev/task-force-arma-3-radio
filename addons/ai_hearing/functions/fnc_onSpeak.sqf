#include "script_component.hpp"

/*
    Author(s):
        By Dimitri Yuri edited by 2600K
        Dedmen, Dorbedo

    Description:
        notifies nearby AI's when player is Speaking
*/

params [["_unit", objNull, [objNull]], ["_isSpeaking", false, [true]]];

if ((!local _unit) || {!alive _unit} || {(vehicle _unit) call TFAR_fnc_isVehicleIsolated}) exitWith {};

{
    if (!(isPlayer _x) && 
        {!((vehicle _x) call TFAR_fnc_isVehicleIsolated)} && 
        {_x knowsAbout _unit <= 1.5} && 
        {((_x getVariable [QGVAR(lastReveal), 0]) - CBA_missiontime) < -20}) then {
        
        _x setVariable [QGVAR(lastReveal), CBA_missiontime];
        private _value = linearConversion [0, TF_speak_volume_meters, _unit distance _x, 3.5, 1.5, true];
        
        TRACE_3("Revealing Unit",_unit,_x,_value);

        [QGVAR(reveal), [_x, _unit, _value], _x] call CBA_fnc_targetEvent;
    };
    nil
} count (_unit nearEntities ["CAManBase", TF_speak_volume_meters * 0.9]);
