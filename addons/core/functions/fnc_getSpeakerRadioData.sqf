#include "script_component.hpp"

/*
  Name: TFAR_fnc_getSpeakerRadioData

  Author: Darojax
    Builds one existing-protocol speaker record per receive frequency, so
    main and additional channels retain their independent volumes.

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

(_radio call TFAR_fnc_getRadioChannelSettings) apply {
    _x params ["_frequency", "_volume"];
    private _entry = [_radioId, _frequency, _nickname, _position, _volume, _vehicle];
    if (_includeWaveZ) then {
        _entry pushBack _waveZ;
    };
    _entry joinString TF_new_line
}
