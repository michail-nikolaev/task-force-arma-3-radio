#include "script_component.hpp"

/*
    Name: TFAR_fnc_generateSwSettings

    Author(s):
        NKey
        L-H

    Description:
        Generates settings for the SW radio

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
      7: STRING - Owner's UID,
      8: NUMBER - Speaker mode,
      9: BOOLEAN - On]

    Example:
        _settings = call TFAR_fnc_generateSwSettings;
*/

private _volume = 7;
if (isNumber (ConfigFile >> "task_force_radio_settings" >> "tf_default_radioVolume")) then {
    _volume = getNumber(ConfigFile >> "task_force_radio_settings" >> "tf_default_radioVolume")
};
private _sw_settings = [0, _volume, [], 0, nil, -1, 0, getPlayerUID player, false, true];
private _set = false;
private _sw_frequencies = [];

if (_this isEqualType true) then {
    if (!_this) then {
        for "_i" from 0 to TF_MAX_CHANNELS step 1 do {
            _sw_frequencies set [_i, "50"];
        };
        _set = true;
    };
};
if (!_set) then {
    _sw_frequencies = [TF_MAX_CHANNELS,TF_MAX_SW_FREQ,TF_MIN_SW_FREQ,TF_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};
_sw_settings set [2, _sw_frequencies];

_sw_settings
