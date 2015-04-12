/*
 	Name: TFAR_fnc_radiosList
 	
 	Author(s):
		NKey

 	Description:
		List of all the player's SW radios.
	
	Parameters:
		0: OBJECT: unit
 	
 	Returns:
		ARRAY - List of all the player's SW radios.
 	
 	Example:
		_radios = TFAR_currentUnit call TFAR_fnc_radiosList;
*/
private ["_result"];
_result = [];
{	
	if (_x call TFAR_fnc_isRadio) then {
		_result pushBack _x;
	};
	true;
} count (assignedItems _this);

{
	if (_x call TFAR_fnc_isRadio) then {
		_result pushBack _x;
	};
	true;
} count (items _this);
_result