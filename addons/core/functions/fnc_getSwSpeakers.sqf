#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getSwSpeakers
 *
 * Author: NKey
 * Gets the speakers setting of the passed radio
 *
 * Arguments:
 * 0: Radio classname <STRING>
 *
 * Return Value:
 * speakers or headphones <BOOL>
 *
 * Example:
 * _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getSwSpeakers;
 *
 * Public: Yes
 */
params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [TFAR_SW_SPEAKER_OFFSET, false]
