#include "script_component.hpp"

/*
  Name: TFAR_fnc_parseClassnamesInput

  Author: Dorbedo, Arend
    Parses an array of classnames, does a value check to ensure classnames
    exist.

  Arguments:
    0: classnames <STRING>

  Return Value:
    parsed classnames <ARRAY>

  Example:
    ["[B_CrewHelmet, 51122, 52, 53, 4, 5, 56, 57, 58, 59, ""asd"", asd, ""88""]", 8, 87, 40] call TFAR_fnc_parseClassnamesInput;

  Public: Yes
*/

params [
    ["_valueString", "", [""]]
];

// add brackets if they are missing
private _firstChar = _valueString select [0,1];
private _lastChar = _valueString select [(count _valueString) - 1,1];

if (_firstChar != "[") then {
    _valueString = "[" + _valueString;
};

if (_lastChar != "]") then {
    _valueString = _valueString + "]";
};

_valueString = _valueString splitString " " joinString ""; //remove spaces
private _parsedValue = (parseSimpleArray _valueString) apply {
    if !(IS_STRING(_x)) then {format["%1", _x]} else {_x};
};

_parsedValue = _parsedValue arrayIntersect _parsedValue; // Retain only unique elements

_parsedValue = _parsedValue apply {
    if (isClass(configFile >> "CfgWeapons" >> _x)) then {
        configName(configFile >> "CfgWeapons" >> _x);
    } else {""};
};

_parsedValue
