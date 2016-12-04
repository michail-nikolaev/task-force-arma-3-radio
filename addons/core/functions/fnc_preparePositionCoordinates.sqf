#include "script_component.hpp"

/*
    Name: TFAR_fnc_preparePositionCoordinates

    Author(s):
        NKey

    Description:
        Prepares the position coordinates of the passed unit.

    Parameters:
        0: OBJECT - unit
        1: BOOLEAN - Is near player
        3: STRING - Unit name

    Returns:
        Nothing

    Example:

*/

params ["_unit", "_nearPlayer","_unitName"];

private _pos = [_unit, _nearPlayer] call (_unit getVariable ["TF_fnc_position", TFAR_fnc_defaultPositionCoordinates]);
private _isolated_and_inside = _unit call TFAR_fnc_vehicleIsIsolatedAndInside;
private _depth = _unit call TFAR_fnc_eyeDepth;
private _can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
private _useSw = true;
private _useLr = true;
private _useDd = false;
if (_depth < 0) then {
    _useSw = [_unit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio;
    _useLr = [_unit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio;
    _useDd = [_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio;
};
if (count _pos != 4) then {
    _pos pushBack 0;
};

private _vehicle = _unit call TFAR_fnc_vehicleId;
if ((_nearPlayer) and {TFAR_currentUnit distance _unit <= TF_speakerDistance}) then {
    if (_unit getVariable ["TFAR_LRSpeakersEnabled", false] && _useLr) then {
        {
            if (_x call TFAR_fnc_getLrSpeakers) then {
                private _frequencies = [format ["%1%2", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode]];
                if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
                    _frequencies pushBack format ["%1%2", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_getChannelFrequency, _x call TFAR_fnc_getLrRadioCode];
                };
                private _radio_id = netId (_x select 0);
                if (_radio_id == '') then {
                    _radio_id = str (_x select 0);
                };
                TFAR_speakerRadios pushBack ([_radio_id,_frequencies joinString "|",__unitName,[], _x call TFAR_fnc_getLrVolume, _vehicle, (getPosASL _unit) select 2] joinString TF_new_line);
            };
            true;
        } count (_unit call TFAR_fnc_lrRadiosList);
    };

    if (_unit getVariable ["tf_sw_speakers", false] && _useSw) then {
        {
            if (_x call TFAR_fnc_getSwSpeakers) then {
                private _frequencies = [format ["%1%2", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode]];
                if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
                    _frequencies pushBack format ["%1%2", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_getChannelFrequency, _x call TFAR_fnc_getSwRadioCode];
                };
                private _radio_id = _x;
                TFAR_speakerRadios pushBack ([_radio_id,_frequencies joinString "|",_unitName,[], _x call TFAR_fnc_getSwVolume, _vehicle, (getPosASL _unit) select 2] joinString TF_new_line);
            };
            true;
        } count (_unit call TFAR_fnc_radiosList);
    };
};

private _object_interception = 0;
if (TFAR_objectInterceptionEnabled && _nearPlayer) then {
    _object_interception = _unit call TFAR_fnc_objectInterception;
};

private _terrainInterception = 0;
if (!_nearPlayer) then {
    _terrainInterception = _unit call TFAR_fnc_calcTerrainInterception;
};


//#TODO skip terrainInterception for nearplayers
(format["POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11",//#TODO reorder
    _unitName,
    [_pos select 0, _pos select 1, _pos select 2], _unit call TFAR_fnc_currentDirection,//Position
    _can_speak, _useSw, _useLr, _useDd, _vehicle,
    _terrainInterception,
    _unit getVariable ["tf_voiceVolume", 1.0],//Externally used API variable. Don't change name
     _object_interception //Interceptions
    ])
