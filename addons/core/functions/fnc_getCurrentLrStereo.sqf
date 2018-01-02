#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getCurrentLrStereo
 *
 * Author: NKey
 * Gets the stereo of current channel (special logic for additional) setting of the passed radio
 *
 * Arguments:
 * 0: Radio object <OBJECT>
 * 1: Radio ID <STRING>
 *
 * Return Value:
 * Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>
 *
 * Example:
 * _stereo = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getCurrentLrStereo;
 *
 * Public: Yes
 */

if ((_this call TFAR_fnc_getAdditionalLrChannel) == (_this call TFAR_fnc_getLrChannel)) exitWith {
    _this call TFAR_fnc_getAdditionalLrStereo;
};

_this call TFAR_fnc_getLrStereo
