/*
 	Name: TFAR_fnc_isRadio
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Checks whether the passed radio is a TFAR radio.
	
	Parameters:
		STRING - Radio classname
 	
 	Returns:
		BOOLEAN
 	
 	Example:
		_isRadio = "NotARadioClass" call TFAR_fnc_isRadio;
*/
private "_result";
_result = getNumber (configFile >> "CfgWeapons" >> _this >> "tf_radio");
<<<<<<< HEAD
if (isNil "_result") then {
=======
if (isNil "_result") then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	_result = 0;
};

(_result == 1)