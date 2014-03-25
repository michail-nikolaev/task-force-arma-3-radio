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
	if (alive player) then
	{
		if (leader player == player) then
		{	
			if (tf_no_auto_long_range_radio or {backpack player == "B_Parachute"}) exitWith {};
			if ([(backpack player), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1) exitWith {};
			
			private ["_items", "_backPack", "_newItems"];
			_items = backpackItems player;
			_backPack = unitBackpack player;
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
			_newItems = [];
			{
				if (player canAddItemToBackpack _x) then
				{
					player addItemToBackpack _x;
				}
				else
				{
					_newItems set [count _newItems, _x];
				};
			} count _items;
			
			clearItemCargoGlobal _backPack;
			clearMagazineCargoGlobal _backPack;
			clearWeaponCargoGlobal _backPack;
			{
				if (isClass (configFile >> "CfgMagazines" >> _x)) then
				{
					_backPack addMagazineCargoGlobal [_x, 1];
				}
				else
				{
					_backPack addItemCargoGlobal [_x, 1];
					_backPack addWeaponCargoGlobal [_x, 1];
				};
			} count _newItems;
		};
		true call TFAR_fnc_requestRadios;						
	};
};