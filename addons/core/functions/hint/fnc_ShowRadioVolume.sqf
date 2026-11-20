#include "script_component.hpp"

/*
  Name: TFAR_fnc_ShowRadioVolume

  Author: Garth de Wet (L-H)
    shows the radio volume

  Arguments:
    0: Radio <ARRAY|STRING>
    1: Show additional channel volume first <BOOL> (default: false)
    2: Show speaker status in place of stereo modes <BOOL> (default: false)

  Return Value:
    None

  Example:
    // LR radio
    [(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_showRadioVolume;
    // SW radio
    [(call TFAR_fnc_activeSwRadio)] call TFAR_fnc_showRadioVolume;

  Public: Yes
*/
params ["_radio", ["_additionalFirst", false, [true]], ["_showSpeakers", false, [true]]];

private _isLrRadio = _radio isEqualType [];
private _radioClass = if (_isLrRadio) then {typeOf (_radio select 0)} else {_radio};
private _getProperty = [DFUNC(getWeaponConfigProperty), DFUNC(getVehicleConfigProperty)] select _isLrRadio;
private _name = [_radioClass, "displayName", ""] call _getProperty;
private _picture = [_radioClass, "picture", ""] call _getProperty;
private _imageSize = [1.6, 1] select (_isLrRadio && {!((_radio select 0) isKindOf "Bag_Base")});

private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);
private _mainVolume = _settings param [VOLUME_OFFSET, 0];
private _lines = [format [localize LSTRING(radio_volume), (_mainVolume + 1) * 10]];
private _hasAdditional = (_settings param [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1]) >= 0;
if (_hasAdditional) then {
    private _additionalVolume = _settings param [TFAR_ADDITIONAL_VOLUME_OFFSET, _mainVolume];
    _lines pushBack format [localize LSTRING(additional_radio_volume), (_additionalVolume + 1) * 10];
    if (_additionalFirst) then {reverse _lines};
};

if (_showSpeakers) then {
    _lines pushBack localize format [LSTRING(speakers_settings_%1), _settings param [SPEAKER_OFFSET, false]];
} else {
    private _stereoOffset = [TFAR_SW_STEREO_OFFSET, TFAR_LR_STEREO_OFFSET] select _isLrRadio;
    _lines pushBack localize format [LSTRING(stereo_settings_%1), _settings param [_stereoOffset, 0]];
    if (_hasAdditional) then {
        private _stereo = localize format [LSTRING(additional_stereo_settings_%1), _settings param [TFAR_ADDITIONAL_STEREO_OFFSET, 0]];
        _lines pushBack format ["<t size='0.8'>%1</t>", _stereo];
    };
};

private _hint = format ["<t align='center'>%1 <img size='%2' image='%3'/><br />%4</t>",
    _name select [0, MAX_RADIONAME_LEN], _imageSize, _picture, _lines joinString "<br />"];
[parseText _hint, 5] call TFAR_fnc_showHint;
