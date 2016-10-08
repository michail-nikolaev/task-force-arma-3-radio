#include "script_component.hpp"

private _scancode = param [1];
private _keybind = ["TFAR", "DDTransmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
    private _mods = ((_keybind) select 5) select 1;
    private _scancode_dd = ((_keybind) select 5) select 0;

    if (((_scancode == SHIFTL) and (_mods select 0))
       or ((_scancode == CTRLL) and (_mods select 1))
       or ((_scancode == ALTL) and (_mods select 2))
       or (_scancode == _scancode_dd))
    then {
        call TFAR_fnc_onDDTangentReleased;
    };
};
false
