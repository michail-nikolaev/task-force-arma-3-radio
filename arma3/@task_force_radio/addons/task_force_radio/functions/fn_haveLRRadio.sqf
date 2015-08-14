<<<<<<< HEAD
/*
 	Name: TFAR_fnc_haveLRRadio

 	Author(s):

 	Description:
		Returns whether the player has a LR radio

 	Parameters:
	Nothing

 	Returns:
	BOOLEAN

 	Example:
	_hasLR = call TFAR_fnc_haveLRRadio;
 */
if (isNil {TFAR_currentUnit} || {isNull (TFAR_currentUnit)}) exitWith{false};
count (TFAR_currentUnit call TFAR_fnc_lrRadiosList) > 0
=======
count (call TFAR_fnc_lrRadiosList) > 0
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
