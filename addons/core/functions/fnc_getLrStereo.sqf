#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getLrStereo
 *
 * Author: NKey
 * Gets the stereo setting of the passed radio
 *
 * Arguments:
 * 0: Radio object <OBJECT>
 * 1: Radio ID <STRING>
 *
 * Return Value:
 * Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>
 *
 * Example:
 * _stereo = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrStereo;
 *
 * Public: Yes
 */

(_this call TFAR_fnc_getLrSettings) param [TFAR_LR_STEREO_OFFSET,0]
