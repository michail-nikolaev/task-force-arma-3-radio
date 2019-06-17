#include "script_component.hpp"

/*
  Name: TFAR_fnc_processLRStereoKeys

  Author: JonBons, Nkey, Garth de Wet (L-H)
    Switches the LR stereo setting on the active LR radio.

  Arguments:
    0: Stereo number : Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_processLRStereoKeys;

  Public: No
*/

params ["_lr_stereo_number"];

private _result = false;

if ((alive TFAR_currentUnit) and {call TFAR_fnc_haveLRRadio}) then {
    private _radio = call TFAR_fnc_activeLrRadio;
    playSound "TFAR_rotatorPush";
    [_radio, _lr_stereo_number] call TFAR_fnc_setLrStereo;
    [_radio] call TFAR_fnc_showRadioVolume;
    _result = true;
};
_result
