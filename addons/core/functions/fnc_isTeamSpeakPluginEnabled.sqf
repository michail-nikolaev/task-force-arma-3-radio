/*
 	Name: TFAR_fnc_isTeamSpeakPluginEnabled
 	
 	Author(s):
		NKey

 	Description:
		Returns is TeamSpeak plugin enabled on client.
	
	Parameters:
		Nothing
 	
 	Returns:
		BOOLEAN: enabled or not
 	
 	Example:
		call TFAR_fnc_isTeamSpeakPluginEnabled;
*/
("task_force_radio_pipe" callExtension "TS_INFO	PING") == "PONG"