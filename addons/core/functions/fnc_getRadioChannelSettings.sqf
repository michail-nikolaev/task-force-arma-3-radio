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
if (isNil "_settings") exitWith {[]};
if (!isNil {_settings param [POWER_OFFSET]} && {!(_settings select POWER_OFFSET)}) exitWith {[]};

private _frequencies = _settings param [TFAR_FREQ_OFFSET, []];
private _channelCount = count _frequencies;
if (_channelCount == 0) exitWith {[]};

private _radioCode = _this call ([TFAR_fnc_getSwRadioCode, TFAR_fnc_getLrRadioCode] select _isLrRadio);
private _channel = _settings param [ACTIVE_CHANNEL_OFFSET, 0];
private _additionalChannel = _settings param [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1];
private _mainVolume = _settings param [VOLUME_OFFSET, 0];
private _mainFrequency = "";
private _channels = [];

// A selected additional slot uses its own volume and stereo, even as the only receiver.
if (_channel != _additionalChannel && {_channel >= 0} && {_channel < _channelCount}) then {
    _mainFrequency = format ["%1", _frequencies param [_channel, "", ["", 0]]];
    if (_mainFrequency != "") then {
        private _stereoOffset = [TFAR_SW_STEREO_OFFSET, TFAR_LR_STEREO_OFFSET] select _isLrRadio;
        _channels pushBack [_mainFrequency + _radioCode, _mainVolume, _settings param [_stereoOffset, 0]];
    };
};

if (_additionalChannel >= 0 && {_additionalChannel < _channelCount}) then {
    private _frequency = format ["%1", _frequencies param [_additionalChannel, "", ["", 0]]];
    if (_frequency != "" && {_frequency isNotEqualTo _mainFrequency}) then {
        _channels pushBack [
            _frequency + _radioCode,
            _settings param [TFAR_ADDITIONAL_VOLUME_OFFSET, _mainVolume],
            _settings param [TFAR_ADDITIONAL_STEREO_OFFSET, 0]
        ];
    };
};

_channels
