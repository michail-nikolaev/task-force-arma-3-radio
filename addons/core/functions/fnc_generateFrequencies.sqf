#include "script_component.hpp"

/*
    Name: TFAR_fnc_generateFrequencies

    Author(s):
        NKey, L-H, Dorbedo

    Description:
        Generates frequencies based on the passed parameters to be used in radio settings.

    Parameters:
        0: NUMBER - Channels
        1: NUMBER - Max frequency
        2: NUMBER - Min frequency
        3: NUMBER - Frequency Round Power

    Returns:
        ARRAY: Frequencies for channels

    Example:
        // LR
        _frequencies = [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
        // SW
        _sw_frequencies = [TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
*/

params ["_channels", "_max_freq", "_min_freq", "_freq_rp"];

private _frequencies = [];

for "_i" from 0 to _channels step 1 do {
    _frequencies pushBack ((random (_max_freq - _min_freq)) + _min_freq);
};

_frequencies apply {QTFAR_ROUND_FREQUENCYP(_x, _freq_rp)}
