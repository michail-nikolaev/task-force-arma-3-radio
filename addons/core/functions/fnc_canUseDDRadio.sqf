#include "script_component.hpp"

/*
  Name: TFAR_fnc_canUseDDRadio

  Author: NKey
    Checks whether it is possible for the DD radio to be used at the current height and isolated status.

  Arguments:
    0: Depth <NUMBER>
    1: Isolated and inside <BOOL>

  Return Value:
    radio can be used <BOOL>

  Example:
    _canUseDD = [-12,true] call TFAR_fnc_canUseDDRadio;

  Public: Yes
*/

params ["_depth", "_isolated_and_inside"];

(_depth < 0) and !(_isolated_and_inside) and {call TFAR_fnc_haveDDRadio}
