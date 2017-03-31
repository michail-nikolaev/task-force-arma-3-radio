#include "script_component.hpp"

if (!isServer) exitWith {};


["TFAR_StaticRadioEvent", {
    params ["_weaponHolder","_frequencies","_channel","_speaker","_volume"];

    [_weaponHolder,parseNumber _channel] call TFAR_static_radios_fnc_setActiveChannel;
    [_weaponHolder,call compile _frequencies] call TFAR_static_radios_fnc_setFrequencies;
    [_weaponHolder,_speaker] call TFAR_static_radios_fnc_setSpeakers;
    [_weaponHolder,_volume] call TFAR_static_radios_fnc_setVolume;


}] call CBA_fnc_addEventHandler;
