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
<<<<<<< HEAD
if (isNil "_result") then {
=======
if (isNil "_result") then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	_result = ([(typeof _this), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1);
};
_result