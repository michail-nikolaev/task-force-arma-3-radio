#include "script_component.hpp"

private _scancode = _this select 1;
private _keybind = ["TFAR", "SWTransmit"] call cba_fnc_getKeybind;
if !(isNil "_keybind") then {
    private _scancode_sw = ((_keybind) select 5) select 0;
    if (_scancode == _scancode_sw) then {
        call TFAR_fnc_onSwTangentReleased;
    };
};
false
