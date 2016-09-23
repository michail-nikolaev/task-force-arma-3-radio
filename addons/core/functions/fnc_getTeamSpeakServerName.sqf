/*
 	Name: TFAR_fnc_getTeamSpeakServerName
 	
 	Author(s):
		NKey

 	Description:
		Returns TeamSpeak server name.
	
	Parameters:
		Nothing
 	
 	Returns:
		STRING: name of server
 	
 	Example:
		call TFAR_fnc_getTeamSpeakServerName;
*/
"task_force_radio_pipe" callExtension "TS_INFO	SERVER"