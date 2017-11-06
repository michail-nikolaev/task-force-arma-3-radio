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
    if (_units isEqualTo []) exitWith {};
    
    if (isServer) then {
        private _srFreq = false call TFAR_fnc_generateSRSettings;
        private _freqs = [(_logic getVariable "PrFreq"),TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
        _srFreq set [2,_freqs];

        private _lrFreq = false call TFAR_fnc_generateLrSettings;
        _freqs = [(_logic getVariable "LrFreq"),TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
        _lrFreq set [2,_freqs];

        _logic setVariable ["TFAR_freq_sr", _srFreq, true];
        _logic setVariable ["TFAR_freq_lr", _lrFreq, true];
    };
    
    If (hasInterface) then {
        private _fnc = {
            params ["_logic"];
            private _groups = [];
            {
                _groups pushBackUnique (group _x);
                nil
            } count _units;

            private _srFreq = _logic getVariable "TFAR_freq_sr";
            private _lrFreq = _logic getVariable "TFAR_freq_lr";
            {
                If (isNil {_x getVariable "TFAR_freq_sr"}) then {
                    _x setVariable ["TFAR_freq_sr", _srFreq];
                };
                If (isNil {_x getVariable "TFAR_freq_lr"}) then {
                    _x setVariable ["TFAR_freq_lr", _lrFreq];
                };
            } count _groups;
        };
        If (isNil {_logic getVariable "TFAR_freq_lr"}) then {
            [
                {
                    !(isNil {_this getVariable "TFAR_freq_lr"})
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
