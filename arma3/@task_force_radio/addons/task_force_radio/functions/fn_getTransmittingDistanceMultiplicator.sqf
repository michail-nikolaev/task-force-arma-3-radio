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
<<<<<<< HEAD
_result = TFAR_currentUnit getVariable "tf_sendingDistanceMultiplicator";
=======
_result = player getVariable "tf_sendingDistanceMultiplicator";
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
if (isNil "_result") then {
	_result = 1.0;
};
_result;