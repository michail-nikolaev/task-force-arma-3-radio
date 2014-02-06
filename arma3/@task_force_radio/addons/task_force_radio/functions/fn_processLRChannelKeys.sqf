private ["_lr_channel_number", "_hintText", "_result"];
_lr_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveLRRadio) and {alive player}) then {
	_active_lr = call TFAR_fnc_activeLrRadio;
	[_active_lr select 0, _active_lr select 1, _lr_channel_number] call TFAR_fnc_setLrChannel;
	_hintText = format[localize "STR_active_lr_channel", _lr_channel_number + 1];
	hint parseText (_hintText);
	if (dialog) then {
		call compile ([_active_lr  select 0, "tf_dialogUpdate"] call TFAR_fnc_getLrRadioProperty);
	};
	_result = true;
};
_result