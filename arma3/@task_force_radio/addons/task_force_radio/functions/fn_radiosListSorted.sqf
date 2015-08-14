/*
 	Name: TFAR_fnc_radiosListSorted
 	
 	Author(s):

 	Description:
		Sorts the SW radio list alphabetically.
	
	Parameters:
		0: OBJECT: Unit
 	
 	Returns:
		ARRAY - Radio list sorted.
 	
 	Example:
		_radios = TFAR_currentUnit call TFAR_fnc_radiosListSorted;
*/
(_this call TFAR_fnc_radiosList) call BIS_fnc_sortAlphabetically