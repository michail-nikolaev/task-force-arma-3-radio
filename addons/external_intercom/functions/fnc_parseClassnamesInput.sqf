#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_parseClassnamesInput

  Author: Dorbedo, Arend
    Parses an array of classnames, does a value check to ensure classnames
    exist.

  Arguments:
    0: classnames <STRING>

  Return Value:
    parsed classnames <ARRAY>

  Example:
    ["[B_CrewHelmet, 51122, 52, 53, 4, 5, 56, 57, 58, 59, ""asd"", asd, ""88""]", 8, 87, 40] call TFAR_external_intercom_fnc_parseClassnamesInput;

  Public: Yes
*/

params [
    ["_valueString", "", [""]]
];

private _parsedValue = (_valueString splitString ",") apply {
    if !(_x isEqualType "STRING") then {_x = format["%1", _x]};
    [_x] call BIS_fnc_filterString;
};

_parsedValue = _parsedValue arrayIntersect _parsedValue; // Retain only unique elements

_parsedValue = _parsedValue apply {
    if (isClass(configFile >> "CfgWeapons" >> _x)) then {
        configName(configFile >> "CfgWeapons" >> _x);
    } else {""};
};

_parsedValue = _parsedValue select {!(_x isEqualTo "")}; // Retain only non-null elements

_parsedValue;
