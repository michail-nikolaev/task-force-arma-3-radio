#include "script_component.hpp"

/*
  Name: TFAR_fnc_statCondition_encryptionCode

  Author: DartRuffian
    Checks if an item is a radio and has an encyrption code

  Arguments:
    Stats  - Stats to use <ARRAY>
    Config - Config path to item <CONFIG>

  Return Value:
    True if item has an encryption code and is a radio, otherwise false <BOOL>

  Example:
    [["tf_encryptionCode"], _config] call TFAR_fnc_statCondition_encryptionCode

  Public: No
*/

params ["_stats", "_config"];

[["tf_hasLRradio", "tf_radio"], _config] call TFAR_fnc_statCondition_isRadio && {getNumber (_config >> _stats select 0) != ""}
