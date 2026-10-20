#include "script_component.hpp"

/*
  Name: TFAR_fnc_normalizeFrequency

  Author: Darojax
    Returns a frequency-name lookup key using the same range and rounding as
    radio frequency entry. Invalid frequencies return an empty string.

  Arguments:
    0: Frequency <NUMBER|STRING>
    1: Is long-range frequency <BOOL>

  Return Value:
    Canonical frequency, or an empty string <STRING>

  Public: No
*/

params [
    ["_frequency", "", [0, ""]],
    ["_isLrRadio", false, [false]]
];

private _number = if (_frequency isEqualType "") then {
    TFAR_FREQUENCYSTRING_TO_FREQNUMBER(_frequency)
} else {
    _frequency
};
private _minimum = [TFAR_MIN_SW_FREQ, TFAR_MIN_ASIP_FREQ] select _isLrRadio;
private _maximum = [TFAR_MAX_SW_FREQ, TFAR_MAX_ASIP_FREQ] select _isLrRadio;
if !(_number >= _minimum && {_number <= _maximum}) exitWith {""};

QTFAR_ROUND_FREQUENCY(_number)
