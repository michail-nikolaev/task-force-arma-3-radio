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
    if (_units isEqualTo []) exitWith {
        private _msg = "TFAR - No units set for Frequency Module";
        hint _msg;
        diag_log _msg;
    };
    
    if (isServer) then {
        private _swFreq = false call TFAR_fnc_generateSRSettings;
        private _freqs = [(_logic getVariable "PrFreq"),TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
        _swFreq set [2,_freqs];

        private _lrFreq = false call TFAR_fnc_generateLrSettings;
        _freqs = [(_logic getVariable "LrFreq"),TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
        _lrFreq set [2,_freqs];

        _logic setVariable ["tf_sw_frequency", _swFreq, true];
        _logic setVariable ["tf_lr_frequency", _lrFreq, true];
    };
    
    If (hasInterface) then {
        private _fnc = {
            params ["_logic"];
            private _groups = [];
            {
                _groups pushBackUnique (group _x);
                true;
            } count _units;

            private _swFreq = _logic getVariable "tf_sw_frequency";
            private _lrFreq = _logic getVariable "tf_lr_frequency";
            {
                If ((!(isNil "_swFreq")) && {!(isNil {_x getVariable "tf_sw_frequency"})}) then {
                    _x setVariable ["tf_sw_frequency", _swFreq];
                };
                If ((!(isNil "_lrFreq")) && {!(isNil {_x getVariable "tf_lr_frequency"})}) then {
                    _x setVariable ["tf_lr_frequency", _lrFreq];
                };
            } count _groups;
        };
        If (isNil {_logic getVariable "tf_lr_frequency"}) then {
            [
                {
                    !(isNil {(_this getVariable "tf_lr_frequency")})
                },
                _fnc,
                _logic,
                60
            ] call CBA_fnc_waitUntilAndExecute;
        } else {
            _logic call _fnc;
        };
    };
};

true
