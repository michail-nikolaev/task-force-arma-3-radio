#include "script.h"
private ["_scancode", "_mods"];
_scancode = _this select 1; 
_mods = (cba_keybinding_handlers select (["TFAR", "SW Transmit"] call cba_fnc_getKeybind)) select 2;
if (_scancode == _mods select 0) then {
	call TFAR_fnc_onSwTangentReleased;
};
false