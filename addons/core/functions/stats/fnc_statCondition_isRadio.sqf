#include "script_component.hpp"

/*
  Name: TFAR_fnc_statCondition_isRadio

  Author: DartRuffian
    Checks if a given item is a SR or LR radio

  Arguments:
    Stats  - Stats to use <ARRAY>
    Config - Config path to item <CONFIG>

  Return Value:
    True if given item is a radio, otherwise. <BOOL>

  Example:
    [["tf_hasLRradio", "tf_radio"], _config] call TFAR_fnc_statCondition_isRadio

  Public: No
*/

params ["_stats", "_config"];

getNumber (_config >> _stats select 0) == 1 || {getNumber (_config >> _stats select 1) == 1}
