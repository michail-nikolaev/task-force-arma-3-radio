/*
 	Name: TFAR_fnc_hasVehicleRadio
 	
 	Author(s):
		NKey

 	Description:
		Checks _this for LW radio presence
	
	Parameters:
		OBJECT: Vehicle to check
 	
 	Returns:
		BOOL: True|False
 	
 	Example:
		_present = (vehicle player) call TFAR_fnc_hasVehicleRadio;;
*/
 
private "_result";
_result = _this getVariable "tf_hasRadio";
if (isNil "_result") then {
	_result = ([(typeof _this), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1);
};
_result