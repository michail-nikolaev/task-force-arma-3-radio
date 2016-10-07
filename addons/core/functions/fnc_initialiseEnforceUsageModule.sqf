#include "script_component.hpp"

/*
    Name: TFAR_fnc_initialiseEnforceUsageModule

    Author(s):
        L-H

    Description:
        Initialises variables based on module settings.

    Parameters:

    Returns:
        Nothing

    Example:

 */
params [
    ["_logic", objNull, [objNull]],
    ["_units", [], [[]]],
    ["_activated", true, [true]]
];

if (_activated) then {
    tf_no_auto_long_range_radio = !(_logic getVariable "TeamLeaderRadio");
    TF_give_personal_radio_to_regular_soldier = !(_logic getVariable "RiflemanRadio");

    TF_terrain_interception_coefficient = (_logic getVariable "terrain_interception_coefficient");
    tf_radio_channel_name = (_logic getVariable "radio_channel_name");
    tf_radio_channel_password = (_logic getVariable "radio_channel_password");

    if (isServer) then {
        tf_same_sw_frequencies_for_side = (_logic getVariable "same_sw_frequencies_for_side");
        tf_same_lr_frequencies_for_side = (_logic getVariable "same_lr_frequencies_for_side");
    };
};

true
