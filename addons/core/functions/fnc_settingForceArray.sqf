#include "script_component.hpp"

/*
    Name: TFAR_fnc_settingForceArray

    Author(s):
        Dorbedo

    Description:
        Forces the input into an array format and removes invalid input

    Parameters:
        0: STRING - frequencies input

    Returns:
        STRING

    Example:
        ["123 123 , 332 23"] call TFAR_fnc_settingForceArray;
*/

params [["_input", "", [""]]];

if (_input isEqualTo "") exitWith {""};
// keep the last sign, if you want to type a new value
private _lastSign = _input select [count _input - 1];
_lastSign = if !((_lastSign isEqualTo ",")||{_lastSign isEqualTo " "}) then {""};

private _inputArray = _input splitString " ,";
_inputArray = _inputArray apply {
    // filter for numbers and dots
    private _filtered = toString ((toArray _x) select {(_x >= 48 && _x <= 57)||{_x isEqualTo 46}});
    // decimal value
    if ((_filtered find ".") >= 0) then {
        private _decimal = _filtered splitString ".";
        if ((count _decimal) isEqualTo 2) then {
            _decimal set [1, (_decimal select 1) select [0,1]];
        } else {
            _decimal pushBack "";
        };
        _filtered = _decimal joinString ".";
    };
    _filtered
};

((_inputArray select {!(_x isEqualTo "")}) joinString ",") + _lastSign
