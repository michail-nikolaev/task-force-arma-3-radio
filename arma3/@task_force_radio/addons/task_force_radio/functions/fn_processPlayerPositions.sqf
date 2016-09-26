/*
 	Name: TFAR_fnc_processPlayerPositions
 	
 	Author(s):
		NKey

 	Description:
		Process some player positions on each call and sends it to the plugin.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_processPlayerPositions;
*/
private ["_elemsNearToProcess","_elemsFarToProcess","_other_units", "_unit", "_controlled", "_speakers"];
if !(isNull (findDisplay 46)) then {
	if !(isNull TFAR_currentUnit) then {
		if ((tf_farPlayersProcessed) and {tf_nearPlayersProcessed}) then {				
			tf_nearPlayersIndex = 0;
			tf_farPlayersIndex = 0;		

			if (count tf_nearPlayers == 0) then {
				tf_nearPlayers = call TFAR_fnc_getNearPlayers;
			};

			_other_units = allUnits - tf_nearPlayers;
			
				
			{		
				if !(_x in _other_units) then {
					_other_units pushBack _x;	
				};
				true;
			} count (call BIS_fnc_listCuratorPlayers);//Add curators
			
			
			tf_farPlayers = [];
			tf_farPlayersIndex = 0;	
			{
				_spectator = _x getVariable "tf_forceSpectator";
				if (isNil "_spectator") then {
					_spectator = false;
				};
				if ((isPlayer _x) and {!_spectator}) then {
					tf_farPlayers set[tf_farPlayersIndex, _x];
					tf_farPlayersIndex = tf_farPlayersIndex + 1;
				};
				true;
			} count _other_units;
			
			tf_farPlayersIndex = 0;	

			if (count tf_nearPlayers > 0) then {			
				tf_nearPlayersProcessed = false;
				tf_msNearPerStep = tf_msNearPerStepMax max (tf_nearUpdateTime / (count tf_nearPlayers));
				tf_msNearPerStep = tf_msNearPerStep min tf_msNearPerStepMin;
			} else {
				tf_msNearPerStep = tf_nearUpdateTime;
			};
			if (count tf_farPlayers > 0) then {
				tf_farPlayersProcessed = false;
				if (count tf_nearPlayers > 0) then {
					tf_msFarPerStep = tf_msFarPerStepMax max (tf_farUpdateTime / (count tf_farPlayers));
					tf_msFarPerStep = tf_msFarPerStep min tf_msFarPerStepMin;
				} else {
					tf_msFarPerStep = tf_msSpectatorPerStepMax;
				};
			} else {
				tf_msFarPerStep = tf_farUpdateTime;
			};
			call TFAR_fnc_sendVersionInfo;
		} else {
			_elemsNearToProcess = (diag_tickTime - tf_lastNearFrameTick) / tf_msNearPerStep;		
			if (_elemsNearToProcess >= 1) then {
				for "_y" from 0 to _elemsNearToProcess step 1 do {
					if (tf_nearPlayersIndex < count tf_nearPlayers) then {
						_unit = (tf_nearPlayers select tf_nearPlayersIndex);
						_controlled = _unit getVariable "tf_controlled_unit";
						if !(isNil "_controlled") then {
							[_controlled, true, name _unit] call TFAR_fnc_sendPlayerInfo;
						} else {
							[_unit, true, name _unit] call TFAR_fnc_sendPlayerInfo;
						};					
						tf_nearPlayersIndex = tf_nearPlayersIndex + 1;
					} else {
						tf_nearPlayersIndex = 0;
						tf_nearPlayersProcessed = true;					

						if (diag_tickTime - tf_lastNearPlayersUpdate > 0.5) then {	
							tf_nearPlayers = call TFAR_fnc_getNearPlayers;						
							tf_lastNearPlayersUpdate = diag_tickTime;						
						};
						
						call TFAR_fnc_processSpeakerRadios;
						
						_speakers = "SPEAKERS	";
						{
							_speakers = _speakers + TF_vertical_tab + _x;
						} count (tf_speakerRadios);
						"task_force_radio_pipe" callExtension _speakers;

						tf_speakerRadios = [];
					};
				};
				tf_lastNearFrameTick = diag_tickTime;
			};

			_elemsFarToProcess = (diag_tickTime - tf_lastFarFrameTick) / tf_msFarPerStep;
			if (_elemsFarToProcess >= 1) then {
				for "_y" from 0 to _elemsFarToProcess step 1 do {
					if (tf_farPlayersIndex < count tf_farPlayers) then {
						_unit = (tf_farPlayers select tf_farPlayersIndex);
						[_unit, false, name _unit] call TFAR_fnc_sendPlayerInfo;
						tf_farPlayersIndex = tf_farPlayersIndex + 1;
					} else {
						tf_farPlayersIndex = 0;
						tf_farPlayersProcessed = true;
					};
				};
				tf_lastFarFrameTick = diag_tickTime;
			};
		};
		if (diag_tickTime - tf_lastFrequencyInfoTick > 0.5) then {
			call TFAR_fnc_sendFrequencyInfo;
			tf_lastFrequencyInfoTick = diag_tickTime;
		};
	};
};
