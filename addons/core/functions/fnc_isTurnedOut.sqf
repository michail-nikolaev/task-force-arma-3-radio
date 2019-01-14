#include "script_component.hpp"

/* ----------------------------------------------------------------------------
  Name: TFAR_fnc_isTurnedOut

  Author:
    shukari

  Description:
    Checks whether a unit is attenuated, meaning in another compartment outside of outside voice range.

  Arguments:
    _unit - Unit to check <OBJECT>

  Return Value:
    [isTurnedOut, attenuation] <BOOL>

  Example:
    if ([player] call TFAR_fnc_isAttenuated) then {
        player sideChat "I cant hear you outside guy!";
    };

  Config & Variable API:
    Example:
        Config: CBA_attenuatedRoles[] = {{"driver", -1, "ani_window_1"}, {"turret", {0}, "ani_window_2"}, {"gunner", -1, "ani_window_4"}};
        Variable:  _vehicle setVariable ["CBA_attenuatedRoles", ["driver", -1, "ani_window_1"]];
    Attributes
        role
        cargoindex or turretPath
        animation for attenuated ("" for always NOT attenuated)
    Info
        variable overrides config
---------------------------------------------------------------------------- */
params [["_unit", objNull, [objNull]]];

// outside of the vehicle or turned out
if (isNull objectParent _unit) exitWith {[true, 1]};
if (isTurnedOut _unit) exitWith {[true, 2]};




private _fnc_getAttenuationFromEffect = if (TFAR_experimentalVehicleIsolation) then {
    {
        private _type = configFile >> "CfgSoundEffects" >> "AttenuationsEffects" >> _attenuationType;

        private _gains =  getArray (_type >> "Equalizer0" >> "gain") + getArray (_type >> "Equalizer1" >> "gain");

        if (_gains isEqualTo []) exitWith {
             [(typeof _vehicle), "tf_isolatedAmount", 0.0] call TFAR_fnc_getVehicleConfigProperty
        };

        private _sum = 0;
        {
            _sum = _sum + _x;
        } forEach _gains;

        1- (_sum / count _gains)
    }

} else {
    {
        [(typeof _vehicle), "tf_isolatedAmount", 0.0] call TFAR_fnc_getVehicleConfigProperty
    }
};









// open vehicle
private _vehicle = vehicle _unit;
private _config = configFile >> "CfgVehicles" >> typeOf _vehicle;

// class CfgSoundEffects >> class AttenuationsEffects
private _attenuationType = getText (_config >> "attenuationEffectType");
if (_attenuationType in ["OpenCarAttenuation", "OpenHeliAttenuation", "jsrs_OpenCar_Attenuation", "jsrs_SemiOpenCar_Attenuation"]) exitWith {[true, 3]};

private _fullCrew = fullCrew _vehicle;
(_fullCrew select (_fullCrew findIf {_unit isEqualTo (_x param [0, objNull])})) params ["", "_role", "_cargoIndex", "_turretPath", "_isFFV"];
_role = toLower _role;
private _return = !_isFFV;

// override for enabledByAnimationSource FFVs
private _turret = [_vehicle, _turretPath] call CBA_fnc_getTurret;
private _enabledAnim = getText (_turret >> "enabledByAnimationSource");
if (!(_enabledAnim isEqualTo "") && {(_vehicle animationSourcePhase _enabledAnim) < 1}) then {
    _return = true;
};

// API
private _attenuationAPI = _vehicle getVariable ["CBA_attenuatedRoles", []];
_attenuationAPI append (getArray (_config >> "CBA_attenuatedRoles"));

if !(_attenuationAPI isEqualTo []) then {
    {
        _x params [["_configRole", "", [""]], ["_cargoOrTurretIndex", -1, [0]], ["_animation", "", [""]]];
        
        if (_configRole == _role && {_cargoOrTurretIndex isEqualTo _cargoIndex || _cargoOrTurretIndex isEqualTo _turretPath}) exitWith {
            _return = if !(_animation isEqualTo "") then {
                !((_vehicle animationSourcePhase _animation) > 0)
            } else {
                false // is always outside
            };
        };
    } forEach _attenuationAPI;
};

// Fix for vanilla tank commanders
if (!_return && {_role isEqualTo "commander"}) exitWith {[false, call _fnc_getAttenuationFromEffect]};

// This exit is crucial for the difference between FFV and Override and normale roles
if (!_return) exitWith {[true, 4]}; // return

if (_role in ["gunner", "turret"]) exitWith {
    [
        animationState _unit == getText (_turret >> "gunnerAction")
    ,
        call _fnc_getAttenuationFromEffect
    ]
};

if (_role isEqualTo "cargo") exitWith {
    private _attenuateCargo = getArray (_config >> "soundAttenuationCargo");

    // if attenuate array has less elements than the current cargo index, use the last value of the array
    private _cargoIndex = _cargoIndex min (count _attenuateCargo - 1);
    private _value = _attenuateCargo param [_cargoIndex, 1];

    if (_value == 1) then {
        [false, call _fnc_getAttenuationFromEffect]
    } else {
        [_value == 0, _value]
    }

};

// Specialcase
if (_role isEqualTo "gunner") exitWith {[true, call _fnc_getAttenuationFromEffect]}; // return

[false, call _fnc_getAttenuationFromEffect]
