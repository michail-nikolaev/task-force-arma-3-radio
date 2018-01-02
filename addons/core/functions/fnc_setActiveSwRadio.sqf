#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setActiveSwRadio
 *
 * Author: NKey
 * Sets the active SR radio.
 *
 * Arguments:
 * 0: Radio ID <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * "TFAR_anprc148jem_1" call TFAR_fnc_setActiveSwRadio;
 *
 * Public: Yes
 */

private _old = (call TFAR_fnc_activeSwRadio);
private _couldAdd = TFAR_currentUnit canAdd _old;
TFAR_currentUnit unassignItem _old;
TFAR_currentUnit assignItem _this;
if (!_couldAdd) then {TFAR_currentUnit addItem _old}; //We couldn't put it into inventory before but now we have space for sure.
["OnSWChange", [TFAR_currentUnit, _this, _old]] call TFAR_fnc_fireEventHandlers;
