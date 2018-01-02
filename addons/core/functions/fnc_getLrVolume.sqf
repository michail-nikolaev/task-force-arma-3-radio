#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getLrVolume
 *
 * Author: NKey
 * Gets the volume of the passed radio
 *
 * Arguments:
 * 0: Radio object <OBJECT>
 * 1: Radio ID <STRING>
 *
 * Return Value:
 * Volume : range (0,10) <NUMBER>
 *
 * Example:
 * _volume = (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrVolume;
 *
 * Public: Yes
 */

(_this call TFAR_fnc_getLrSettings) param [VOLUME_OFFSET,0]
