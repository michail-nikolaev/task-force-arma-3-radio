/*
 	Name: TFAR_fnc_radiosListSorted
 	
 	Author(s):

 	Description:
		Sorts the SW radio list alphabetically.
	
	Parameters:
		Nothing
 	
 	Returns:
		ARRAY - Radio list sorted.
 	
 	Example:
		_radios = call TFAR_fnc_radiosListSorted;
*/
(call TFAR_fnc_radiosList) call BIS_fnc_sortAlphabetically