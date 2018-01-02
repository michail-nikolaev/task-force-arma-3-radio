#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getSwStereo
 *
 * Author: NKey
 * Gets the stereo setting of the passed radio
 *
 * Arguments:
 * Radio classname <STRING>
 *
 * Return Value:
 * Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right) <NUMBER>
 *
 * Example:
 * _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwStereo;
 *
 * Public: Yes
 */

params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [TFAR_SW_STEREO_OFFSET,0]
