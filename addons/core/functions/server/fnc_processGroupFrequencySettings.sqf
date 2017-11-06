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
//#TODO add optional parameter to specify an array of groups to process. If not defined process all Groups

_allGroups = allGroups;
//allGroups doesn't include Curators so Add them.
{
    _allGroups pushBackUnique (group _x);
    true;
} count (call BIS_fnc_listCuratorPlayers);//Add curators

{

    if ((_x getVariable ["TFAR_freq_sr",false]) isEqualTo false) then {
        if !(TFAR_SameSRFrequenciesForSide) then {
            _x setVariable ["TFAR_freq_sr", [] call TFAR_fnc_generateSRSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["TFAR_freq_sr", TFAR_freq_sr_west, true];
                };
                case east: {
                    _x setVariable ["TFAR_freq_sr", TFAR_freq_sr_east, true];
                };
                default {
                    _x setVariable ["TFAR_freq_sr", TFAR_freq_sr_independent, true];
                };
            };
        };
    };

    if ((_x getVariable ["TFAR_freq_lr",false]) isEqualTo false) then {
        if !(TFAR_SameLRFrequenciesForSide) then {
            _x setVariable ["TFAR_freq_lr", [] call TFAR_fnc_generateLrSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["TFAR_freq_lr", TFAR_freq_lr_west, true];
                };
                case east: {
                    _x setVariable ["TFAR_freq_lr", TFAR_freq_lr_east, true];
                };
                default {
                    _x setVariable ["TFAR_freq_lr", TFAR_freq_lr_independent, true];
                };
            };
        };
    };
    true;
} count _allGroups;
