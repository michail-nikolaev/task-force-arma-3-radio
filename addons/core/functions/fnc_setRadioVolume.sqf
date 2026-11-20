#include "script_component.hpp"

/*
  Name: TFAR_fnc_setRadioVolume

  Stores a main or additional listening volume for a handheld or LR radio.
  The public volume setters send their respective events after this write.

  Arguments:
    0: Radio <STRING|ARRAY>
    1: Volume <NUMBER>
    2: Additional channel <BOOL> (default: false)

  Return Value:
    None

  Public: No
*/
params ["_radio", "_volume", ["_additional", false]];

private _isLrRadio = _radio isEqualType [];
private _settings = _radio call ([TFAR_fnc_getSwSettings, TFAR_fnc_getLrSettings] select _isLrRadio);

// Appending a volume to a pre-power settings array must preserve its default on state.
if (isNil {_settings param [POWER_OFFSET]}) then {
    _settings set [POWER_OFFSET, true];
};
// Older radios inherit the main volume until their two levels first diverge.
if (!_additional && {isNil {_settings param [TFAR_ADDITIONAL_VOLUME_OFFSET]}}) then {
    _settings set [TFAR_ADDITIONAL_VOLUME_OFFSET, _settings param [VOLUME_OFFSET, 0]];
};
_settings set [[VOLUME_OFFSET, TFAR_ADDITIONAL_VOLUME_OFFSET] select _additional, _volume];
[_radio, _settings] call ([TFAR_fnc_setSwSettings, TFAR_fnc_setLrSettings] select _isLrRadio);
