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

private _propertyGetVariable = _radio getVariable _property;

if (!isNil "_propertyGetVariable") exitWith {_propertyGetVariable};

if (_radio isKindOf "Bag_Base") exitWith {[typeof _radio, _property] call TFAR_fnc_getVehicleConfigProperty};

if (isNumber (configFile >> "CfgVehicles" >> (typeof _radio) >> _property)
    or {isText (configFile >> "CfgVehicles" >> (typeof _radio) >> _property)}
    or {isNumber (configFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
    or {isText (configFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
    ) exitWith {[typeof _radio, _property] call TFAR_fnc_getVehicleConfigProperty};

_radioTypeVariable = _radio getVariable "TF_RadioType";
if (!isNil "_radioTypeVariable") exitWith {[_radioTypeVariable, _property] call TFAR_fnc_getVehicleConfigProperty};

_radioTypeConfig = [typeof _radio, "tf_RadioType"] call TFAR_fnc_getVehicleConfigProperty;
if (!isNil "_radioTypeConfig" AND {_radioTypeConfig != ""}) exitWith {[_radioTypeConfig, _property] call TFAR_fnc_getVehicleConfigProperty};

private _isAirRadio = (typeof _radio) isKindOf "Air";

private _radioClassname = "";
switch (_radio call TFAR_fnc_getVehicleSide) do {
    case west: {
        _radioClassname = [TFAR_DefaultRadio_Backpack_West,TFAR_DefaultRadio_Airborne_West] select _isAirRadio;
    };
    case east: {
        _radioClassname = [TFAR_DefaultRadio_Backpack_East,TFAR_DefaultRadio_Airborne_East] select _isAirRadio;
    };
    default {
        _radioClassname = [TFAR_DefaultRadio_Backpack_Independent,TFAR_DefaultRadio_Airborne_Independent] select _isAirRadio;
    };
};

[_radioClassname, _property] call TFAR_fnc_getVehicleConfigProperty;
