#include "script_component.hpp"

/*
  Name: TFAR_fnc_setPluginSetting

  Author: Dedmen
    Sets a teamspeak plugin config variable

  Arguments:
    0: setting name <STRING>
    1: value <STRING|BOOL|SCALAR>

  Return Value:
    None

  Example:
    ["half_duplex",true] call TFAR_fnc_setPluginSetting;

  Public: Yes
*/

//This is needed because CBA will call SettingChanged eventhandler in briefing screen.. Which would init the Plugin too soon
if (getClientStateNumber != 10) exitWith {"Exit if ran before mission started"};

params ["_key", ["_value",false,["",false,0]]];

//Async call which doesn't return anything
"task_force_radio_pipe" callExtension format["SETCFG	%1	%2	%3~",_key,_value,typeName _value];
