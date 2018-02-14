#include "script_component.hpp"

/*
  Name: TFAR_fnc_processLRChannelKeys

  Author: Nkey, Garth de Wet (L-H)
    Switches the active LR radio to the passed channel.

  Arguments:
    0: Channel : Range (0,8) <NUMBER>

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_processLRChannelKeys;

  Public: No
*/

params ["_lr_channel_number"];

private _result = false;

if ((call TFAR_fnc_haveLRRadio) and {alive TFAR_currentUnit}) then {
    private _active_lr = call TFAR_fnc_activeLrRadio;
    [_active_lr, _lr_channel_number] call TFAR_fnc_setLrChannel;
    playSound "TFAR_rotatorPush";
    if (TFAR_showChannelChangedHint) then {[_active_lr, true] call TFAR_fnc_showRadioInfo;};
    if (dialog) then {
        call compile ([_active_lr select 0, "tf_dialogUpdate"] call TFAR_fnc_getLrRadioProperty);
    };
    _result = true;
};
_result
