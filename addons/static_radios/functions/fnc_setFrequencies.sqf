#include "script_component.hpp"

/*
    Name: TFAR_static_radios_fnc_setFrequencies

    Author(s):
        Dedmen

    Description:
        Takes Radio classnames and returns instanciated classnames (With _ID appended)
        Internal use only!

    Parameters:
        0: OBJECT - The weaponholder containing the Radio
        1: ARRAY:   - 9 Channels of frequencies
                STRING  - Channels frequency

    Returns:
        NOTHING

    Example:
        ["TFAR_anprc_152_3",["72.4","60","66.4",...]] call TFAR_static_radios_fnc_setFrequencies;
*/
params ["_radioContainer","_frequencies"];

_radio_id = _radioContainer call TFAR_static_radios_fnc_instanciatedRadio;
diag_log ["TFAR_static_radios_fnc_setFrequencies",_this];
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
