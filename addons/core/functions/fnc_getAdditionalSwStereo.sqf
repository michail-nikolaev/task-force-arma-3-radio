#include "script_component.hpp"

/*
    Name: TFAR_fnc_getAdditionalSwStereo

    Author(s):
        NKey

    Description:
        Gets the stereo setting of additional channel of the passed radio

    Parameters:
        STRING: Radio classname

    Returns:
        NUMBER: Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)

    Example:
        _stereo = (call TFAR_fnc_ActiveSwRadio) call TFAR_fnc_getAdditionalSwStereo;
*/

params[["_radio","",[""]]];

(_radio call TFAR_fnc_getSwSettings) param [TFAR_ADDITIONAL_STEREO_OFFSE]
