#include "script_component.hpp"

/*
  Name: TFAR_fnc_getVehicleRadios

  Author: Jaffa
    Gets a list of radios in the specified vehicle

  Arguments:
    0: Vehicle <OBJECT>

  Return Value:
    0: Vehicle <OBJECT>
    1: Radio Settings ID <STRING>

  Example:
    _radios = _vehicle call TFAR_fnc_getVehicleRadios;

  Public: Yes
*/

if !(params [["_vehicle",objNull,[objNull]]]) exitWith { ERROR_1("TFAR: Vehicle must be passed to getVehicleRadios. %1 was passed instead.", _vehicle) };
if (isNull _vehicle || {!(_vehicle call TFAR_fnc_hasVehicleRadio)}) exitWith {[]};

private _result = [[_vehicle, "gunner_radio_settings"], [_vehicle, "driver_radio_settings"], [_vehicle, "commander_radio_settings"], [_vehicle, "copilot_radio_setting"]];
        
private _turrets = [(typeof _vehicle), "TFAR_AdditionalLR_Turret", []] call TFAR_fnc_getVehicleConfigProperty;
{_result pushBack [_vehicle, format["turretUnit_%1_radio_setting", _forEachIndex]] } forEach _turrets;

private _cargos = [(typeof _vehicle), "TFAR_AdditionalLR_Cargo", []] call TFAR_fnc_getVehicleConfigProperty;
_cargos = _cargos apply {[_vehicle, format ["cargoUnit_%1_radio_setting", _x]]};
_result append _cargos;

_result
