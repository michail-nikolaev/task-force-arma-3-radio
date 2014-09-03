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
} count (assignedItems player);
_result