#include "script.h"
private ["_scancode", "_scancode_sw", "_keybind"];
_scancode = _this select 1; 
_keybind = ["TFAR", "SWTransmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
	_scancode_sw = ((_keybind) select 5) select 0;
	if (_scancode == _scancode_sw) then {
		call TFAR_fnc_onSwTangentReleased;
	};
};
false