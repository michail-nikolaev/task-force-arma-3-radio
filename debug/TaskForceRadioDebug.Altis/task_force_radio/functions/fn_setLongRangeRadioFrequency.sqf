/*
 	Name: TFAR_fnc_setLongRangeRadioFrequency
 	
 	Author(s):
		NKey

 	Description:
		Sets the frequency for the active channel on the active LR radio.
	
	Parameters:
		STRING - Frequency
 	
 	Returns:
		Nothing
 	
 	Example:
		"45.48" call TFAR_fnc_setLongRangeRadioFrequency;
*/
if (call TFAR_fnc_haveLRRadio) then {
	[(call TFAR_fnc_activeLrRadio) select 0, (call TFAR_fnc_activeLrRadio) select 1, _this] call TFAR_fnc_setLrFrequency;
};