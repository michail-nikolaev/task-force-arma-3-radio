/*
 	Name: TFAR_fnc_sendVersionInfo
 	
 	Author(s):
		NKey

 	Description:
		Sends information about the current TFAR version.
	
	Parameters:
		Nothing
		
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_sendVersionInfo;
*/
// send information about version
private ["_request","_result"];
_request = format["VERSION	%1	%2	%3", TF_ADDON_VERSION, tf_radio_channel_name, tf_radio_channel_password];
_result = "task_force_radio_pipe" callExtension _request;