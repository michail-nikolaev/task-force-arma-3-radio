#include "script_component.hpp"

/*
    Name: TFAR_fnc_getLrRadioProperty

    Author(s):
        L-H

    Description:

    Parameters:
    0: OBJECT - Backpack/vehicle
    1: STRING - Property name

    Returns:
    NUMBER or TEXT- Value of property

    Example:
    [(vehicle player), "TF_hasLRradio"] call TFAR_fnc_getLrRadioProperty;
*/

params ["_radio", "_property"];

private _result = _radio getVariable _property;

if (isNil "_result") then {
    if (!(_radio isKindOf "Bag_Base")) then {
        if (isNumber (ConfigFile >> "CfgVehicles" >> (typeof _radio) >> _property)
            or {isText (configFile >> "CfgVehicles" >> (typeof _radio) >> _property)}
            or {isNumber (ConfigFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
            or {isText (ConfigFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
            ) exitWith {
            _radio = typeof _radio;
        };
        _result = _radio getVariable "TF_RadioType";
        if (isNil "_result") then {
            _result = [typeof _radio, "tf_RadioType"] call TFAR_fnc_getConfigProperty;

            if (!isNil "_result" AND {_result != ""}) exitWith {};
            private _air = (typeof(_radio) isKindOf "Air");
            if ((_radio call TFAR_fnc_getVehicleSide) == west) then {
                if (_air) then {
                    _result = TFAR_DefaultRadio_Airborne_West;
                } else {
                    _result = TFAR_DefaultRadio_Backpack_West;
                };
            } else {
                if ((_radio call TFAR_fnc_getVehicleSide) == east) then {
                    if (_air) then {
                        _result = TFAR_DefaultRadio_Airborne_East;
                    } else {
                        _result = TFAR_DefaultRadio_Backpack_East;
                    };
                } else {
                    if (_air) then {
                        _result = TFAR_DefaultRadio_Airborne_Independent;
                    } else {
                        _result = TFAR_DefaultRadio_Backpack_Independent;
                    };
                };
            };
        };
        _radio = _result;
    } else {
        _radio = typeof _radio;
    };
    _result = [_radio, _property] call TFAR_fnc_getConfigProperty;
};

_result
