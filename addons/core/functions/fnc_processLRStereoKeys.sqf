#include "script_component.hpp"

/*
    Name: TFAR_fnc_processLRStereoKeys

    Author(s):


    Description:
        Switches the LR stereo setting on the active LR radio.

    Parameters:
        0: NUMBER - Stereo number : Range (0,2) (0 - Both, 1 - Left, 2 - Right)

    Returns:
        BOOLEAN - if handled or not.

    Example:
        Called via CBA onKey EventHandler
*/

params ["_lr_stereo_number"];

private _result = false;

if ((alive TFAR_currentUnit) and {call TFAR_fnc_haveLRRadio}) then {
    private _radio = call TFAR_fnc_activeLrRadio;
    [_radio select 0, _radio select 1, _lr_stereo_number] call TFAR_fnc_setLrStereo;
    [_radio] call TFAR_fnc_ShowRadioVolume;
    _result = true;
};
_result
