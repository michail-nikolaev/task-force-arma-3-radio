#include "script_component.hpp"

/*
    Name: TFAR_fnc_getVehicleRadios

    Author(s):
        Jaffa

    Description:
        Gets a list of radios in the specified vehicle

    Parameters:
        0: Object - vehicle

    Returns:
         Array of radios in format: 
             0 - Object - Vehicle, 1 - String - Radio Settings ID
         or empty array if no vehicle radios found

    Example:
        _radios = _vehicle call TFAR_fnc_getVehicleRadios;
*/
params ["_vehicle"];

if (isNull _vehicle || {!(_vehicle call TFAR_fnc_hasVehicleRadio)}) exitWith {[]};//Vehicle is null or vehicle doesn't have LR Radio

private _result = [[_vehicle, "gunner_radio_settings"],[_vehicle, "driver_radio_settings"],[_vehicle, "commander_radio_settings"],[_vehicle, "copilot_radio_setting"]];
        
private _turrets = [(typeof _vehicle), "TFAR_AdditionalLR_Turret", []] call TFAR_fnc_getVehicleConfigProperty;
private _turrets = _turrets apply {[_vehicle, format ["turretUnit_%1_radio_setting",_x]]};
_result append _turrets;

private _cargos = [(typeof _vehicle), "TFAR_AdditionalLR_Cargo", []] call TFAR_fnc_getVehicleConfigProperty;
private _cargos = _cargos apply {[_vehicle, format ["cargoUnit_%1_radio_setting",_x]]};
_result append _cargos;

_result