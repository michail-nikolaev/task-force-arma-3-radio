#include "script_component.hpp"

/*
    Name: TFAR_fnc_getVehicleSide

    Author(s):
        NKey

    Description:
        Returns the side of the vehicle, based on the vehicle model and not who has captured it.
        Also takes into account a variable on the vehicle (tf_side)

    Parameters:
        OBJECT: vehicle

    Returns:
        SIDE: side of vehicle

    Example:
        _vehicleSide = (vehicle player) call TFAR_fnc_getVehicleSide;
*/
private _side = _this getVariable "tf_side";
private _result = resistance;

if !(isNil "_side") then {
    switch(_side) do {
        case "west": {
            _result = west;
        };
        case "east": {
            _result = east;
        };
    };
} else {
    _result = [getNumber(configFile >> "CfgVehicles" >> typeOf(_this) >> "side")] call BIS_fnc_sideType;
};
_result
