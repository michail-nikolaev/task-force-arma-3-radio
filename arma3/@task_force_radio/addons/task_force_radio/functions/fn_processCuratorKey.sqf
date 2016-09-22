private ["_keys", "_pressed", "_result", "_keyup"];

_pressed = _this select 0;
_result = false;
_keyup = (_this select 1) isEqualTo 'keyup';

_processKeys = {
	private ["_mods", "_key_pressed", "_handler"];
	
	if ([_key, "tfar_"] call CBA_fnc_find == 0) then {

		_key_pressed = _value select 0;
		_mods = _value select 1;
		_handler = _value select 2;	
					
		if ((_key_pressed == _pressed select 1) and {(_mods select 0) isEqualTo (_pressed select 2)} and {(_mods select 1) isEqualTo  (_pressed select 3)} and {(_mods select 2) isEqualTo (_pressed select 4)}) exitWith {			
			_result = call _handler;
		};		 
	 };
};

[if (_keyup) then {cba_events_keyhandlers_up} else {cba_events_keyhandlers_down}, _processKeys] call CBA_fnc_hashEachPair;

_result;