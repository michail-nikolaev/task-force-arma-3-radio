#include "script_component.hpp"

/*
  Name: TFAR_fnc_clearRadioDialogFrequency

  Author: Darojax
    Restores a radio's original frequency-control geometry and prepares it for
    manual frequency entry.

  Arguments:
    0: Frequency edit control <CONTROL>
    1: Channel control IDC <NUMBER>

  Return Value:
    None

  Public: No
*/

params [
    ["_frequencyControl", controlNull, [controlNull]],
    ["_channelControlIdc", -1, [0]]
];

if (isNull _frequencyControl) exitWith {};

_frequencyControl ctrlSetPosition ([_frequencyControl, _channelControlIdc] call TFAR_fnc_getRadioDialogFrequencyPosition);
_frequencyControl ctrlCommit 0;
_frequencyControl ctrlSetText "";
ctrlSetFocus _frequencyControl;
