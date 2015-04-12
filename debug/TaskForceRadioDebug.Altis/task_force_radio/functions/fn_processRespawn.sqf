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
	TFAR_currentUnit = call TFAR_fnc_currentUnit;
	
	TF_respawnedAt = time;
	if (alive TFAR_currentUnit) then {
		if (TF_give_microdagr_to_soldier)  then {
			TFAR_currentUnit linkItem "tf_microdagr";
		};
		if (leader TFAR_currentUnit == TFAR_currentUnit) then {	
			if (tf_no_auto_long_range_radio or {backpack TFAR_currentUnit == "B_Parachute"} or {player call TFAR_fnc_isForcedCurator}) exitWith {};
			if ([(backpack TFAR_currentUnit), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1) exitWith {};
			
			private ["_items", "_backPack", "_newItems"];
			_items = backpackItems TFAR_currentUnit;
			_backPack = unitBackpack TFAR_currentUnit;
			TFAR_currentUnit action ["putbag", TFAR_currentUnit];
			sleep 3;
			TFAR_currentUnit addBackpack ((call TFAR_fnc_getDefaultRadioClasses) select 0);			
			_newItems = [];
			{
				if (TFAR_currentUnit canAddItemToBackpack _x) then {
					TFAR_currentUnit addItemToBackpack _x;
				}else{
					_newItems pushBack _x;
				};
				true;
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
				true;
			} count _newItems;
		};
		true call TFAR_fnc_requestRadios;						
	};
};