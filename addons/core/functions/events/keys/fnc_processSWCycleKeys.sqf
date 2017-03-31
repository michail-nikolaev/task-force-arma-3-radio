#include "script_component.hpp"

/*
    Name: TFAR_fnc_processSWCycleKeys

    Author(s):


    Description:
        Allows rotating through the list of SW radios with keys.

    Parameters:
        0: STRING - Direction to cycle : VALUES (next, prev)

    Returns:
        BOOLEAN - If the event was handled or not.

    Example:
        Handled via CBA's onKey eventhandler.
*/

params ["_sw_cycle_direction"];

private _result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive TFAR_currentUnit}) then{
    private _radio = call TFAR_fnc_activeSwRadio;
    private _radio_list = TFAR_currentUnit call TFAR_fnc_radiosListSorted;

    private _active_radio_index = 0;
    private _new_radio_index = 0;

    {
        if (_x == _radio) exitWith {
            _active_radio_index = _forEachIndex;
        };
    } forEach _radio_list;

    switch (_sw_cycle_direction) do {
        case "next": {
            _new_radio_index = (_active_radio_index + 1) mod (count _radio_list);
        };
        case "prev": {
            if (_active_radio_index != 0) then {
                _new_radio_index = (_active_radio_index - 1);
            } else {
                _new_radio_index = (count _radio_list) - 1;
            };
        };
    };

    (_radio_list select _new_radio_index) call TFAR_fnc_setActiveSwRadio;
    playSound "TFAR_rotatorPush";
    [(call TFAR_fnc_activeSwRadio), false] call TFAR_fnc_showRadioInfo;

    _result = true;
};
_result
