#include "script_component.hpp"

/*
  Name: TFAR_fnc_isBackpackRadio

  Author: Dorbedo
    Returns if a radio is a backpacked radio.

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    Radio classname <BOOL>

  Example:
    "TFAR_anprc_152" call TFAR_fnc_isBackpackRadio;

  Public: Yes
 */
params [["_classname", []]];

if (_classname isEqualType []) exitWith {false};
if (_classname isEqualType objNull) then {_classname = typeOf _classname;};

if (([_classname, "tf_hasLRradio", 0] call DFUNC(getVehicleConfigProperty)) isEqualTo 0) exitWith {false};

_classname isKindOf "TFAR_Bag_Base"
