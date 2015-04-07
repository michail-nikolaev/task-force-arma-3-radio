/*
 	Name: TFAR_fnc_sessionTracker
 	
 	Author(s):
		NKey

 	Description:
		Collects some statistic information to help make TFAR better.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_sessionTracker
*/
[] spawn {
	private ["_request", "_action"];
	waitUntil {sleep 10;!(isNull player)};
	_action = "start";
	if (isMultiplayer) then {
		sleep (60 * 1);		
		 while {true} do {
			_request = format['TRACK	piwik.php?idsite=2&rec=1&url="radio.task-force.ru&action_name=%1&rand=%2&uid=%3&cvar={"1":["group","%4"], "2":["playableUnits","%5"], "3":["allUnits","%6"], "4":["BIS_fnc_listCuratorPlayers","%7"], "5":["playerSide","%8"], "5":["faction","%9"], "6":["isServer","%10"], "7":["isDedicated","%11"], "8":["missionName","%12"], "9":["currentSW","%13"], "10":["currentLR","%14"], "11":["nearPlayers","%15"], "12":["farPlayers","%16"], "13":["typeof","%17"], "14":["diag_fps","%18"], "15":["diag_fpsmin","%19"], "16":["daytime","%20"], "17":["vehicle","%21"], "18":["time","%22"], "19":["version","%23"]}', _action, random 1000, getPlayerUID player, count (units group player), count playableUnits, count allUnits, count (call BIS_fnc_listCuratorPlayers), playerSide, faction player, isServer, isDedicated, missionName, count (TFAR_currentUnit call TFAR_fnc_radiosList), count (TFAR_currentUnit call TFAR_fnc_lrRadiosList), count tf_nearPlayers, count tf_farPlayers, typeof TFAR_currentUnit, diag_fps, diag_fpsmin, daytime, typeof (vehicle TFAR_currentUnit), time, TF_ADDON_VERSION];
			"task_force_radio_pipe" callExtension _request;
			_action = "continue";
			sleep (60 * 10);
		};
	};

};