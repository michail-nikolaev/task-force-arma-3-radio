/*
 	Name: TFAR_fnc_setPersonalRadioFrequency
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the frequency for the active SW radio to passed frequency
 	
 	Parameters: 
		STRING - Frequency
 	
 	Returns:
		Nothing
 	
 	Example:
		"65.12" call TFAR_fnc_setPersonalRadioFrequency;
*/
if (call TFAR_fnc_haveSWRadio) then {
	[(call TFAR_fnc_activeSwRadio), _this] call TFAR_fnc_setSwFrequency;
};