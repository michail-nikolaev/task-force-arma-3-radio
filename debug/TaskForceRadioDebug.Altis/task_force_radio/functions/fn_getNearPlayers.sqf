private ["_result","_index","_players_in_group","_add_to_near","_was_speaking"];
_players_in_group = count (units (group player));
_result = [];
if (alive player) then {
	private "_allUnits";
	_allUnits = (if(isMultiplayer)then{playableUnits}else{switchableUnits});
	_index = 0;
	{			
		//if (isPlayer _x) then {
			_add_to_near = false;
			if ((_players_in_group < 10) and {group player == group _x}) then {
				_add_to_near = true; 
			};

			_was_speaking = _x getVariable "tf_start_speaking";
			if (!(isNil "_was_speaking") and {diag_tickTime - _was_speaking < 20}) then {
				_add_to_near = true;
			};

			if (_add_to_near or {(player distance _x < 60)}) then {				
				_result set[_index, _x];
				_index = _index + 1;
			} 
		//};
	} count _allUnits;
};
_result