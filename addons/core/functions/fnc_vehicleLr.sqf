#include "script_component.hpp"

/*
 * Name: TFAR_fnc_vehicleLr
 *
 * Author: NKey
 * Gets the LR radio of the vehicle and the settings for it depending on the player's position within the vehicle
 * returns nil, if no Vehicle radio was found
 *
 * Arguments:
 * 0: unit <OBJECT>
 *
 * Return Value:
 * 0: Vehicle <OBJECT>
 * 1: Radio Settings ID <STRING>
 *
 * Example:
 * _radio = player call TFAR_fnc_VehicleLR;
 *
 * Public: Yes
 */
params ["_unit"];

if (isNull (objectParent _unit) || {!((objectParent _this) call TFAR_fnc_hasVehicleRadio)}) exitWith {nil};//Unit is not in vehicle or vehicle doesn't have LR Radio

private _result = nil;
private _vehicle = vehicle _unit;
switch (_unit) do {
    case (gunner _vehicle): {
        _result = [_vehicle, "gunner_radio_settings"];
    };
    case (driver _vehicle): {
        _result = [_vehicle, "driver_radio_settings"];
    };
    case (commander _vehicle): {
        _result = [_vehicle, "commander_radio_settings"];
    };
    case (_vehicle call TFAR_fnc_getCopilot): {
        _result = [_vehicle, "copilot_radio_setting"];
    };
    default {
        private _turrets = [(typeof _vehicle), "TFAR_AdditionalLR_Turret", []] call TFAR_fnc_getVehicleConfigProperty;
        private _index = (_turrets apply {(_vehicle turretUnit _x)}) find _unit;
        if (_index != -1) exitWith {_result = [_vehicle, format ["turretUnit_%1_radio_setting",_index]]};

        private _cargos = [(typeof _vehicle), "TFAR_AdditionalLR_Cargo", []] call TFAR_fnc_getVehicleConfigProperty;
        private _cargoIndex = _vehicle getCargoIndex _unit;
        if (_cargoIndex in _cargos) exitWith {_result = [_vehicle, format ["cargoUnit_%1_radio_setting",_cargoIndex]]};
    }
};

_result
