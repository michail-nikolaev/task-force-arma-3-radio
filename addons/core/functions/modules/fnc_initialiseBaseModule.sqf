#include "script_component.hpp"

/*
    Name: TFAR_fnc_initialiseBaseModule

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
    If !(isServer) exitWith {};

    private _swFreqs = [(_logic getVariable "PrFreq"),TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);

    private _lrFreqs = [(_logic getVariable "LrFreq"),TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);

    private _LRradio = _logic getVariable "LRradio";
    private _radio = _logic getVariable "Radio";
    private _currentSide = "North";

    TFAR_SameSRFrequenciesForSide = true;//#TODO this doesn't work with CBA settings
    TFAR_SameLRFrequenciesForSide = true;

    private _RiflemanRadio = _logic getVariable "RiflemanRadio";
    private _radio_code = _logic getVariable "Encryption";
    if (([_LRradio, "tf_hasLrRadio",0] call TFAR_fnc_getConfigProperty) != 1) then {
        diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
        hint format ["TFAR ERROR: %1 is not a valid LR radio", _LRradio];
        _LRradio = "-1";
    };
    if (getNumber (configFile >> "CfgWeapons" >> _radio >> "tf_prototype") != 1) then {
        diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
        hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
        _radio = "-1";
    };

    private _sides = _units apply {side _x};
    _sides = (_sides arrayIntersect _sides) select {_x in [west,east,independent,civilian]};
    {
        private _currentSide = side _x;
        if (_currentSide == independent || {_currentSide == civilian}) then {
            _currentSide = "independent";
        };

        missionNamespace setVariable [format ["TFAR_DefaultRadio_Rifleman_%1", _currentSide], _RiflemanRadio, true];
        missionNamespace setVariable [format ["TF_%1_radio_code", _currentSide], _radio_code, true];
        if (_LRradio != "-1") then {
            missionNamespace setVariable [format ["TFAR_DefaultRadio_Backpack_%1", _currentSide], _LRradio, true];
        };
        if (_radio != "-1") then {
            missionNamespace setVariable [format ["TFAR_DefaultRadio_Personal_%1", _currentSide], _radio, true];
        };

        ["CBA_beforeSettingsInitialized", {
            _thisArgs params ["_currentSide","_swFreq","_lrFreq"];
            ["CBA_settings_setSettingMission", [format ["TFAR_setting_defaultFrequencies_sr_%1", _currentSide],_swFreq,1]] call CBA_fnc_localEvent;
            ["CBA_settings_setSettingMission", [format ["TFAR_setting_defaultFrequencies_lr_%1", _currentSide],_lrFreq,1]] call CBA_fnc_localEvent;
            ["CBA_beforeSettingsInitialized",_thisId] call CBA_fnc_removeEventHandler;
        },[
            _currentSide,
            _swFreq apply {parseNumber _x},
            _lrFreq apply {parseNumber _x}
        ]] call CBA_fnc_addEventHandlerArgs;
        nil
    } count _sides;

    [
        "CBA_beforeSettingsInitialized",
        {
            ["CBA_settings_setSettingMission", ["TFAR_SameSRFrequenciesForSide",true,1]] call CBA_fnc_localEvent;
            ["CBA_settings_setSettingMission", ["TFAR_SameLRFrequenciesForSide",true,1]] call CBA_fnc_localEvent;
            ["CBA_beforeSettingsInitialized",_thisId] call CBA_fnc_removeEventHandler;
        }
    ] call CBA_fnc_addEventHandlerArgs;
};

true
