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
if (isNil "_result") then {
	_result = 0;
};

(_result == 1)