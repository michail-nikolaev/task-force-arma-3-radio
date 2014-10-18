#include "script.h"
private ["_scancode", "_mods", "_keybind"];
_scancode = _this select 1; 
_keybind = ["TFAR", "SW Transmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
	_mods = (cba_keybinding_handlers select _keybind) select 2;
	if (_scancode == _mods select 0) then {
		call TFAR_fnc_onSwTangentReleased;
	};
};
false