/*
 	Name: TFAR_fnc_generateDDFreq
 	
 	Author(s):
		NKey		

 	Description:
		Generate diver radio freq.
	
	Parameters:
		NOTHING
 	
 	Returns:
		NOTHING
 	
 	Example:
		call TFAR_fnc_generateDDFreq;
*/
str (round (((random (TF_MAX_DD_FREQ - TF_MIN_DD_FREQ)) + TF_MIN_DD_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER)