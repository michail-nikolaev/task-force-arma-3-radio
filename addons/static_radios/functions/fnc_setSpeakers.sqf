#include "script_component.hpp"

/*
  Name: TFAR_static_radios_fnc_setSpeakers

  Author: Dedmen
    takes radio classnames and returns instanciated classnames (with _ID appended)

  Arguments:
    0: the weaponholder containing the radio <OBJECT>
    1: speaker enabled <BOOL>

  Return Value:
    None

  Example:
    ["TFAR_anprc_152_3",true] call TFAR_static_radios_fnc_setSpeakers;

  Public: No
*/
params ["_radioContainer","_enabled"];

_radio_id = _radioContainer call TFAR_static_radios_fnc_instanciatedRadio;

if (_radio_id call TFAR_fnc_isLRRadio) then {
    _radio_id = [_radio_id, "radio_settings"];
    private _settings = _radio_id call TFAR_fnc_getLrSettings;

    _settings set [TFAR_SW_SPEAKER_OFFSET, _enabled];

    [_radio_id, _settings] call TFAR_fnc_setLrSettings;
} else {
    private _settings = _radio_id call TFAR_fnc_getSwSettings;

    _settings set [TFAR_SW_SPEAKER_OFFSET, _enabled];

    [_radio_id, _settings] call TFAR_fnc_setSwSettings;
}
