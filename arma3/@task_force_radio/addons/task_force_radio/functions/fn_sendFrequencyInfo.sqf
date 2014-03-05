private ["_request","_result","_freq","_freq_lr","_freq_dd","_alive","_nickname","_isolated_and_inside","_can_speak"];

// send frequencies
_freq = ["No_SW_Radio"];
_freq_lr = ["No_LR_Radio"];
_freq_dd = "No_DD_Radio";

_isolated_and_inside = player call TFAR_fnc_vehicleIsIsolatedAndInside;
_can_speak = [player, _isolated_and_inside] call TFAR_fnc_canSpeak;

if ((call TFAR_fnc_haveSWRadio) and {[player, _isolated_and_inside, _can_speak] call TFAR_fnc_canUseSWRadio}) then {
	_freq = [];
	{
		_freq set[count _freq, format ["%1%2|%3|%4", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getSwStereo]];
	} forEach (call TFAR_fnc_radiosList);
};
if ((call TFAR_fnc_haveLRRadio) and {[player, _isolated_and_inside] call TFAR_fnc_canUseLRRadio}) then {
	_freq_lr = [];
	{
		_freq_lr set[count _freq_lr, format ["%1%2|%3|%4", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getLrStereo]];
	} forEach (call TFAR_fnc_lrRadiosList);				
};
if ((call TFAR_fnc_haveDDRadio) and {[player, _isolated_and_inside] call TFAR_fnc_canUseDDRadio}) then {
	_freq_dd = TF_dd_frequency;
};
_alive = alive player;
_nickname = name player;
_request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	", str(_freq), str(_freq_lr), _freq_dd, _alive, TF_speak_volume_meters, TF_dd_volume_level, _nickname, waves];
_result = "task_force_radio_pipe" callExtension _request;