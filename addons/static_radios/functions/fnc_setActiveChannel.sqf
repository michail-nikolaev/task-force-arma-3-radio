#include "script_component.hpp"

/*
  Name: TFAR_static_radios_fnc_setActiveChannel

  Author: Dedmen
    sets the static radio's active channel

  Arguments:
    0: the weaponholder containing the radio <OBJECT>
    1: selected channel <SCALAR>

  Return Value:
    None

  Example:
    ["TFAR_anprc_152_3",3] call TFAR_static_radios_fnc_setActiveChannel;

  Public: Yes
*/
params ["_radioContainer","_channel"];

_radio_id = _radioContainer call TFAR_static_radios_fnc_instanciatedRadio;

if (_radio_id call TFAR_fnc_isLRRadio) then {
    _radio_id = [_radio_id, "radio_settings"];
    private _settings = _radio_id call TFAR_fnc_getLrSettings;

    _settings set [ACTIVE_CHANNEL_OFFSET, _channel -1];

    [_radio_id, _settings] call TFAR_fnc_setLrSettings;
} else {
    private _settings = _radio_id call TFAR_fnc_getSwSettings;

    _settings set [ACTIVE_CHANNEL_OFFSET, _channel -1];

    [_radio_id, _settings] call TFAR_fnc_setSwSettings;
}
