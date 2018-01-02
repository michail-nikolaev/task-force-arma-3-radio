#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setLrFrequency
 *
 * Author: NKey
 * description
 *
 * Arguments:
 * 0: LR Radio <ARRAY>
 * 1: Frequency <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [call TFAR_fnc_activeLrRadio, "45.48"] call TFAR_fnc_setLrFrequency;
 *
 * Public: Yes
 */

params [["_radio", [], [[]], 2], ["_frequency", "", [""]]];

[_radio, ((_radio call TFAR_fnc_getLrSettings) select ACTIVE_CHANNEL_OFFSET)+1, _frequency] call TFAR_fnc_setChannelFrequency;
