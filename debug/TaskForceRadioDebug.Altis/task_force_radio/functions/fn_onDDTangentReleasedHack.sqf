#include "script.h"
<<<<<<< HEAD
private ["_scancode", "_mods", "_keybind", "_scancode_dd"];
_scancode = _this select 1; 
_keybind = ["TFAR", "DDTransmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
	_mods = ((_keybind) select 5) select 1;
	_scancode_dd = ((_keybind) select 5) select 0;
	
	if (((_scancode == SHIFTL) and (_mods select 0))
	   or ((_scancode == CTRLL) and (_mods select 1))
	   or ((_scancode == ALTL) and (_mods select 2))
	   or (_scancode == _scancode_dd))
	then {
		call TFAR_fnc_onDDTangentReleased;
	};
=======
private ["_scancode"];
_scancode = _this select 1; 
if (((_scancode == SHIFTL) and (TF_tangent_dd_modifiers select 0))
   or ((_scancode == CTRLL) and (TF_tangent_dd_modifiers select 1))
   or ((_scancode == ALTL) and (TF_tangent_dd_modifiers select 2)))
then {
	call TFAR_fnc_onDDTangentReleased;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
false