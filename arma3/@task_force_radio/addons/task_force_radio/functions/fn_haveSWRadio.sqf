<<<<<<< HEAD
/*
 	Name: TFAR_fnc_haveSWRadio

 	Author(s):

 	Description:
		Returns whether the player has a SW radio

 	Parameters:
	Nothing

 	Returns:
	BOOLEAN

 	Example:
	_hasSW = call TFAR_fnc_haveSWRadio;
 */
private ["_result"];
_result = false;
if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith{false};
{
	if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
	true;
} count (assignedItems TFAR_currentUnit);
_result
=======
private ["_result"];
_result = false;
{	
	if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
} count (assignedItems player);
_result
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
