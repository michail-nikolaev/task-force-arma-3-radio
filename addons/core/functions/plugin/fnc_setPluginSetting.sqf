#include "script_component.hpp"

/*
    Name: TFAR_fnc_setPluginSetting

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
        ["half_duplex",true] call TFAR_fnc_setPluginSetting;
*/

//This is needed because CBA will call SettingChanged eventhandler in briefing screen.. Which would init the Plugin too soon
if (getClientStateNumber != 10) exitWith {"Exit if ran before mission started"};

params ["_key", ["_value",false,["",false,0]]];

//Async call which doesn't return anything
"task_force_radio_pipe" callExtension format["SETCFG	%1	%2	%3~",_key,_value,typeName _value];
