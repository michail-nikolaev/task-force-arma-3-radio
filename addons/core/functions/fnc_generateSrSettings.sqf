#include "script_component.hpp"

/*
 * Name: TFAR_fnc_generateSRSettings
 *
 * Author: NKey, Garth de Wet (L-H)
 * Generates settings for the LR radio
 *
 * Arguments:
 * 0: false to generate settings without generating frequencies. <BOOL> (Default: true)
 *
 * Return Value:
 * 0: active channel <NUMBER>
 * 1: Volume <NUMBER>
 * 2: Frequencies for channels <ARRAY>
 * 3: Stereo setting <NUMBER>
 * 4: Encryption code <STRING>
 * 5: Additional active channel <NUMBER>
 * 6: Additional active channel stereo mode <NUMBER>
 * 7: Owner's UID <STRING>
 * 8: Speaker mode <NUMBER>
 * 9: turned on <BOOL>
 *
 * Example:
 * _settings = call TFAR_fnc_generateSRSettings;
 *
 * Public: Yes
 */
//#TODO set default Radio code instead of using nil
private _sw_settings = [0, TFAR_default_radioVolume, [], 0, nil, -1, 0, getPlayerUID player, false, true];
private _set = false;
private _sw_frequencies = [];

if (_this isEqualType true) then {
    if (!_this) then {
        for "_i" from 0 to TFAR_MAX_CHANNELS step 1 do {
            _sw_frequencies set [_i, "50"];
        };
        _set = true;
    };
};
if (!_set) then {
    _sw_frequencies = [TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};
_sw_settings set [2, _sw_frequencies];

_sw_settings
