#include "script_component.hpp"

/*
    Name: TFAR_fnc_getLrStereo

    Author(s):
        NKey

    Description:
        Gets the stereo setting of the passed radio

    Parameters:
        Array: Radio
            0: OBJECT - Radio object
            1: STRING - Radio ID

    Returns:
        NUMBER: Stereo setting : Range (0,2) (0 - Both, 1 - Left, 2 - Right)

    Example:
        _stereo = (call TFAR_fnc_ActiveLrRadio) call TFAR_fnc_getLrStereo;
*/

private _settings = _this call TFAR_fnc_getLrSettings;
private _result = 0;
if (count _settings > TFAR_LR_STEREO_OFFSET) then {
    _result = _settings select TFAR_LR_STEREO_OFFSET;
};
_result
