private ["_radio_object", "_result", "_encryptionCode"];
_radio_object = _this select 0;
_result = "";
if ((_radio_object) isKindOf "Bag_Base") then {
	_result = missionNamespace getVariable [getText(configFile >> "CfgVehicles" >> typeOf(_radio_object) >> "tf_encryptionCode"), ""];
} else {
	if (((_radio_object) call TFAR_fnc_getVehicleSide) == west) then {
		_result = missionNamespace getVariable [getText(configFile >> "CfgVehicles" >> TF_defaultWestBackpack >> "tf_encryptionCode"), ""];
	} else {
		if (((_radio_object) call TFAR_fnc_getVehicleSide) == east) then {
			_result = missionNamespace getVariable [getText(configFile >> "CfgVehicles" >> TF_defaultEastBackpack >> "tf_encryptionCode"), ""];
		} else {
			_result = missionNamespace getVariable [getText(configFile >> "CfgVehicles" >> TF_defaultGuerBackpack >> "tf_encryptionCode"), ""];
		};
	};
};
_result