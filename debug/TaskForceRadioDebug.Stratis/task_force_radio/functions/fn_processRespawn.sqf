[] spawn {	
	waitUntil {!(isNull player)};	
	
	respawnedAt = time;
	if (alive player) then
	{
		if (leader player == player) then {	
			if ((isNil "tf_no_auto_long_range_radio") and {backpack player != "B_Parachute"}) then {
				if ((backpack player != "tf_rt1523g") and {backpack player != "tf_anprc155"} and {backpack player != "tf_mr3000"}) then {
					player action ["putbag", player];
					sleep 3;
					if ((player call BIS_fnc_objectSide) == west) then {
						player addBackpack "tf_rt1523g";
					} else {
						if ((player call BIS_fnc_objectSide) == east) then {
							player addBackpack "tf_mr3000";	
						} else {
							player addBackpack "tf_anprc155";
						};
					};
				};
			};
		};
		true call TFAR_fnc_requestRadios;						
	};
};