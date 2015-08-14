/*
 	Name: TFAR_fnc_radiosList
 	
 	Author(s):
		NKey

 	Description:
		List of all the player's SW radios.
	
	Parameters:
<<<<<<< HEAD
		0: OBJECT: unit
=======
		Nothing
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Returns:
		ARRAY - List of all the player's SW radios.
 	
 	Example:
<<<<<<< HEAD
		_radios = TFAR_currentUnit call TFAR_fnc_radiosList;
=======
		_radios = call TFAR_fnc_radiosList;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
*/
private ["_result"];
_result = [];
{	
<<<<<<< HEAD
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
=======
	if (_x call TFAR_fnc_isRadio) then 
	{
		_result set[count _result, _x];
	};
} count (assignedItems player);

{
	if (_x call TFAR_fnc_isRadio) then 
	{
		_result set[count _result, _x];
	};
} count (items player);
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
_result