#include "script.h"
private ["_scancode"];
_scancode = _this select 1; 
if (((_scancode == CTRLL) and (tangent_dd_ctrl == 1))
   or ((_scancode == ALTL) and (tangent_dd_alt == 1))
   or ((_scancode == SHIFTL) and (tangent_dd_shift == 1)))
 then {
	call TFAR_fnc_onDDTangentReleased;
};
false