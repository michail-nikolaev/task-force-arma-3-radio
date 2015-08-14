/*
 	Name: TFAR_fnc_radiosListSorted
 	
 	Author(s):

 	Description:
		Sorts the SW radio list alphabetically.
	
	Parameters:
<<<<<<< HEAD
		0: OBJECT: Unit
=======
		Nothing
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
 	
 	Returns:
		ARRAY - Radio list sorted.
 	
 	Example:
<<<<<<< HEAD
		_radios = TFAR_currentUnit call TFAR_fnc_radiosListSorted;
*/
(_this call TFAR_fnc_radiosList) call BIS_fnc_sortAlphabetically
=======
		_radios = call TFAR_fnc_radiosListSorted;
*/
(call TFAR_fnc_radiosList) call BIS_fnc_sortAlphabetically
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
