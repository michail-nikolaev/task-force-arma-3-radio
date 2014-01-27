#include "script.h"
private ["_scancode"];
_scancode = _this select 1; 
if (((_scancode == CTRLL) and (tangent_lr_ctrl == 1))
   or ((_scancode == ALTL) and (tangent_lr_alt == 1))
   or ((_scancode == SHIFTL) and (tangent_lr_shift == 1)))
 then {
	call TFAR_fnc_onLRTangentReleased;
};
false