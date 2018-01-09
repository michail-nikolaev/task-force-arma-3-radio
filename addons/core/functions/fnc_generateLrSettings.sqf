#include "script_component.hpp"

/*
  Name: TFAR_fnc_generateLrSettings

  Author: NKey, Garth de Wet (L-H)
    Generates settings for the LR radio

  Arguments:
    0: false to generate settings without generating frequencies. <BOOL> (Default: true)

  Return Value:
    0: active channel <NUMBER>
    1: Volume <NUMBER>
    2: Frequencies for channels <ARRAY>
    3: Stereo setting <NUMBER>
    4: Encryption code <STRING>
    5: Additional active channel <NUMBER>
    6: Additional active channel stereo mode <NUMBER>
    7: Empty <NIL>
    8: Speaker mode <NUMBER>
    9: turned on <BOOL>

  Example:
    _settings = call TFAR_fnc_generateLrSettings;

  Public: Yes
 */

params [["_generateFrequencies", true, [true]]];

private _lr_settings = [0, TFAR_default_radioVolume, [], 0, nil, -1, 0, nil, false, true];
private _lr_frequencies = [];
if (!_generateFrequencies) then {
    for "_i" from 0 to TFAR_MAX_LR_CHANNELS step 1 do {
        _lr_frequencies set [_i, "50"];
    };
} else {
    _lr_frequencies = [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};
_lr_settings set [2, _lr_frequencies];
_lr_settings
