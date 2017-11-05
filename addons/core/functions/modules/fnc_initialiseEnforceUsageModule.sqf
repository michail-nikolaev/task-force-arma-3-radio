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
    tf_radio_channel_name = (_logic getVariable "radio_channel_name");
    tf_radio_channel_password = (_logic getVariable "radio_channel_password");
};

true
