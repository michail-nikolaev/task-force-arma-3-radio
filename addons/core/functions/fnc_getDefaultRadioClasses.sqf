#include "script_component.hpp"

/*
    Name: TFAR_fnc_getDefaultRadioClasses

    Author(s):
        NKey

    Description:
        Return array of default radio classes for player.

    Parameters:
        Nothing

    Returns:
        ARRAY - [defaultLR, defaultPersonal, defaultRifleman, defaultAirborne]

    Example:
        _classes = call TFAR_fnc_getDefaultRadioClasses;
*/

private _personalRadio = TFAR_DefaultRadio_Personal_Independent;
private _riflemanRadio = TFAR_DefaultRadio_Rifleman_Independent;
private _lrRadio = TFAR_DefaultRadio_Backpack_Independent;
private _airborne = TFAR_DefaultRadio_Airborne_Independent;

switch (TFAR_currentUnit call BIS_fnc_objectSide) do {
    case west: {_personalRadio = TFAR_DefaultRadio_Personal_West; _riflemanRadio = TFAR_DefaultRadio_Rifleman_West; _lrRadio = TFAR_DefaultRadio_Backpack_West; _airborne = TFAR_DefaultRadio_Airborne_West;};
    case east: {_personalRadio = TFAR_DefaultRadio_Personal_East; _riflemanRadio = TFAR_DefaultRadio_Rifleman_East;_lrRadio = TFAR_DefaultRadio_Backpack_East; _airborne = TFAR_DefaultRadio_Airborne_East;};
};

TFAR_tryResolveFactionClass =
{
    params ["_prefix", "_default"];
    private _faction = faction TFAR_currentUnit;
    private _result = missionNamespace getVariable (_faction + "_" + _prefix + "_tf_faction_radio");

    if (isNil "_result") then {
        if (isText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"))) then {
        _result = getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio_api"));
        } else {
            if (isText (configFile >> "CfgFactionClasses" >> _faction >> _prefix + "_tf_faction_radio")) then {
                _result = getText (configFile >> "CfgFactionClasses" >> _faction >> (_prefix + "_tf_faction_radio"));
            } else {
                _result = _default;
            };
        };
    };
    _result
};

[["backpack", _lrRadio] call TFAR_tryResolveFactionClass , ["personal", _personalRadio] call TFAR_tryResolveFactionClass , ["rifleman", _riflemanRadio] call TFAR_tryResolveFactionClass, ["airborne", _airborne] call TFAR_tryResolveFactionClass];
