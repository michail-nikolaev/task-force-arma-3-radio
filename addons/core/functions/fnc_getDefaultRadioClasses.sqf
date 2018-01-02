#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getDefaultRadioClasses
 *
 * Author: NKey
 * Return array of default radio classes for player.
 *
 * Arguments:
 * None
 *
 * Return Value:
 * 0: default LR <STRING>
 * 1: defaultPersonal <STRING>
 * 2: defaultRifleman <STRING>
 * 3: defaultAirborne <STRING>
 *
 * Example:
 * _classes = call TFAR_fnc_getDefaultRadioClasses;
 *
 * Public: Yes
 */

private _defaultLRRadio = TFAR_DefaultRadio_Backpack_Independent;
private _defaultPersonalRadio = TFAR_DefaultRadio_Personal_Independent;
private _defaultRiflemanRadio = TFAR_DefaultRadio_Rifleman_Independent;
private _defaultAirborneRadio = TFAR_DefaultRadio_Airborne_Independent;

switch (TFAR_currentUnit call BIS_fnc_objectSide) do {
    case west: {
        _defaultLRRadio = TFAR_DefaultRadio_Backpack_West;
        _defaultPersonalRadio = TFAR_DefaultRadio_Personal_West;
        _defaultRiflemanRadio = TFAR_DefaultRadio_Rifleman_West;
        _defaultAirborneRadio = TFAR_DefaultRadio_Airborne_West;
    };
    case east: {
        _defaultLRRadio = TFAR_DefaultRadio_Backpack_East;
        _defaultPersonalRadio = TFAR_DefaultRadio_Personal_East;
        _defaultRiflemanRadio = TFAR_DefaultRadio_Rifleman_East;
        _defaultAirborneRadio = TFAR_DefaultRadio_Airborne_East;
    };
};

TFAR_tryResolveFactionClass =
{
    params ["_prefix", "_default"];
    private _faction = faction TFAR_currentUnit;
    private _result = missionNamespace getVariable (_faction + "_" + _prefix + "_tf_faction_radio");

    if (!isNil "_result") exitWith {_result};

    if (isText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"))) exitWith {
        getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"));
    };

    if (isText (configFile >> "CfgFactionClasses" >> _faction >> _prefix + "_tf_faction_radio")) exitWith {
        getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio"));
    };

    _default
};

[
    ["backpack", _defaultLRRadio] call TFAR_tryResolveFactionClass,
    ["personal", _defaultPersonalRadio] call TFAR_tryResolveFactionClass,
    ["rifleman", _defaultRiflemanRadio] call TFAR_tryResolveFactionClass,
    ["airborne", _defaultAirborneRadio] call TFAR_tryResolveFactionClass
]
