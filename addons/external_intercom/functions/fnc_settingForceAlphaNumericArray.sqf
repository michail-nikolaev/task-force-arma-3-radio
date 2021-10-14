#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_settingForceAlphaNumericArray

  Author: Dorbedo
    Forces the input into an array format and removes invalid input

  Arguments:
    0: frequencies input <STRING>

  Return Value:
    cleaned input <STRING>

  Example:
    ["123 123 , 332 23"] call TFAR_external_intercom_fnc_settingForceAlphaNumericArray;

  Public: No
*/
params [["_input", "", [""]]];

if (_input isEqualTo "") exitWith {""};
// keep the last sign, if you want to type a new value
private _lastSign = _input select [count _input - 1];
_lastSign = if !((_lastSign isEqualTo ",") || {_lastSign isEqualTo " "}) then {""};

private _inputArray = _input splitString " ,";

((_inputArray select {!(_x isEqualTo "")}) joinString ",") + _lastSign;
