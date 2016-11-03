#include "script_component.hpp"

/*
    Name: TFAR_fnc_getCurrentSwStereo

    Author(s):
        NKey

    Description:
        Gets the stereo setting of current channel (special logic for additional) the passed radio

    Parameters:
        STRING: Radio classname

    Returns:
        NUMBER: Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)

    Example:
        _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getCurrentSwStereo;
*/
params[["_radio","",[""]]];

if ((_this call TFAR_fnc_getAdditionalSwChannel) == (_this call TFAR_fnc_getSwChannel)) exitWith {
    _radio call TFAR_fnc_getAdditionalSwStereo;
};

_radio call TFAR_fnc_getSwStereo;
