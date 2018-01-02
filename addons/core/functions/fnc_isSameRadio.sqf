#include "script_component.hpp"

/*
 * Name: TFAR_fnc_isSameRadio
 *
 * Author: Garth de Wet (L-H)
 * Checks whether the two passed radios have the same prototype radio
 *
 * Arguments:
 * 0: radio classname <STRING>
 * 1: radio classname <STRING>
 *
 * Return Value:
 * same parent radio <BOOL>
 *
 * Example:
 *      if([(call TFAR_fnc_activeSwRadio), "TFAR_fadak"] call TFAR_fnc_isSameRadio) then {
 *          hint "same parent radio";
 *      };
 *
 * Public: Yes
 */

params ["_radio1", "_radio2"];

if !(_radio1 call TFAR_fnc_isPrototypeRadio) then {
    _radio1 = configName (inheritsFrom (configFile >> "CfgWeapons" >> _radio1));
};
if !(_radio2 call TFAR_fnc_isPrototypeRadio) then {
    _radio2 = configName (inheritsFrom (configFile >> "CfgWeapons" >> _radio2));
};

(_radio2 == _radio1)
