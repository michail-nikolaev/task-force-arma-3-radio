#include "script_component.hpp"

/*
    Name: TFAR_fnc_updateDDDialog

    Author(s):
        NKey

    Description:
        Updates the DD dialog to the channel and depth if switched.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_updateDDDialog;
*/

ctrlSetText [IDC_DIVER_RADIO_EDIT, TF_dd_frequency];
private _depth = round (((eyepos TFAR_currentUnit) select 2) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER;
private _depthText =  format["%1m", _depth];
ctrlSetText [IDC_DIVER_RADIO_DEPTH_EDIT, _depthText];
