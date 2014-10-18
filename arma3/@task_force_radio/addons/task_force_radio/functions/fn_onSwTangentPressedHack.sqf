#include "script.h"
private ["_scancode", "_mods", "_mods_lr", "_is_lr", "_sw_keybind", "_lr_keybind"];
if !(call TFAR_fnc_isAbleToUseRadio) then {
	_scancode = _this select 1; 
	_sw_keybind = ["TFAR", "SW Transmit"] call cba_fnc_getKeybind;
	_lr_keybind = ["TFAR", "LR Transmit"] call cba_fnc_getKeybind;
	if (!(isNil "_sw_keybind") and !(isNil "_lr_keybind")) then { 
		_mods = (cba_keybinding_handlers select (_sw_keybind)) select 2;
		_mods_lr = (cba_keybinding_handlers select (_lr_keybind)) select 2;
		
		_is_lr = (_this select 2 && _mods_lr select 1) || (_this select 3 && _mods_lr select 2) || (_this select 4 && _mods_lr select 3);		
		if ((_scancode == _mods select 0) and !(_is_lr) and !(_mods select 1) and !(_mods select 2) and !(_mods select 3)) then {
			call TFAR_fnc_onSwTangentPressed;
		};
	};
};
false