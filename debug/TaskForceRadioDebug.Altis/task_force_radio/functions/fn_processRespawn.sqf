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
	currentUnit = call TFAR_fnc_currentUnit;
	
	TF_respawnedAt = time;
	if (alive currentUnit) then {
		if (TF_give_microdagr_to_soldier)  then {
			currentUnit linkItem "tf_microdagr";
		};
		if (leader currentUnit == currentUnit) then {	
			if (tf_no_auto_long_range_radio or {backpack currentUnit == "B_Parachute"} or {player call TFAR_fnc_isForcedCurator}) exitWith {};
			if ([(backpack currentUnit), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1) exitWith {};
			
			private ["_items", "_backPack", "_newItems"];
			_items = backpackItems currentUnit;
			_backPack = unitBackpack currentUnit;
			currentUnit action ["putbag", currentUnit];
			sleep 3;
			currentUnit addBackpack ((call TFAR_fnc_getDefaultRadioClasses) select 0);			
			_newItems = [];
			{
				if (currentUnit canAddItemToBackpack _x) then {
					currentUnit addItemToBackpack _x;
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