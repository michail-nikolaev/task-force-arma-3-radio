#include "script_component.hpp"

/*
    Name: TFAR_static_radios_fnc_setSpeakers

    Author(s):
        Dedmen

    Description:
        Takes Radio classnames and returns instanciated classnames (With _ID appended)
        Internal use only!

    Parameters:
        0: OBJECT - The weaponholder containing the Radio
        1: BOOL - Speaker enabled

    Returns:
        NOTHING

    Example:
        ["TFAR_anprc_152_3",true] call TFAR_static_radios_fnc_setSpeakers;
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
