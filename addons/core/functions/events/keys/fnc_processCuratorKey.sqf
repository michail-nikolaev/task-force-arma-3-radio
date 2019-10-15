#include "script_component.hpp"

params ["_pressed", "_key"];

private _result = false;
private _keyup = _key isEqualTo 'keyup';

private _processKeys = {
    if ([_key, "tfar_"] call CBA_fnc_find == 0) then {
        _value params ["_key_pressed", "_mods", "_handler"];

        if ((_key_pressed == _pressed select 1) and {(_mods select 0) isEqualTo (_pressed select 2)} and {(_mods select 1) isEqualTo  (_pressed select 3)} and {(_mods select 2) isEqualTo (_pressed select 4)}) exitWith {
            _result = call _handler;
        };
     };
};

[if (_keyup) then {cba_events_keyhandlers_up} else {cba_events_keyhandlers_down}, _processKeys] call CBA_fnc_hashEachPair;

_result;
