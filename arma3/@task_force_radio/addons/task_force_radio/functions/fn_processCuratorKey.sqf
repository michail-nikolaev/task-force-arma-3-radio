private ["_keys", "_pressed", "_result"];
_pressed = _this select 0;
_result = false;
{		
	if (_x select 0 == "TFAR") then {
		_keys = _x select 2;				
		if ((_keys select 0 == _pressed select 1) and {(_keys select 1) isEqualTo (_pressed select 2)} and {(_keys select 2) isEqualTo  (_pressed select 3)} and {(_keys select 3) isEqualTo (_pressed select 4)}) exitWith {			
			_result = _this call CBA_events_fnc_keyHandler;
		};
	};
	true;
} count cba_keybinding_handlers;
_result;