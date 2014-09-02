/*
 	Name: TFAR_fnc_processRespawn
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Handles getting switching radios, handles whether a manpack must be added to the player or not.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_processRespawn;
*/
[] spawn {	
	waitUntil {!(isNull player)};	
	
	TF_respawnedAt = time;
	if (alive player) then {
		if (leader player == player) then {	
			if (tf_no_auto_long_range_radio or {backpack player == "B_Parachute"}) exitWith {};
			if ([(backpack player), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1) exitWith {};
			
			private ["_items", "_backPack", "_newItems"];
			_items = backpackItems player;
			_backPack = unitBackpack player;
			player action ["putbag", player];
			sleep 3;
			player addBackpack ((call TFAR_fnc_getDefaultRadioClasses) select 0);			
			_newItems = [];
			{
				if (player canAddItemToBackpack _x) then {
					player addItemToBackpack _x;
				}else{
					_newItems pushBack _x;
				};
			} count _items;
			
			clearItemCargoGlobal _backPack;
			clearMagazineCargoGlobal _backPack;
			clearWeaponCargoGlobal _backPack;
			{
				if (isClass (configFile >> "CfgMagazines" >> _x)) then{
					_backPack addMagazineCargoGlobal [_x, 1];
				}else{
					_backPack addItemCargoGlobal [_x, 1];
					_backPack addWeaponCargoGlobal [_x, 1];
				};
			} count _newItems;
		};
		true call TFAR_fnc_requestRadios;						
	};
};