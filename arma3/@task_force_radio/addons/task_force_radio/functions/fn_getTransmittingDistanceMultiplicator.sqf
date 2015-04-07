/*
 	Name: TFAR_fnc_getTransmittingDistanceMultiplicator
 	
 	Author(s):
		NKey

 	Description:
		Return multiplicator for sending distance of radio.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_getTransmittingDistanceMultiplicator;
*/
private ["_result"];
_result = TFAR_currentUnit getVariable "tf_sendingDistanceMultiplicator";
if (isNil "_result") then {
	_result = 1.0;
};
_result;