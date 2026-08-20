#include "script_component.hpp"

/*
  Name: TFAR_fnc_getRadioDialogFrequencyPosition

  Author: Darojax
    Returns the unmodified frequency-control position relative to the channel
    control, allowing movable radio dialogs to retain their current location.

  Arguments:
    0: Frequency edit control <CONTROL>
    1: Channel control IDC <NUMBER>

  Return Value:
    Frequency control position <ARRAY>

  Public: No
*/

params [
    ["_frequencyControl", controlNull, [controlNull]],
    ["_channelControlIdc", -1, [0]]
];

if (isNull _frequencyControl) exitWith {[]};

private _channelControl = (ctrlParent _frequencyControl) displayCtrl _channelControlIdc;
if (isNull _channelControl) exitWith {ctrlPosition _frequencyControl};

private _relativePosition = _frequencyControl getVariable ["TFAR_frequencyPositionRelativeToChannel", []];

if (count _relativePosition != 4) then {
    private _frequencyPosition = ctrlPosition _frequencyControl;
    private _channelPosition = ctrlPosition _channelControl;

    _relativePosition = [
        (_frequencyPosition select 0) - (_channelPosition select 0),
        (_frequencyPosition select 1) - (_channelPosition select 1),
        _frequencyPosition select 2,
        _frequencyPosition select 3
    ];
    _frequencyControl setVariable ["TFAR_frequencyPositionRelativeToChannel", _relativePosition];
};

private _channelPosition = ctrlPosition _channelControl;
[
    (_channelPosition select 0) + (_relativePosition select 0),
    (_channelPosition select 1) + (_relativePosition select 1),
    _relativePosition select 2,
    _relativePosition select 3
]
