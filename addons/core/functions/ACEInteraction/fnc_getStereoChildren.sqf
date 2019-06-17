#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_getStereoChildren

  Author: Dorbedo
    Used to provide an array of ace actions to be used as children actions in the interact menu.

  Arguments:
    0: the unit <OBJECT>
    1: the radio <STRING|ARRAY>

  Return Value:
    children ACE actions <ARRAY>

  Example:
    _grandchildren = [_player,_player,[_radio,0]] call TFAR_core_fnc_getStereoChildren;

  Public: No
*/

params ["_unit", "_radio"];

//#TODO rename, its radio children now, not stereo
#define ARG (_this select 2)
#define ARG1 (ARG select 0)
#define ARG2 (ARG select 1)

([[//SR Functions
    //Stereo
    {ARG call TFAR_fnc_setSwStereo},
    {!((ARG1 call TFAR_fnc_getSwStereo) isEqualTo ARG2)},

    {ARG call TFAR_fnc_setSwSpeakers},
    {!((ARG1 call TFAR_fnc_getSwSpeakers) isEqualTo ARG2)}

], [ //LR Functions
    //Stereo
    {ARG call TFAR_fnc_setLrStereo},
    {!((ARG1 call TFAR_fnc_getLrStereo) isEqualTo ARG2)},

    {ARG call TFAR_fnc_setLrSpeakers},
    {!((ARG1 call TFAR_fnc_getLrSpeakers) isEqualTo ARG2)}

]] select (_radio isEqualType [])) params ["_switchFnc","_switchCheck", "_speakerSet", "_speakerCheck"];

private _grandchilds = [];

for "_i" from 0 to 2 do {
    _grandchilds pushBack [
        [
            format["TFAR_Stereo_Action_%1_%2", _radio, _i],
            localize format [LSTRING(stereo_settings_%1), _i],
            "",
            _switchFnc,
            _switchCheck,
            {},
            [_radio, _i]
        ] call ace_interact_menu_fnc_createAction,
        [],
        _unit
    ];
};

_grandchilds pushBack [
    [
        format["TFAR_Speaker_Action_%1_%2", _radio, true],
        localize format [LSTRING(speakers_settings_%1), true],
        "",
        _speakerSet,
        _speakerCheck,
        {},
        [_radio, true]
    ] call ace_interact_menu_fnc_createAction,
    [],
    _unit
];

_grandchilds pushBack [
    [
        format["TFAR_Speaker_Action_%1_%2", _radio, false],
        localize format [LSTRING(speakers_settings_%1), false],
        "",
        _speakerSet,
        _speakerCheck,
        {},
        [_radio, false]
    ] call ace_interact_menu_fnc_createAction,
    [],
    _unit
];

_grandchilds

