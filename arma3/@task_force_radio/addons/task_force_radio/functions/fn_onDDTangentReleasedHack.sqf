#include "script.h"
private ["_scancode", "_mods"];
_scancode = _this select 1; 
_mods = (cba_keybinding_handlers select (["TFAR", "DD Transmit"] call cba_fnc_getKeybind)) select 2;
if (((_scancode == SHIFTL) and (_mods select 1))
   or ((_scancode == CTRLL) and (_mods select 2))
   or ((_scancode == ALTL) and (_mods select 3)))
then {
	call TFAR_fnc_onDDTangentReleased;
};
false