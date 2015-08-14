/*
	Name: TFAR_fnc_isPrototypeRadio
	
	Author(s): Garth de Wet (LH)
	
	Description:
	Returns if a radio is a prototype radio.
	
	Parameters: 
	0: STRING - Radio classname
	
	Returns:
	BOOLEAN - True if prototype, false if actual radio.
	
	Example:
	if ("tf_148jem" call TFAR_fnc_isPrototypeRadio) then {
		hint "Prototype";
	};
*/
if (_this == "ItemRadio") exitWith {true};
private "_result";
_result = getNumber (configFile >> "CfgWeapons" >> _this >> "tf_prototype");
<<<<<<< HEAD
if (isNil "_result") then {
=======
if (isNil "_result") then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	_result = 0;
};

(_result == 1)