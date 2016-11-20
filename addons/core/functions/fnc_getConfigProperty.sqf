#include "script_component.hpp"

/*
    Name: TFAR_fnc_getConfigProperty

    Author(s):
        NKey
        L-H

    Description:
    Gets a config property (getNumber/getText)
    Only works for CfgVehicles.

    Parameters:
    0: STRING - Item classname
    1: STRING - property
    2: ANYTHING - Default (Optional)

    Returns:
    NUMBER or TEXT - Result

    Example:
        [_LRradio, "tf_hasLrRadio", 0] call TFAR_fnc_getConfigProperty;
*/

params ["_item", "_property", ["_default", ""]];
//#TODO deprecate _api stuff
if ((isNil "_item") or {str(_item) == ""}) exitWith {_default};

if (isNumber (configFile >> "CfgVehicles" >> _item >> _property + "_api")) exitWith {
    getNumber (configFile >> "CfgVehicles" >> _item >> _property + "_api")
};

if (isNumber (configFile >> "CfgVehicles" >> _item >> _property)) exitWith {
    getNumber (configFile >> "CfgVehicles" >> _item >> _property)
};

if (isText (configFile >> "CfgVehicles" >> _item >> _property + "_api")) exitWith {
    getText (configFile >> "CfgVehicles" >> _item >> _property + "_api")
};

if (isText (configFile >> "CfgVehicles" >> _item >> _property)) exitWith {
    getText (configFile >> "CfgVehicles" >> _item >> _property);
};


_default
