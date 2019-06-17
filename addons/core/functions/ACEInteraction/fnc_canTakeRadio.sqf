#include "script_component.hpp"

/*
  Name: TFAR_fnc_canTakeRadio

  Author: Dorbedo
    Checks if a radio from the target unit can be taken

  Arguments:
    0: the unit who gets the radio <OBJECT>
    1: the unit who loses the radio <OBJECT>
    2: the radio to be taken <STRING|ARRAY>

  Return Value:
    the radio can be taken <BOOL>

  Example:
    [_target, _player, "TFAR_anprc_152"] call TFAR_fnc_canTakeRadio;

  Public: No
*/

params ["_target", "_unit", "_radio"];

if (TFAR_takingRadio < 1) exitWith {false};

if ((TFAR_takingRadio isEqualTo 1) && ((!(_target getVariable ["ACE_isDead", true])) || {alive _target})) exitWith {false};

if ((TFAR_takingRadio > 1) &&
    {_target call ace_common_fnc_isAwake} &&
    {!(_target getVariable ["ace_captives_isHandcuffed", false])} &&
    {!(_target getVariable ["ace_captives_isSurrendering", false])}) exitWith {false};

if (_radio isEqualType "") then {
    _unit canAdd _radio
} else {
    (backpack _unit) isEqualTo ""
};
