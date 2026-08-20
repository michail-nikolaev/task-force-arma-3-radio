#include "script_component.hpp"

/*
  Name: TFAR_fnc_updateSWDialogToChannel

  Author: NKey, Garth de Wet (L-H)
    Updates the SR dialog to the channel if switched.

  Arguments:
    0: Format to display channel with. Requires %1. <STRING> (default: "C%1")

  Return Value:
    None

  Example:
    // No custom format.
    call TFAR_fnc_updateSWDialogToChannel;
    // Custom format
    ["CH: %1"] call TFAR_fnc_updateSWDialogToChannel;

  Public: Yes
*/

private _formatText = "C%1";

if ((_this isEqualType []) and {count _this > 0} and  {(_this select 0) isEqualType ""}) then {
    _formatText = _this select 0;
};

private _channel = TF_sw_dialog_radio call TFAR_fnc_getSwChannel;

if ((TF_sw_dialog_radio call TFAR_fnc_getAdditionalSwChannel) == _channel) then {
    _formatText = "A%1";
};

private _frequency = TF_sw_dialog_radio call TFAR_fnc_getSwFrequency;
private _channelName = [TF_sw_dialog_radio, _channel + 1] call TFAR_fnc_getChannelName;
private _showChannelName = _channelName isNotEqualTo "" && {
    [TF_sw_dialog_radio, "tf_showChannelName", 0] call DFUNC(getWeaponConfigProperty) > 0
};

private _dialogIdd = [TF_sw_dialog_radio, "tf_channelNameDialogIdd", -1] call DFUNC(getWeaponConfigProperty);
private _offsetPixels = [TF_sw_dialog_radio, "tf_channelNameOffset", 0] call DFUNC(getWeaponConfigProperty);

if !(_dialogIdd isEqualType 0) then {_dialogIdd = -1;};
if !(_offsetPixels isEqualType 0) then {_offsetPixels = 0;};

[
    _frequency,
    _channelName,
    _showChannelName,
    _dialogIdd,
    _offsetPixels,
    SW_EDIT,
    SW_CHANNEL
] call TFAR_fnc_updateRadioDialogFrequency;

private _channelText = format [_formatText, _channel + 1];
ctrlSetText [SW_CHANNEL, _channelText];
