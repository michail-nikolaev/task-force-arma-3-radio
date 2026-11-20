#include "script_component.hpp"

params ["_control", ["_clear", false]];
if (isNull _control) exitWith {};

private _wasName = (_control getVariable ["TFAR_frequencyState", ""]) == "name";
_control setVariable ["TFAR_frequencyState", "editing"];
if (_wasName) then {
    private _radio = _control getVariable "TFAR_frequencyRadio";
    private _isLrRadio = _radio isEqualType [];
    _control ctrlSetPosition ([_control, [SW_CHANNEL, LR_CHANNEL] select _isLrRadio] call TFAR_fnc_getRadioDialogFrequencyPosition);
    _control ctrlCommit 0;
    if (!_clear) then {
        _control ctrlSetText (_radio call ([TFAR_fnc_getSwFrequency, TFAR_fnc_getLrFrequency] select _isLrRadio));
    };
};
if (_clear) then {
    _control ctrlSetText "";
    ctrlSetFocus _control;
};
