#include "script_component.hpp"

/*
  Name: TFAR_fnc_getRadioChannelSettings

  Author: Darojax
    Returns the receive frequency (including encryption code), volume and
    stereo mode for each active channel of an SR or LR radio. The selected
    channel takes precedence when two channel slots use the same frequency.

  Arguments:
    Radio <STRING|ARRAY>

  Return Value:
    Channel settings: [[frequency, volume, stereo], ...] <ARRAY>

  Public: No
*/

private _isLrRadio = _this isEqualType [];
private _settings = _this call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);
private _radioCode = _this call ([TFAR_fnc_getSwRadioCode, TFAR_fnc_getLrRadioCode] select _isLrRadio);
private _channel = _settings param [ACTIVE_CHANNEL_OFFSET, 0];
private _additionalChannel = _settings param [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1];
private _frequencies = _settings param [TFAR_FREQ_OFFSET, []];
private _frequency = _frequencies param [_channel, ""];
private _volume = _settings param [VOLUME_OFFSET, 0];
private _additionalVolume = _settings param [TFAR_ADDITIONAL_VOLUME_OFFSET, _volume];
private _stereo = _settings param [[TFAR_SW_STEREO_OFFSET, TFAR_LR_STEREO_OFFSET] select _isLrRadio, 0];
private _additionalStereo = _settings param [TFAR_ADDITIONAL_STEREO_OFFSET, 0];
private _currentIsAdditional = _additionalChannel > -1 && {_additionalChannel isEqualTo _channel};
private _channels = [[
    _frequency + _radioCode,
    [_volume, _additionalVolume] select _currentIsAdditional,
    [_stereo, _additionalStereo] select _currentIsAdditional
]];

if (_additionalChannel > -1 && {!_currentIsAdditional}) then {
    private _additionalFrequency = _frequencies param [_additionalChannel, ""];
    if (_additionalFrequency isNotEqualTo _frequency) then {
        _channels pushBack [_additionalFrequency + _radioCode, _additionalVolume, _additionalStereo];
    };
};

_channels
