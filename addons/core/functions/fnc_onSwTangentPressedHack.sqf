#include "script.h"
private ["_scancode", "_mods", "_mods_lr", "_is_lr", "_sw_keybind", "_lr_keybind", "_scancode_lr"];
if !(call TFAR_fnc_isAbleToUseRadio) then {
	_scancode = _this select 1; 
	_sw_keybind = ["TFAR", "SWTransmit"] call cba_fnc_getKeybind;
	_lr_keybind = ["TFAR", "LRTransmit"] call cba_fnc_getKeybind;
	if (!(isNil "_sw_keybind") and !(isNil "_lr_keybind")) then { 
		_mods = ((_sw_keybind) select 5) select 1;
		_mods_lr = ((_lr_keybind) select 5) select 1;
		_scancode_lr = ((_lr_keybind) select 5) select 0;
		
		_is_lr = (_this select 2 && _mods_lr select 0) || (_this select 3 && _mods_lr select 1) || (_this select 4 && _mods_lr select 2);
		if ((_scancode == _scancode_lr) and !(_is_lr) and !(_mods select 0) and !(_mods select 1) and !(_mods select 2)) then {
			call TFAR_fnc_onSwTangentPressed;
		};
	};
};
false