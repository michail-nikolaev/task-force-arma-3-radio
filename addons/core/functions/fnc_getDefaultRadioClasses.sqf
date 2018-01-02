#include "script_component.hpp"

/*
    Name: TFAR_fnc_getDefaultRadioClasses

    Author(s):
        NKey, Dorbedo

    Description:
        Return array of default radio classes for player.

    Parameters:
        Nothing

    Returns:
        ARRAY - [defaultLR, defaultPersonal, defaultRifleman, defaultAirborne]

    Example:
        _classes = call TFAR_fnc_getDefaultRadioClasses;
*/

params ["_unit", TFAR_currentUnit];

private _fnc_tryResolveFactionClass = {
    params ["_prefix", "_default"];
    private _faction = faction _unit;
    private _result = missionNamespace getVariable (format["%1_%2_tf_faction_radio", _faction, _prefix]);

    if (_result isEqualTo "") exitWith {_default};
    if (!isNil "_result") exitWith {_result};

    if (isText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"))) exitWith {
        missionNamespace setVariable [(format["%1_%2_tf_faction_radio", _faction, _prefix]), getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"))];
        getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api")); //#Deprecated
    };

    if (isText (configFile >> "CfgFactionClasses" >> _faction >> _prefix + "_tf_faction_radio")) exitWith {
        missionNamespace setVariable [(format["%1_%2_tf_faction_radio", _faction, _prefix]), getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio"))];
        getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio"));
    };

    missionNamespace setVariable [(format["%1_%2_tf_faction_radio", _faction, _prefix]), ""];
    _default
};

switch (_unit call BIS_fnc_objectSide) do {
    case west: {
        [
            ["backpack", TFAR_DefaultRadio_Backpack_West] call _fnc_tryResolveFactionClass,
            ["personal", TFAR_DefaultRadio_Personal_West] call _fnc_tryResolveFactionClass,
            ["rifleman", TFAR_DefaultRadio_Rifleman_West] call _fnc_tryResolveFactionClass,
            ["airborne", TFAR_DefaultRadio_Airborne_West] call _fnc_tryResolveFactionClass
        ]
    };
    case east: {
        [
            ["backpack", TFAR_DefaultRadio_Backpack_East] call _fnc_tryResolveFactionClass,
            ["personal", TFAR_DefaultRadio_Personal_East] call _fnc_tryResolveFactionClass,
            ["rifleman", TFAR_DefaultRadio_Rifleman_East] call _fnc_tryResolveFactionClass,
            ["airborne", TFAR_DefaultRadio_Airborne_East] call _fnc_tryResolveFactionClass
        ]
    };
    default {
        [
            ["backpack", TFAR_DefaultRadio_Backpack_Independent] call _fnc_tryResolveFactionClass,
            ["personal", TFAR_DefaultRadio_Personal_Independent] call _fnc_tryResolveFactionClass,
            ["rifleman", TFAR_DefaultRadio_Rifleman_Independent] call _fnc_tryResolveFactionClass,
            ["airborne", TFAR_DefaultRadio_Airborne_Independent] call _fnc_tryResolveFactionClass
        ]
    };
};
