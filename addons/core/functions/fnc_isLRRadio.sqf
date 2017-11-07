#include "script_component.hpp"

/*
    Name: TFAR_fnc_isLRRadio

    Author(s):
        Dedmen

    Description:
        Returns if a radio is a Longrange radio.

    Parameters:
        0: STRING - Radio classname
    Returns:
        BOOLEAN - True if Longrange, false if handheld radio.

    Example:
        "TFAR_anprc_152" call TFAR_fnc_isLRRadio;
*/
params ["_classname"];

if (_this isEqualType []) exitWith {true};
if (_classname isEqualType objNull) then {_classname = typeOf _classname;};

private _result = getNumber (configFile >> "CfgVehicles" >> _classname >> "tf_hasLRradio");

if (isNil "_result" || {_result != 1}) exitWith {false};

true
