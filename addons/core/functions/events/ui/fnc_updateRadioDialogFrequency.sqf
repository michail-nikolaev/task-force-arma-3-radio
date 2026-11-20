#include "script_component.hpp"

// The offset on the dialog's edit control opts that layout into displaying names.
private _radio = _this;
private _isLrRadio = _radio isEqualType [];
private _frequency = _radio call ([TFAR_fnc_getSwFrequency, TFAR_fnc_getLrFrequency] select _isLrRadio);
private _editIdc = [SW_EDIT, LR_EDIT] select _isLrRadio;
private _dialog = _radio call TFAR_fnc_getRadioDialogConfig;
private _offset = _dialog >> "edit" >> "tf_channelNameOffset";
if (!isNumber _offset || {!isNumber (_dialog >> "idd")} || {getNumber (_dialog >> "idd") < 0}) exitWith {ctrlSetText [_editIdc, _frequency]};

disableSerialization;
private _control = (findDisplay getNumber (_dialog >> "idd")) displayCtrl _editIdc;
if (isNull _control) exitWith {};

private _name = [_radio, _frequency] call TFAR_fnc_getFrequencyName;
_control setVariable ["TFAR_frequencyRadio", _radio];
uiNamespace setVariable ["TFAR_frequencyControl", _control];

// A numeric-looking label is still a label until the operator starts editing.
private _named = _name isNotEqualTo "";
_control setVariable ["TFAR_frequencyState", ["frequency", "name"] select _named];
_control ctrlSetText ([_frequency, _name] select _named);
private _position = [_control, [SW_CHANNEL, LR_CHANNEL] select _isLrRadio] call TFAR_fnc_getRadioDialogFrequencyPosition;
if (_named) then {
    private _offsetWidth = getNumber _offset * pixelW;
    private _width = (_position select 2) + _offsetWidth;
    private _textWidth = ctrlTextWidth _control;
    private _padding = if (_textWidth > 0) then {0 max ((_width - _textWidth) / 2)} else {0};
    _position set [0, (_position select 0) - _offsetWidth + _padding];
    _position set [2, _width - _padding];
};
_control ctrlSetPosition _position;
_control ctrlCommit 0;
