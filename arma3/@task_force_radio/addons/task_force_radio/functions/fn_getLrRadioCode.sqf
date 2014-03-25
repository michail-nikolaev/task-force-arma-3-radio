/*
 	Name: TFAR_fnc_getLrRadioCode
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
		Returns the encryption code for the passed radio.
 	
 	Parameters: 
 	0: OBJECT - Radio
 	
 	Returns:
	STRING - Encryption code
 	
 	Example:
	(call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrRadioCode;
*/
((_this call TFAR_fnc_getLrSettings) select TF_CODE_OFFSET)