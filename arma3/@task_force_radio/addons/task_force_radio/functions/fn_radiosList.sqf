/*
 	Name: TFAR_fnc_radiosList
 	
 	Author(s):
		NKey

 	Description:
		List of all the player's SW radios.
	
	Parameters:
		Nothing
 	
 	Returns:
		ARRAY - List of all the player's SW radios.
 	
 	Example:
		_radios = call TFAR_fnc_radiosList;
*/
private ["_result"];
_result = [];
{	
	if (_x call TFAR_fnc_isRadio) then 
	{
		_result set[count _result, _x];
	};
} forEach (assignedItems player);

{
	if (_x call TFAR_fnc_isRadio) then 
	{
		_result set[count _result, _x];
	};
} forEach (items player);
_result