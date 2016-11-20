#include "script_component.hpp"

/*
    Name: TFAR_fnc_vehicleID

    Author(s):
        NKey

    Description:
        Returns a string with information about the player vehicle, used at the plugin side.

    Parameters:
        0: OBJECT - The unit to check.

    Returns:
        STRING - NetworkID, Turned out

    Example:
        _vehicleID = player call TFAR_fnc_vehicleID;
*/
params ["_unit"];

if (isNull (objectParent _unit)) exitWith {"no"};//Unit is not in vehicle

_netID = netid (vehicle _unit);
if (_netID == "") then {
    _netID = "singleplayer";
};
if ([_unit] call TFAR_fnc_isTurnedOut) exitWith {_netID + "_turnout";};

_netID + "_" + str ([(typeof (vehicle _unit)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty);
