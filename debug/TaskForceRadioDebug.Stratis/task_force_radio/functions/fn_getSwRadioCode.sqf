/**
 * TFAR_fnc_getSwRadioCode
 * Returns side of vehicle, based on model of vehicle, not on who is captured
 * Used for radio model
 * @param vehicle
 * @return side
 *
*/
private ["_result"];
_result = "";
if (([_this, "tf_anprc152_"] call CBA_fnc_find) == 0) then {
	_result = tf_west_radio_code;
};
if (([_this, "tf_anprc148jem_"] call CBA_fnc_find) == 0) then {
	_result = tf_guer_radio_code;
};
if (([_this, "tf_fadak_"] call CBA_fnc_find) == 0) then {
	_result = tf_east_radio_code;
};
_result