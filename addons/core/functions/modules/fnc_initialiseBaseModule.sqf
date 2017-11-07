#include "script_component.hpp"

/*
    Name: TFAR_fnc_initialiseBaseModule

    Author(s):
        L-H, Dorbedo

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

    [
        "CBA_beforeSettingsInitialized",
        {
            ["CBA_settings_setSettingMission", ["TFAR_SameSRFrequenciesForSide", true, 1]] call CBA_fnc_localEvent;
            ["CBA_settings_setSettingMission", ["TFAR_SameLRFrequenciesForSide", true, 1]] call CBA_fnc_localEvent;
            ["CBA_beforeSettingsInitialized", _thisId] call CBA_fnc_removeEventHandler;
        }
    ] call CBA_fnc_addEventHandlerArgs;

    private _srFreqs = _logic getVariable ["PrFreq", ""];
    private _lrFreqs = _logic getVariable ["LrFreq", ""];

    private _LRradio = _logic getVariable ["LRradio", ""];
    private _radio = _logic getVariable ["Radio", ""];
    private _RiflemanRadio = _logic getVariable ["RiflemanRadio", ""];

    private _radio_code = _logic getVariable ["Encryption", ""];

    if !(_LRradio call TFAR_fnc_isLRRadio) then {
        ERROR_1("Base Module: LR radio is not a radio (%1)", _LRradio);
        _LRradio = "";
    };
    if !(_radio call TFAR_fnc_isPrototypeRadio) then {
        ERROR_1("Base Module: SR radio is not a radio (%1)", _radio);
        _radio = "";
    };
    if !(_RiflemanRadio call TFAR_fnc_isPrototypeRadio) then {
        ERROR_1("Base Module: rifleman radio is not a radio (%1)", _RiflemanRadio);
        _RiflemanRadio = "";
    };

    private _sides = _units apply {side _x};
    _sides = (_sides arrayIntersect _sides) apply {
        switch _x do {
            case west : {"west"};
            case east : {"east"};
            case independent;
            case civilian : {"independent"};
            default {""};
        };
    };
    _sides = (_sides arrayIntersect _sides) select {!(_x isEqualTo "")};

    {
        private _currentSide = _x;
        [
            "CBA_beforeSettingsInitialized",
            {
                _thisArgs params ["_currentSide", "_srFreqs", "_lrFreqs", "_RiflemanRadio", "_radio_code", "_LRradio", "_radio"];
                if !(_srFreqs isEqualTo "") then {
                    ["CBA_settings_setSettingMission", [format ["TFAR_setting_defaultFrequencies_sr_%1", _currentSide], _srFreqs, 1]] call CBA_fnc_localEvent;
                };
                if !(_lrFreqs isEqualTo "") then {
                    ["CBA_settings_setSettingMission", [format ["TFAR_setting_defaultFrequencies_lr_%1", _currentSide], _lrFreqs, 1]] call CBA_fnc_localEvent;
                };

                ["CBA_settings_setSettingMission", [format ["TF_%1_radio_code", _currentSide], _radio_code, 1]] call CBA_fnc_localEvent;

                if !(_LRradio isEqualTo "") then {
                    ["CBA_settings_setSettingMission", [format ["TFAR_setting_DefaultRadio_Backpack_%1", _currentSide], _LRradio, 1]] call CBA_fnc_localEvent;
                };
                if !(_radio isEqualTo "") then {
                    ["CBA_settings_setSettingMission", [format ["TFAR_setting_DefaultRadio_Personal_%1", _currentSide], _radio, 1]] call CBA_fnc_localEvent;
                };
                if !(_RiflemanRadio isEqualTo "") then {
                    ["CBA_settings_setSettingMission", [format ["TFAR_setting_DefaultRadio_Rifleman_%1", _currentSide], _RiflemanRadio, 1]] call CBA_fnc_localEvent;
                };

                ["CBA_beforeSettingsInitialized", _thisId] call CBA_fnc_removeEventHandler;
            },
            [_currentSide, _srFreqs, _lrFreqs, _RiflemanRadio, _radio_code, _LRradio, _radio]
        ] call CBA_fnc_addEventHandlerArgs;
        nil
    } count _sides;

};

true
