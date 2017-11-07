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

[_this,"tf_prototype",false] call DFUNC(getConfigWeaponProperty)
