#include "script_component.hpp"

/*
 * Name: TFAR_fnc_generateFrequencies
 *
 * Author: NKey, L-H, Dorbedo
 * Generates frequencies based on the passed parameters to be used in radio settings.
 *
 * Arguments:
 * 0: Channels <SCALAR>
 * 0: Max frequency <SCALAR>
 * 0: Min frequency <SCALAR>
 * 0: Frequency Round Power <SCALAR>
 *
 * Return Value:
 * Frequencies for channels <ARRAY>
 *
 * Example:
 *      // LR
 *      _frequencies = [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
 *       // SW
 *      _sw_frequencies = [TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
 *
 * Public: Yes
 */

params ["_channels", "_max_freq", "_min_freq", "_freq_rp"];

private _frequencies = [];

for "_i" from 0 to _channels step 1 do {
    _frequencies pushBack ((random (_max_freq - _min_freq)) + _min_freq);
};

_frequencies apply {QTFAR_ROUND_FREQUENCYP(_x, _freq_rp)}
