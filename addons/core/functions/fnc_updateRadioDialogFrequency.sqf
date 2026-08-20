#include "script_component.hpp"

/*
  Name: TFAR_fnc_updateRadioDialogFrequency

  Author: Darojax
    Updates a radio dialog's frequency field with either the frequency or its
    assigned name, preserving the radio's original layout when unnamed.

  Arguments:
    0: Frequency <STRING>
    1: Channel name <STRING>
    2: Show channel name <BOOL>
    3: Dialog IDD <NUMBER>
    4: Name expansion to the left, in pixels <NUMBER>
    5: Frequency edit control IDC <NUMBER>
    6: Channel control IDC <NUMBER>

  Return Value:
    None

  Public: No
*/

params [
    ["_frequency", "", [""]],
    ["_channelName", "", [""]],
    ["_showChannelName", false, [false]],
    ["_dialogIdd", -1, [0]],
    ["_offsetPixels", 0, [0]],
    ["_frequencyControlIdc", -1, [0]],
    ["_channelControlIdc", -1, [0]]
];

ctrlSetText [_frequencyControlIdc, [_frequency, _channelName] select _showChannelName];

if (_dialogIdd < 0) exitWith {};

disableSerialization;
private _frequencyControl = (findDisplay _dialogIdd) displayCtrl _frequencyControlIdc;
if (isNull _frequencyControl) exitWith {};

private _displayPosition = [_frequencyControl, _channelControlIdc] call TFAR_fnc_getRadioDialogFrequencyPosition;

if (_showChannelName) then {
    private _offset = _offsetPixels * pixelW;
    private _displayLeft = (_displayPosition select 0) - _offset;
    private _displayRight = (_displayPosition select 0) + (_displayPosition select 2);
    private _displayWidth = _displayRight - _displayLeft;
    private _textWidth = ctrlTextWidth _frequencyControl;

    _displayPosition set [0, _displayLeft];
    _displayPosition set [2, _displayWidth];

    if (_textWidth > 0 && {_textWidth < _displayWidth}) then {
        private _textLeft = _displayLeft + ((_displayWidth - _textWidth) / 2);
        _displayPosition set [0, _textLeft];
        _displayPosition set [2, _displayRight - _textLeft];
    };
};

_frequencyControl ctrlSetPosition _displayPosition;
_frequencyControl ctrlCommit 0;
