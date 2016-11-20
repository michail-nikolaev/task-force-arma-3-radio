#include "script_component.hpp"

/*
    Name: TFAR_fnc_isPrototypeRadio

    Author(s): Garth de Wet (LH)

    Description:
    Returns if a radio is a prototype radio.

    Parameters:
    0: STRING - Radio classname

    Returns:
    BOOLEAN - True if prototype, false if actual radio.

    Example:
    if ("TFAR_anprc148jem" call TFAR_fnc_isPrototypeRadio) then {
        hint "Prototype";
    };
*/

if (_this == "ItemRadio") exitWith {true};

private _result = getNumber (configFile >> "CfgWeapons" >> _this >> "tf_prototype");
if (!isNil "_result") exitWith {_result == 1};

false
