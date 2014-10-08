/*
 	Name: TFAR_fnc_vehicleID
 	
 	Author(s):
		NKey
 	
 	Description:
		Returns a string with information about the player vehicle, used at the plugin side.
 	
 	Parameters: 
		0: OBJECT - The unit to check.
 	
 	Returns:
		STRING - NetworkID, Turned out
 	
 	Example:
		_vehicleID = player call TFAR_fnc_vehicleID;
*/
private["_result"];
_result = "no";
if ((vehicle _this) != _this) then {
	_result = netid (vehicle _this);
	if (_result == "") then {
		_result = "singleplayer";
	};
	if ([_this] call TFAR_fnc_isTurnedOut) then {
		_result = _result + "_turnout";
	} else {
		_result = _result + "_" + str ([(typeof (vehicle _this)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty);
	};
};
_result