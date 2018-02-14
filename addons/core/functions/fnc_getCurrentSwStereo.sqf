#include "script_component.hpp"

/*
  Name: TFAR_fnc_getCurrentSwStereo

  Author: NKey
    Gets the stereo setting of current channel (special logic for additional) the passed radio

  Arguments:
    0: Radio classname <STRING>

  Return Value:
    Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>

  Example:
    _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getCurrentSwStereo;

  Public: Yes
 */
params[["_radio", "", [""]]];

if ((_this call TFAR_fnc_getAdditionalSwChannel) == (_this call TFAR_fnc_getSwChannel)) exitWith {
    _radio call TFAR_fnc_getAdditionalSwStereo;
};

_radio call TFAR_fnc_getSwStereo;
