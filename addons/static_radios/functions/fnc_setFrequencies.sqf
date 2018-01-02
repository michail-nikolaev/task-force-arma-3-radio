#include "script_component.hpp"

/*
 * Name: TFAR_static_radios_fnc_setFrequencies
 *
 * Author: Dedmen
 * takes radio classnames and returns instanciated classnames (with _ID appended)
 *
 * Arguments:
 * 0: the weaponholder containing the radio <OBJECT>
 * 1: 9 channels of frequencies <ARRAY>
 *
 * Return Value:
 * None
 *
 * Example:
 * ["TFAR_anprc_152_3",["72.4","60","66.4",...]] call TFAR_static_radios_fnc_setFrequencies;
 *
 * Public: No
 */
params ["_radioContainer","_frequencies"];

_radio_id = _radioContainer call TFAR_static_radios_fnc_instanciatedRadio;

if (_radio_id call TFAR_fnc_isLRRadio) then {
    _radio_id = [_radio_id, "radio_settings"];
    private _settings = _radio_id call TFAR_fnc_getLrSettings;

    //#TODO if _frequencies has less than 9 elements random-generate the rest
    _settings set [TFAR_FREQ_OFFSET, _frequencies];

    [_radio_id, _settings] call TFAR_fnc_setLrSettings;
} else {
    _settings = _radio_id call TFAR_fnc_getSwSettings;

    //#TODO if _frequencies has less than 9 elements random-generate the rest
    _settings set [TFAR_FREQ_OFFSET, _frequencies];

    [_radio_id, _settings] call TFAR_fnc_setSwSettings;
}
