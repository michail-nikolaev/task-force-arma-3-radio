/*
 	Name: TFAR_fnc_sendPlayerKilled
 	
 	Author(s):
		NKey

 	Description:
		Notifies the plugin that a unit has been killed.
	
	Parameters:
		OBJECT - Unit that was killed
 	
 	Returns:
		Nothing
 	
 	Example:
		player call TFAR_fnc_sendPlayerKilled;
*/
private ["_request", "_result"];
_this setRandomLip false;
_request = format["KILLED	%1", name _this];
_result = "task_force_radio_pipe" callExtension _request;