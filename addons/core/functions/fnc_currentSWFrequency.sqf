#include "script_component.hpp"

/*
 * Name: TFAR_fnc_currentSWFrequency
 *
 * Author: NKey
 * Returns current Frequency of the active SR Radio
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Frequency of active SR Radio <STRING>
 *
 * Example:
 * _SRFrequency = call TFAR_fnc_currentSWFrequency
 *
 * Public: Yes
 */

(call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwFrequency
