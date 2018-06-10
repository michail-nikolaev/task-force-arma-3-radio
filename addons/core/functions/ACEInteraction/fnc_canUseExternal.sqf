#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_canUseExternal

  Author: Dorbedo
    can use the radio externally

  Arguments:
    0: the target unit <OBJECT>
    1: the player <OBJECT>
    2: the radio <ARRAY>

  Return Value:
    None

  Example:
    _return = [] call TFAR_core_fnc_canUseExternal;

  Public: No
*/

params ["_target", "_unit", ["_radio", [], [[]]]];

if (_radio isEqualTo []) exitWith {false};

if ((_radio select 0) call TFAR_fnc_isStaticRadio) then {
    !(
        (!(((_radio select 0) getVariable [QGVAR(usedExternallyBy), objNull]) isEqualTo objNull)) ||
        {(_unit distance (_radio select 0)) > TFAR_MAXREMOTELRRADIODISTANCE}
    )
} else {
    !(
        (!(((_radio select 0) getVariable [QGVAR(usedExternallyBy), objNull]) isEqualTo objNull)) ||
        {(_unit distance objectParent(_radio select 0)) > TFAR_MAXREMOTELRRADIODISTANCE} ||
        {_radio call FUNC(getLRExternalUsage)}
    )
};
