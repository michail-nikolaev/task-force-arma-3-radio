#include "script_component.hpp"

/*
    Name: TFAR_fnc_updateSWDialogToChannel

    Author(s):
        NKey
        L-H

    Description:
        Updates the SW dialog to the channel if switched.

    Parameters:
        0: STRING - Format to display channel with. Requires %1. (Optional)

    Returns:
        Nothing

    Example:
        // No custom format.
        call TFAR_fnc_updateSWDialogToChannel;
        // Custom format
        ["CH: %1"] call TFAR_fnc_updateSWDialogToChannel;
*/
private _formatText = "C%1";

if ((_this isEqualType []) and {count _this > 0} and  {(_this select 0) isEqualType ""}) then {
    _formatText = _this select 0;
};

if ((TF_sw_dialog_radio call TFAR_fnc_getAdditionalSwChannel) == (TF_sw_dialog_radio call TFAR_fnc_getSwChannel)) then {
    _formatText = "A%1";
};

ctrlSetText [SW_EDIT, TF_sw_dialog_radio call TFAR_fnc_getSwFrequency];
private _channelText =  format[_formatText, (TF_sw_dialog_radio call TFAR_fnc_getSwChannel) + 1];
ctrlSetText [SW_CHANNEL, _channelText];
