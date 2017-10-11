#include "script_component.hpp"

/*
    Name: TFAR_fnc_initialiseFreqModule

    Author(s):
        L-H

    Description:
        Initialises variables based on module settings.

    Parameters:

    Returns:
        Nothing

    Example:

*/

params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

if (_activated) then {
    if (count _units == 0) exitWith { hint localize "STR_TFAR_WM_FreqModule_noUnits";diag_log localize "STR_TFAR_WM_FreqModule_noUnits";};
    if (!isServer) exitWith {};
    private _swFreq = false call TFAR_fnc_generateSRSettings;
    private _freqs = call compile (_logic getVariable "PrFreq");
    private _randomFreqs = [TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
    while {count _freqs < TFAR_MAX_CHANNELS} do {
        _freqs pushBack (_randomFreqs select (count _freqs));
    };
    _swFreq set [2,_freqs];

    private _lrFreq = false call TFAR_fnc_generateLrSettings;
    _freqs = call compile (_logic getVariable "LrFreq");
    _randomFreqs = [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
    while {count _freqs < TFAR_MAX_LR_CHANNELS} do {
        _freqs pushBack (_randomFreqs select (count _freqs));
    };
    _lrFreq set [2,_freqs];

    //Make unique list of groups. In case player assigned module to multiple units of same group
    private _groups = [];
    {
        _groups pushBackUnique (group _x);
        true;
    } count _units;

    if (didJIP) then {
        if (isNil (_x getVariable "tf_sw_frequency")) then {_x setVariable ["tf_sw_frequency", _swFreq, true];};
        if (isNil (_x getVariable "tf_lr_frequency")) then {_x setVariable ["tf_lr_frequency", _lrFreq, true];};
    } else {
        {
            if (!isNil (_x getVariable "tf_sw_frequency")) then {private _message = format[localize "STR_TFAR_WM_FreqModule_FQMSW_AlreadySet", (group _x)];diag_log _message;hint _message;};

            if (!isNil (_x getVariable "tf_lr_frequency")) then {private _message = format[localize "STR_TFAR_WM_FreqModule_FQMLR_AlreadySet", (group _x)];diag_log _message;hint _message;};

            _x setVariable ["tf_sw_frequency", _swFreq, true];
            _x setVariable ["tf_lr_frequency", _lrFreq, true];

            true;
        } count _groups;
    };
};

true
