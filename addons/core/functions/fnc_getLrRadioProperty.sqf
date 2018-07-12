#include "script_component.hpp"

/*
  Name: TFAR_fnc_getLrRadioProperty

  Author: Garth de Wet (L-H)
    returns specified radio property

  Arguments:
    0: Backpack/vehicle <OBJECT>
    1: Property name <STRING>

  Return Value:
    Value of property <NUMBER|TEXT>

  Example:
    [(vehicle player), "TF_hasLRradio"] call TFAR_fnc_getLrRadioProperty;

  Public: Yes
*/

params ["_radio", "_property", ["_default", ""]];

private _propertyGetVariable = _radio getVariable _property;

if (!isNil "_propertyGetVariable") exitWith {_propertyGetVariable};

if (_radio isKindOf "Bag_Base") exitWith {[typeof _radio, _property, _default] call TFAR_fnc_getVehicleConfigProperty};

if (isNumber (configFile >> "CfgVehicles" >> (typeof _radio) >> _property)
    or {isText (configFile >> "CfgVehicles" >> (typeof _radio) >> _property)}
    or {isNumber (configFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
    or {isText (configFile >> "CfgVehicles" >> (typeof _radio) >> (_property + "_api"))}
    ) exitWith {[typeof _radio, _property] call TFAR_fnc_getVehicleConfigProperty};

_radioTypeVariable = _radio getVariable "TF_RadioType";
if (!isNil "_radioTypeVariable") exitWith {[_radioTypeVariable, _property, _default] call TFAR_fnc_getVehicleConfigProperty};

_radioTypeConfig = [typeof _radio, "tf_RadioType"] call TFAR_fnc_getVehicleConfigProperty;
if (_radioTypeConfig != "") exitWith {[_radioTypeConfig, _property, _default] call TFAR_fnc_getVehicleConfigProperty};

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

[_radioClassname, _property, _default] call TFAR_fnc_getVehicleConfigProperty;
