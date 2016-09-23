/*
 	Name: TFAR_fnc_getSwRadioCode
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
		Returns the encryption code for the passed radio.
 	
 	Parameters: 
 	0: STRING - Radio classname
 	
 	Returns:
	STRING - Encryption code
 	
 	Example:
	(call TFAR_fnc_activeSwRadio) call TFAR_fnc_getSwRadioCode;
*/
((_this call TFAR_fnc_getSwSettings) select TF_CODE_OFFSET)