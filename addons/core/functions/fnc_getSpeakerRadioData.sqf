#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSpeakerRadioData

  Author: Darojax
    Builds speaker records for the plugin. Frequencies at the same volume
    can share one record and its position and owner information.

  Arguments:
    0: Radio <STRING|ARRAY>
    1: Radio ID <STRING>
    2: Owner nickname <STRING>
    3: Position (empty for a carried radio) <ARRAY>
    4: Vehicle descriptor <STRING>
    5: Water height <NUMBER> (optional)

  Return Value:
    Encoded speaker records <ARRAY>

  Public: No
*/

params ["_radio", "_radioId", "_nickname", "_position", "_vehicle"];
private _includeWaveZ = count _this > 5;
private _waveZ = _this param [5, 0];

private _channels = _radio call TFAR_fnc_getRadioChannelSettings;
if (count _channels == 2) then {
    _channels params ["_main", "_additional"];
    if ((_main select 1) == (_additional select 1)) then {
        _main set [0, [_main select 0, _additional select 0] joinString "|"];
        _channels resize 1;
    };
};

_channels apply {
    _x params ["_frequency", "_volume"];
    private _entry = [_radioId, _frequency, _nickname, _position, _volume, _vehicle];
    if (_includeWaveZ) then {
        _entry pushBack _waveZ;
    };
    _entry joinString TF_new_line
}
