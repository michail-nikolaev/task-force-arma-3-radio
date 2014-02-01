private ["_radio_object", "_result"];
_radio_object = _this select 0;
_result = "";
if ((_radio_object) isKindOf "Bag_Base") then {				
	if (typeOf(_radio_object) == "tf_rt1523g") then {
		_result = tf_west_radio_code;
	};
	if (typeOf(_radio_object) == "tf_anprc155") then {
		_result = tf_guer_radio_code;
	};
	if (typeOf(_radio_object) == "tf_mr3000") then {
		_result = tf_east_radio_code;
	};
} else {
	if (((_radio_object) call TFAR_fnc_getVehicleSide) == west) then {
		_result = tf_west_radio_code;
	} else {
		if (((_radio_object) call TFAR_fnc_getVehicleSide) == east) then {
			_result = tf_east_radio_code;
		} else {
			_result = tf_guer_radio_code;
		}
	};
};
_result