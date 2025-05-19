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
    [["tf_hasLRradio", "tf_radio", "tf_prototype"], _config] call TFAR_fnc_statCondition_isRadio

  Public: No
*/

params ["_stats", "_config"];

_stats findIf { getNumber (_config >> _x) == 1 } != -1
