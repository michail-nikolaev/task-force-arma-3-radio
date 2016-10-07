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

if ((isNil "_item") or {str(_item) == ""}) exitWith {_default};

private _result = _default;
if (isNumber (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api")) then {
    _result = getNumber (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api");
}else{
    if (isNumber (ConfigFile >> "CfgVehicles" >> _item >> _property)) then{
        _result = getNumber (ConfigFile >> "CfgVehicles" >> _item >> _property);
    }else{
        if (isText (configFile >> "CfgVehicles" >> _item >> _property + "_api")) then{
            _result = getText (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api");
        }else{
            if (isText (configFile >> "CfgVehicles" >> _item >> _property)) then {
                _result = getText (ConfigFile >> "CfgVehicles" >> _item >> _property);
            };
        };
    };
};
_result
