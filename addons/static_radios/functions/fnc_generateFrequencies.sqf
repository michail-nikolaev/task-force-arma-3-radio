#include "script_component.hpp"

/*
  Name: TFAR_static_radios_fnc_generateFrequencies

  Author: Dedmen
    Generates default frequencies for a static Radio

  Arguments:
    0: The weaponholder containing the Radio <OBJECT>

  Return Value:
    frequencies <ARRAY>

  Example:
    _this call TFAR_static_radios_fnc_generateFrequencies;

  Public: No
 */
params ["_radioClass"];

if (_radioClass call TFAR_fnc_isLRRadio) exitWith {
    [TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
};

[TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER] call TFAR_fnc_generateFrequencies;
