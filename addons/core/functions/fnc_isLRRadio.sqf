#include "script_component.hpp"

/*
  Name: TFAR_fnc_isLRRadio

  Author: Dedmen
    Returns if a radio is a Longrange radio.

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    True if Longrange, false if handheld radio. <BOOL>

  Example:
    "TFAR_anprc_152" call TFAR_fnc_isLRRadio;

  Public: Yes
*/
params ["_classname"];

if (_this isEqualType []) exitWith {true};
if (_classname isEqualType objNull) then {_classname = typeOf _classname;};

private _result = getNumber (configFile >> "CfgVehicles" >> _classname >> "tf_hasLRradio");

if (isNil "_result" || {_result != 1}) exitWith {false};

true
