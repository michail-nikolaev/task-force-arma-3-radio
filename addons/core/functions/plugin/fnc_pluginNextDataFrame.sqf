#include "script_component.hpp"

/*
  Name: TFAR_fnc_pluginNextDataFrame

  Author: NKey
    Tells the plugin that the current DataFrame is done.
    This tells the plugin that we are currently ingame.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_pluginNextDataFrame;

  Public: Yes
 */
//Async call will always return "OK"
_result = "task_force_radio_pipe" callExtension "DFRAME~";
if (_result == "NEEDCFG") then {call TFAR_fnc_sendPluginConfig; ["TFAR_ConfigRefresh",[]] call CBA_fnc_localEvent;};//Plugin wants config
