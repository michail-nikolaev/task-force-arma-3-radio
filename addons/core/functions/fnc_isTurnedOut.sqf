#include "script_component.hpp"

/*
  Name: TFAR_fnc_isTurnedOut

  Author: NKey
    returns if a unit is turened out

  Arguments:
    0: unit <OBJECT>

  Return Value:
    is turned out <BOOL>

  Example:
    [_unit] call TFAR_fnc_isTurnedOut;

  Public: No
 */

params ["_unit"];

//This is bad performance.. prefer using isTurnedOut directly
//TFAR_fnc_isTurnedOut is 0.0122ms vs isTurnedOut 0.0023ms

if (vehicle _unit == _unit) exitWith {true;};

isTurnedOut _unit;


/*
// by commy2 v0.4
private _fnc_getTurrets = {
    params ["_vehicle"];

    private _config = configFile >> "CfgVehicles" >> typeOf _vehicle;
    private _turrets = [];

    _fnc_addTurret = {
            private ["_config", "_path", "_count", "_index"];

            params ["_config", "_path"];

            _config = _config >> "Turrets";
            private _count = count _config;

            for "_index" from 0 to (_count - 1) do {
                _turrets set [count _turrets, _path + [_index]];
                [_config select _index, [_index]] call _fnc_addTurret;
            };
    };

    [_config, []] call _fnc_addTurret;

    _turrets
};

private _fnc_getTurretIndex = {
    params ["_unit"];

    private _vehicle = vehicle _unit;
    private _turrets = [_vehicle] call _fnc_getTurrets;
    private _units = [];

    {
            _units set [count _units, _vehicle turretUnit _x];
    } forEach _turrets;

    private _index = _units find _unit;

    if (_index == -1) exitWith {[]};

    _turrets select _index;
};



private _vehicle = vehicle _unit;
private _config = configFile >> "CfgVehicles" >> typeOf _vehicle;
private _result = false;

if (_vehicle == _unit) then {
    _result = true;
} else {
    if ((driver _vehicle == _unit) && {getNumber(_config >> "forceHideDriver") == 1}) then {
        _result = false;
    } else {
        if ((commander _vehicle == _unit) && {getNumber(_config >> "forceHideCommander") == 1}) then {
            _result = false;
        } else {
            private _animation = animationState _unit;
            private _action = "";
            private _inAction = "";

            if (_unit == driver _vehicle) then {
                _action = getText (_config >> "driverAction");
                _inAction = getText (_config >> "driverInAction");
            } else {
                private _turretIndex = [_unit] call _fnc_getTurretIndex;
                private _count = count _turretIndex;

                for "_index" from 0 to (_count - 1) do {
                    _config = _config >> "Turrets";
                    _config = _config select (_turretIndex select _index);
                };

                _action = getText (_config >> "gunnerAction");
                _inAction = getText (_config >> "gunnerInAction");
            };

            if (_action == "" || {_inAction == ""} || {_action == _inAction}) exitWith {_result = false};

            _animation = toArray _animation;
            _animation resize (count toArray _action);
            _animation = toString _animation;
            _result = (_animation == _action);
        };
    };
};

*/
