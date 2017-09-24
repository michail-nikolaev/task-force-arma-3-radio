#include "script_component.hpp"

/*
    Author(s):
        By Dimitri Yuri edited by 2600K
        Dedmen

    Description:
        Add Eventhandler that notifies nearby AI's when player is Speaking
*/

if (!hasInterface) exitWith {}; //Only on clients

["TFAR_AI_Detection", "OnSpeak", {
    params ["_unit","_isSpeaking"];
    //systemChat format["TFAR OnSpeak %1 %2",_unit,_isSpeaking];
    // Exit if unit is isolated or DC'd or dead
    if (isNil "_unit"  || {!alive _unit} || {(vehicle _unit) call TFAR_fnc_isVehicleIsolated}) exitWith {};

    private _nearHostiles = _unit nearEntities [["Car", "Motorcycle", "Tank","CAManBase","Man"], TF_speak_volume_meters - 5];//-5 because Enemies don't have that good hearing

    {
        //could use TFAR_speakingSince to see how long player is speaking and increase reveal according to that


        if (!(isPlayer _x) && {!isNull _x} && {!((vehicle _x) call TFAR_fnc_isVehicleIsolated)} && {_x knowsAbout _unit <= 1.5}) then {
            //#TODO the farther away the unit is the lower reveal it should have
            [_x,[_unit,1.5]] remoteExec ["reveal", _x];
            //systemChat format["TFAR Revealing %1 to %2 (%3).",_unit,_x,_x knowsAbout _unit];
        };
        true
    } count _nearHostiles;

}, player] call TFAR_fnc_addEventHandler;


/*
This will also be revealing the Player if he stops Speaking.
But as this script only triggers on start and end and not inbetween i think this is a good thing.
*/
