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
<<<<<<< HEAD
if ((vehicle _this) != _this) then {
=======
if (((vehicle _this) != _this) and {(vehicle _this) call TFAR_fnc_isVehicleIsolated}) then {
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	_result = netid (vehicle _this);
	if (_result == "") then {
		_result = "singleplayer";
	};
<<<<<<< HEAD
	if ([_this] call TFAR_fnc_isTurnedOut) then {
		_result = _result + "_turnout";
	} else {
		_result = _result + "_" + str ([(typeof (vehicle _this)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty);
=======
	if ([_this] call CBA_fnc_isTurnedOut) then {
		_result = _result + "_turnout";
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	};
};
_result