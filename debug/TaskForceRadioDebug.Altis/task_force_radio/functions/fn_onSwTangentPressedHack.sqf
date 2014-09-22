#include "script.h"
private ["_scancode", "_mods", "_mods_lr", "_is_lr"];
if !(call TFAR_fnc_isAbleToUseRadio) then {
	_scancode = _this select 1; 
	_mods = (cba_keybinding_handlers select (["TFAR", "SW Transmit"] call cba_fnc_getKeybind)) select 2;
	_mods_lr = (cba_keybinding_handlers select (["TFAR", "LR Transmit"] call cba_fnc_getKeybind)) select 2;
	
	_is_lr = (_this select 2 && _mods_lr select 1) || (_this select 3 && _mods_lr select 2) || (_this select 4 && _mods_lr select 3);	
	
	if ((_scancode == _mods select 0) and !(_is_lr)) then {
		call TFAR_fnc_onSwTangentPressed;
	};
};
false