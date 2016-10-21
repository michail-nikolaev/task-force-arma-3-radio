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

{
    if (isNil (_x getVariable "tf_sw_frequency")) then {
        if !(tf_same_sw_frequencies_for_side) then {
            _x setVariable ["tf_sw_frequency", call TFAR_fnc_generateSRSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_sw_frequency", tf_freq_west, true];
                };
                case east: {
                    _x setVariable ["tf_sw_frequency", tf_freq_east, true];
                };
                default {
                    _x setVariable ["tf_sw_frequency", tf_freq_guer, true];
                };
            };
        };
    };
    if (isNil (_x getVariable "tf_dd_frequency")) then {
        if !(tf_same_dd_frequencies_for_side) then {
            _x setVariable ["tf_dd_frequency", call TFAR_fnc_generateDDFreq, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_dd_frequency", tf_freq_west_dd, true];
                };
                case east: {
                    _x setVariable ["tf_dd_frequency", tf_freq_east_dd, true];
                };
                default {
                    _x setVariable ["tf_dd_frequency", tf_freq_guer_dd, true];
                };
            };
        };
    };
    if (isNil (_x getVariable "tf_lr_frequency")) then {
        if !(tf_same_lr_frequencies_for_side) then {
            _x setVariable ["tf_lr_frequency", call TFAR_fnc_generateLrSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_lr_frequency", tf_freq_west_lr, true];
                };
                case east: {
                    _x setVariable ["tf_lr_frequency", tf_freq_east_lr, true];
                };
                default {
                    _x setVariable ["tf_lr_frequency", tf_freq_guer_lr, true];
                };
            };
        };
    };
    true;
} count allGroups;
