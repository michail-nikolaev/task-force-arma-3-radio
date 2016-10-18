#include "script_component.hpp"

/*
    Name: TFAR_fnc_generateLrSettings

    Author(s):
        NKey
        L-H

    Description:
        Generates settings for the LR radio

    Parameters:
        OPTIONAL: BOOLEAN - false to generate settings without generating frequencies.

    Returns:
        ARRAY: Settings [
      0: NUMBER - Active channel,
      1: NUMBER - Volume,
      2: ARRAY - Frequencies for channels,
      3: NUMBER - Stereo setting,
      4: STRING - Encryption code,
      5: NUMBER - Additional active channel,
      6: NUMBER - Additional active channel stereo mode,
            7: NIL
      8: NUMBER - Speaker mode,
      9: BOOLEAN - On]

    Example:
        _settings = call TFAR_fnc_generateLrSettings;
*/
private _volume = 7;

private _lr_settings = [0, _volume, [], 0, nil, -1, 0, nil, false, true];
private _set = false;
private _lr_frequencies = [];
if (_this isEqualType true) then {
    if (!_this) then {
        for "_i" from 0 to TFAR_MAX_LR_CHANNELS step 1 do {
            _lr_frequencies set [_i, "50"];
        };
        _set = true;
    };
};
if (!_set) then {
    _lr_frequencies = [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};
_lr_settings set [2, _lr_frequencies];
_lr_settings
