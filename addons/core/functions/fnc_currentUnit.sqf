#include "script_component.hpp"

/*
  Name: TFAR_fnc_currentUnit

  Author: NKey
    Return current player unit (player or remote controlled by Zeus).

  Arguments:
    None

  Return Value:
    current unit <OBJECT>

  Example:
    call TFAR_fnc_currentUnit;

  Public: Yes
 */

missionNamespace getVariable ["bis_fnc_moduleRemoteControl_unit", player]
