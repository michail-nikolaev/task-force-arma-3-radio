#include "script_component.hpp"

/*
 * Name: TFAR_ai_hearing_fnc_onSpeak
 *
 * Author: Dimitri Yuri, 2600K, Dedmen, Dorbedo
 * notifies nearby AI's when player is Speaking
 *
 * Arguments:
 * 0: the unit <OBJECT>
 * 1: is speaking <BOOL>
 *
 * Return Value:
 * None
 *
 * Example:
 * [_unit, true] call TFAR_ai_hearing_fnc_onSpeak;
 *
 * Public: Yes
 */

#include "script_component.hpp"

params [["_unit", objNull, [objNull]], ["_isSpeaking", false, [true]]];
#ifdef DEBUG_MODE_FULL
    systemChat format["TFAR OnSpeak %1 %2",_unit,_isSpeaking];
#endif
// Exit if unit is isolated or DC'd or dead

if ((!local _unit) || {!alive _unit} || {(vehicle _unit) call TFAR_fnc_isVehicleIsolated}) exitWith {};

private _nearHostiles = _unit nearEntities [["Car", "Motorcycle", "Tank", "CAManBase", "Man"], TF_speak_volume_meters - 5];//-5 because Enemies don't have that good hearing

{
    //could use TFAR_speakingSince to see how long player is speaking and increase reveal according to that


    if (!(isPlayer _x) && {!isNull _x} && {!((vehicle _x) call TFAR_fnc_isVehicleIsolated)} && {_x knowsAbout _unit <= 1.5}) then {
        //#TODO the farther away the unit is the lower reveal it should have
        [_x,[_unit,1.5]] remoteExec ["reveal", _x];
        #ifdef DEBUG_MODE_FULL
            systemChat format["TFAR Revealing %1 to %2 (%3).",_unit,_x,_x knowsAbout _unit];
        #endif
    };
    true
} count _nearHostiles;


/*
This will also be revealing the Player if he stops Speaking.
But as this script only triggers on start and end and not inbetween i think this is a good thing.
*/
