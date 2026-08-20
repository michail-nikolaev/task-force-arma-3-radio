#include "script_component.hpp"

/*
  Name: TFAR_fnc_updateLRDialogToChannel

  Author: NKey, Garth de Wet (L-H)
    Updates the LR dialog to the channel if switched.

  Arguments:
    0: Format to display channel with. Requires %1. <STRING> (default: "CH:%1")

  Return Value:
    None

  Example:
    // No custom format.
    call TFAR_fnc_updateLRDialogToChannel;
    // Custom format
    ["CH: %1"] call TFAR_fnc_updateLRDialogToChannel;

  Public: Yes
*/

private _formatText = "CH:%1";

if ((_this isEqualType []) and {count _this > 0} and  {(_this select 0) isEqualType ""}) then {
    _formatText = _this select 0;
};

private _channel = TF_lr_dialog_radio call TFAR_fnc_getLrChannel;

if ((TF_lr_dialog_radio call TFAR_fnc_getAdditionalLrChannel) == _channel) then {
    _formatText = "CA:%1";
};

private _frequency = TF_lr_dialog_radio call TFAR_fnc_getLrFrequency;
private _channelName = [TF_lr_dialog_radio, _channel + 1] call TFAR_fnc_getChannelName;
private _radioObject = TF_lr_dialog_radio select 0;
private _showChannelName = _channelName isNotEqualTo "" && {
    [_radioObject, "tf_showChannelName", 0] call TFAR_fnc_getLrRadioProperty > 0
};

private _dialogIdd = [_radioObject, "tf_channelNameDialogIdd", -1] call TFAR_fnc_getLrRadioProperty;
private _offsetPixels = [_radioObject, "tf_channelNameOffset", 0] call TFAR_fnc_getLrRadioProperty;

if !(_dialogIdd isEqualType 0) then {_dialogIdd = -1;};
if !(_offsetPixels isEqualType 0) then {_offsetPixels = 0;};

[
    _frequency,
    _channelName,
    _showChannelName,
    _dialogIdd,
    _offsetPixels,
    LR_EDIT,
    LR_CHANNEL
] call TFAR_fnc_updateRadioDialogFrequency;

private _channelText = format [_formatText, _channel + 1];
ctrlSetText [LR_CHANNEL, _channelText];
