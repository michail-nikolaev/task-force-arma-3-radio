#include "script_component.hpp"

/*
    Name: TFAR_fnc_processGroupFrequencySettings

    Author(s):
        NKey

    Description:
        Sets frequency settings for groups.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_processGroupFrequencySettings;
*/

_allGroups = allGroups;
//allGroups doesn't include Curators so Add them.
{
    _allGroups pushBackUnique (group _x);
    true;
} count (call BIS_fnc_listCuratorPlayers);//Add curators

{

    if ((_x getVariable ["tf_sw_frequency",false]) isEqualTo false) then {
        if !(TFAR_SameSRFrequenciesForSide) then {
            _x setVariable ["tf_sw_frequency", call TFAR_fnc_generateSRSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_sw_frequency", TFAR_freq_sr_west, true];
                };
                case east: {
                    _x setVariable ["tf_sw_frequency", TFAR_freq_sr_east, true];
                };
                default {
                    _x setVariable ["tf_sw_frequency", TFAR_freq_sr_independent, true];
                };
            };
        };
    };

    if ((_x getVariable "tf_lr_frequency") isEqualTo false) then {
        if !(TFAR_SameLRFrequenciesForSide) then {
            _x setVariable ["tf_lr_frequency", call TFAR_fnc_generateLrSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_lr_frequency", TFAR_freq_lr_west, true];
                };
                case east: {
                    _x setVariable ["tf_lr_frequency", TFAR_freq_lr_east, true];
                };
                default {
                    _x setVariable ["tf_lr_frequency", TFAR_freq_lr_independent, true];
                };
            };
        };
    };
    true;
} count _allGroups;
