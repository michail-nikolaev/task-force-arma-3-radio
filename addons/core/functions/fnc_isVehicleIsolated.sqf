#include "script_component.hpp"

/*
  Name: TFAR_fnc_isVehicleIsolated

  Author: NKey
    checks wether the vehicle is isolated

  Arguments:
    0: the vehicle <OBJECT>

  Return Value:
    is isolated <BOOL>

  Example:
    _isolated = (vehicle player) call TFAR_fnc_isVehicleIsolated;

  Public: Yes
*/
params ["_vehicle"];

private _isolated = _vehicle getVariable ["TFAR_isolatedAmount", scriptNull];

if (_isolated isEqualTo scriptNull) then {
    _isolated = [typeOf _vehicle, "tf_isolatedAmount", 0.0] call TFAR_fnc_getVehicleConfigProperty;
    _vehicle setVariable ["TFAR_isolatedAmount", _isolated];
};

_isolated > 0.5
