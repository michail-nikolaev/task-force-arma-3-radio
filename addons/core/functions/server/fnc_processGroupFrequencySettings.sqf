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
        if !(TFAR_SameSRFrequenciesForSide) then {
            _x setVariable ["tf_sw_frequency", call TFAR_fnc_generateSRSettings, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_sw_frequency", TFAR_freq_sr_west, true];//#TODO rename tf_xx_frequency
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
    if (isNil (_x getVariable "tf_dd_frequency")) then {
        if !(TFAR_SameDDFrequenciesForSide) then {
            _x setVariable ["tf_dd_frequency", call TFAR_fnc_generateDDFreq, true];
        } else {
            switch (side _x) do {
                case west: {
                    _x setVariable ["tf_dd_frequency", TFAR_freq_sr_west_dd, true];
                };
                case east: {
                    _x setVariable ["tf_dd_frequency", TFAR_freq_sr_east_dd, true];
                };
                default {
                    _x setVariable ["tf_dd_frequency", TFAR_freq_sr_independent_dd, true];
                };
            };
        };
    };
    if (isNil (_x getVariable "tf_lr_frequency")) then {
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
} count allGroups;
