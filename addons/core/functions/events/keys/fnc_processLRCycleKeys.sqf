#include "script_component.hpp"

/*
  Name: TFAR_fnc_processLRCycleKeys

  Author: JonBons, Nkey, Garth de Wet (L-H)
    Allows rotating through the list of LR radios with keys.

  Arguments:
    0: Direction to cycle : VALUES (next, prev) <STRING>

  Return Value:
    Whether or not the event was handled <BOOL>

  Example:
    call TFAR_fnc_processLRCycleKeys;

  Public: No
*/

params ["_lr_cycle_direction"];

private _result = false;

if ((call TFAR_fnc_haveLRRadio) and {alive TFAR_currentUnit}) then {
    private _radio = call TFAR_fnc_activeLrRadio;
    private _radio_list = TFAR_currentUnit call TFAR_fnc_lrRadiosList;

    private _active_radio_index = 0;
    private _new_radio_index = 0;

    {
        if (((_x select 0) == (_radio select 0)) or {(_x select 1) == (_radio select 1)}) exitWith {
            _active_radio_index = _forEachIndex;
        };
    } forEach _radio_list;


    switch (_lr_cycle_direction) do{
        case "next":
            {
                _new_radio_index = (_active_radio_index + 1) mod (count _radio_list);
            };
        case "prev":
        {
            if (_active_radio_index != 0) then {
                _new_radio_index = (_active_radio_index - 1);
            } else {
                _new_radio_index = (count _radio_list) - 1;
            };
        };
    };

    (_radio_list select _new_radio_index) call TFAR_fnc_setActiveLrRadio;
    playSound "TFAR_rotatorPush";
    [(call TFAR_fnc_activeLrRadio), true] call TFAR_fnc_showRadioInfo;

    _result = true;
};
_result
