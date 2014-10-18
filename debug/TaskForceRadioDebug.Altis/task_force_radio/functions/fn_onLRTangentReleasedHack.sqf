#include "script.h"
private ["_scancode", "_mods", "_keybind"];
_scancode = _this select 1; 
_keybind = ["TFAR", "LR Transmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
	_mods = (cba_keybinding_handlers select _keybind) select 2;
	if (((_scancode == SHIFTL) and (_mods select 1))
	   or ((_scancode == CTRLL) and (_mods select 2))
	   or ((_scancode == ALTL) and (_mods select 3))
	   or (_scancode == _mods select 0))
	 then {	
		call TFAR_fnc_onLRTangentReleased;
	};
};
false