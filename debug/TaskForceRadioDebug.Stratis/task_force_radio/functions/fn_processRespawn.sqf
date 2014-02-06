[] spawn {	
	waitUntil {!(isNull player)};	
	
	TF_respawnedAt = time;
	if (alive player) then
	{
		if (leader player == player) then
		{	
			if (tf_no_auto_long_range_radio or {backpack player == "B_Parachute"}) exitWith {};
			if ([(backpack player), "tf_hasLRradio"] call TFAR_fnc_getConfigProperty == 1) exitWith {};
			
			player action ["putbag", player];
			sleep 3;
			if ((player call BIS_fnc_objectSide) == west) then
			{
				player addBackpack TF_defaultWestBackpack;
			} else {
				if ((player call BIS_fnc_objectSide) == east) then
				{
					player addBackpack TF_defaultEastBackpack;
				} else {
					player addBackpack TF_defaultGuerBackpack;
				};
			};
		};
		true call TFAR_fnc_requestRadios;						
	};
};