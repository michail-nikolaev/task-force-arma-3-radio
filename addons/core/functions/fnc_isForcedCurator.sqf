#include "script_component.hpp"

/*
  Name: TFAR_fnc_isForcedCurator

  Author: NKey
    Return if unit if forced curator.

  Arguments:
    0: unit to check <OBJECT>

  Return Value:
    is unit forced curator <BOOL>

  Example:
    player call TFAR_fnc_isForcedCurator;

  Public: Yes
*/

private _result = _this getVariable "tf_forcedCurator";
if (!isNil "_result") exitWith {_result};

_result = ((typeof _this) == "VirtualCurator_F") ||
            {[configFile >> "CfgVehicles" >> (typeof _this), configFile >> "CfgVehicles" >> "VirtualCurator_F"] call CBA_fnc_inheritsFrom};
_this setVariable ["tf_forcedCurator", _result];

_result
