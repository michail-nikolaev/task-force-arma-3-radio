/*
 	Name: TFAR_fnc_getTeamSpeakChannelName
 	
 	Author(s):
		NKey

 	Description:
		Returns TeamSpeak channel name.
	
	Parameters:
		Nothing
 	
 	Returns:
		STRING: name of channel
 	
 	Example:
		call TFAR_fnc_getTeamSpeakChannelName;
*/
"task_force_radio_pipe" callExtension "TS_INFO	CHANNEL"