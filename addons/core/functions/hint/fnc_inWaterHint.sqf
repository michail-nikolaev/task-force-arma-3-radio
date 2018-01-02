#include "script_component.hpp"

/*
 * Name: TFAR_fnc_inWaterHint
 *
 * Author: L-H
 * shows the "in water" hint
 *
 * Arguments:
 * None
 *
 * Return Value:
 * None
 *
 * Example:
 * call TFAR_fnc_inWaterHint;
 *
 * Public: No
 */

[parseText (localize LSTRING(in_water_hint)), 5] call TFAR_fnc_showHint;
