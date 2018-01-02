#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setLongRangeRadioFrequency
 *
 * Author: NKey
 * Sets the frequency for the active channel on the active LR radio.
 *
 * Arguments:
 * Frequency <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * "45.48" call TFAR_fnc_setLongRangeRadioFrequency;
 *
 * Public: Yes
 */

if (call TFAR_fnc_haveLRRadio) then {
    [call TFAR_fnc_activeLrRadio, _this] call TFAR_fnc_setLrFrequency;
};
