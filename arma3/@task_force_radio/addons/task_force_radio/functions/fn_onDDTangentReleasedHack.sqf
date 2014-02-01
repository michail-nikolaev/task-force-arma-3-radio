#include "script.h"
private ["_scancode"];
_scancode = _this select 1; 
if (((_scancode == CTRLL) and (TF_tangent_dd_modifiers select 1))
   or ((_scancode == ALTL) and (TF_tangent_dd_modifiers select 2))
   or ((_scancode == SHIFTL) and (TF_tangent_dd_modifiers select 0)))
 then {
	call TFAR_fnc_onDDTangentReleased;
};
false