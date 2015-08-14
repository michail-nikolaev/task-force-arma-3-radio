/*
 	Name: TFAR_fnc_activeSwRadio
 	
 	Author(s):
		NKey

 	Description:
		Returns the active SW radio.
	
	Parameters:
		Nothing
 	
 	Returns:
		STRING: Active SW radio
 	
 	Example:
		_radio = call TFAR_fnc_activeSwRadio;
*/
private ["_result"];
_result = nil;
{	
	if (_x call TFAR_fnc_isRadio) exitWith {_result = _x};
<<<<<<< HEAD
	true;
} count (assignedItems TFAR_currentUnit);
=======
	
} count (assignedItems player);
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
_result