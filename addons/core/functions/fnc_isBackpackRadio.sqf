#include "script_component.hpp"

/*
    Name: TFAR_fnc_isBackpackRadio

    Author(s):
        Dorbedo

    Description:
        Returns if a radio is a backpacked radio.

    Parameters:
        0: STRING - Radio classname

    Returns:
        BOOLEAN - True if backpack radio

    Example:
        "TFAR_anprc_152" call TFAR_fnc_isBackpackRadio;
*/
params [["_classname",[]]];

if (_classname isEqualType []) exitWith {false};
if (_classname isEqualType objNull) then {_classname = typeOf _classname;};

If (([_classname, "tf_hasLRradio", 0] call DFUNC(getConfigProperty)) isEqualTo 0) exitWith {false};

_classname isKindOf "TFAR_Bag_Base"
