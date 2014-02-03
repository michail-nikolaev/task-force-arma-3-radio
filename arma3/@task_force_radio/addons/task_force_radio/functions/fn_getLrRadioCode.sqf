private ["_radio_object", "_result", "_side"];
_radio_object = _this select 0;
_result = "";
if ((_radio_object) isKindOf "Bag_Base") then {
	_side = getText(configFile >> "CfgVehicles" >> typeOf(_radio_object) >> "tf_side");
	if (_side == "West") exitWith {
		_result = tf_west_radio_code;
	};
	if (_side == "East") exitWith {
		_result = tf_east_radio_code;
	};
	_result = tf_guer_radio_code;
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