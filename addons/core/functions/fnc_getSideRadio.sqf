#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSideRadio

  Author: Garth de Wet (L-H)
    Returns the default radio for the passed side.

  Arguments:
    0: side <SIDE>
    1: radio type : Range [0,2] (0 - LR, 1 - SW, 2 - Rifleman) <NUMBER>

  Return Value:
    Default Radio <STRING|OBJECT>

  Example:
    _defaultLRRadio = [side player, 0] call TFAR_fnc_getSideRadio;
    _defaultSWRadio = [side player, 1] call TFAR_fnc_getSideRadio;
    _defaultRiflemanRadio = [side player, 2] call TFAR_fnc_getSideRadio;

  Public: Yes
 */

params ["_side", "_radioType"];

private _result = "";
switch (_radioType) do {
    case 0: {
        _result = missionNamespace getVariable format["TFAR_DefaultRadio_%1_%2","Backpack",_side];
    };
    case 1: {
        _result = missionNamespace getVariable format["TFAR_DefaultRadio_%1_%2","Personal",_side];
    };
    case 2: {
        _result = missionNamespace getVariable format["TFAR_DefaultRadio_%1_%2","Rifleman",_side];
    };
};

_result
