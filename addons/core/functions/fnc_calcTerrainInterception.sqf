#include "script_component.hpp"

/*
  Name: TFAR_fnc_calcTerrainInterception

  Author: NKey
    Calculates the terrain interception between the player and the passed unit.

  Arguments:
    0: Unit to calculate terrain interception with. <OBJECT>

  Return Value:
    Terrain Interception <SCALAR>

  Example:
    _interception = soldier2 call TFAR_fnc_calcTerrainInterception;

  Public: No
 */

private _result = 0;
private _p1 = eyePos TFAR_currentUnit;
private _p2 = eyePos _this;

if (terrainIntersectASL[_p1, _p2]) then {
    private _l = 10.0;
    private _r = 250.0;
    private _m = 100.0;

    private _middle = [((_p1 select 0) + (_p2 select 0)) / 2.0, ((_p1 select 1) + (_p2 select 1)) / 2.0, ((_p1 select 2) + (_p2 select 2)) / 2.0];
    private _base = _middle select 2;

    while {(_r - _l) > 10} do {
        _middle set[2, _base + _m];
        if ((!terrainIntersectASL [ _p1, _middle ]) and {!terrainIntersectASL [ _p2, _middle ]}) then {
            _r = _m;
        } else {
            _l = _m;
        };
        _m = (_l + _r) / 2.0;
    };
    _result = _m;
};
_result
