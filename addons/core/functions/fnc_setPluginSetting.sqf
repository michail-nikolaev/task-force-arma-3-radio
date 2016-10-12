#include "script_component.hpp"

/*
    Name: TFAR_fnc_setPluginSettings

    Author(s):
        Dedmen

    Description:
        Sets a Teamspeak Plugin config variable

    Parameters:
        0: STRING - setting Name
        1: STRING,BOOL,SCALAR - value of setting

    Returns:
        Nothing

    Example:
        ["half_duplex",true] spawn TFAR_fnc_setPluginSettings;
*/

params ["_key", ["_value",false,["",false,0]]];

//Async call which doesn't return anything
"task_force_radio_pipe" callExtension format["SETCFG	%1	%2	%3~",_key,_value,typeName _value];
