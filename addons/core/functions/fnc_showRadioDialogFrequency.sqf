#include "script_component.hpp"

/*
  Name: TFAR_fnc_showRadioDialogFrequency

  Author: Darojax
    Replaces a displayed channel name with its editable frequency when the
    player clicks the frequency field.

  Arguments:
    0: Frequency edit control <CONTROL>
    1: Radio <ARRAY|STRING>
    2: Long-range radio <BOOL>
    3: Channel control IDC <NUMBER>

  Return Value:
    None

  Public: No
*/

params [
    ["_frequencyControl", controlNull, [controlNull]],
    ["_radio", "", [[], ""]],
    ["_isLrRadio", false, [false]],
    ["_channelControlIdc", -1, [0]]
];

if (isNull _frequencyControl) exitWith {};

private _channel = _radio call ([TFAR_fnc_getSwChannel, TFAR_fnc_getLrChannel] select _isLrRadio);
private _channelName = [_radio, _channel + 1] call TFAR_fnc_getChannelName;

if (_channelName isEqualTo "" || {ctrlText _frequencyControl isNotEqualTo _channelName}) exitWith {};

_frequencyControl ctrlSetPosition ([_frequencyControl, _channelControlIdc] call TFAR_fnc_getRadioDialogFrequencyPosition);
_frequencyControl ctrlCommit 0;
_frequencyControl ctrlSetText (_radio call ([TFAR_fnc_getSwFrequency, TFAR_fnc_getLrFrequency] select _isLrRadio));
