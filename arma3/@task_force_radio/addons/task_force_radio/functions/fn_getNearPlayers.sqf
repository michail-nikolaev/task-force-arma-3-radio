<<<<<<< HEAD
private ["_result","_index","_players_in_group","_spectator", "_v"];
_players_in_group = count (units (group TFAR_currentUnit));
_result = [];
if (alive TFAR_currentUnit) then {
	private "_allUnits";
	_allUnits = TFAR_currentUnit nearEntities ["Man", TF_max_voice_volume];
	
	if (_players_in_group < 10) then {
		{
			if (_x != TFAR_currentUnit) then {
				_allUnits pushBack _x;
			};
			true;
		} count (units (group TFAR_currentUnit));
	};
	
	{
		_v = _x;		
		{ 			
			_allUnits pushBack _x;
		} forEach (crew _v);
	} forEach  (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_max_voice_volume]);
	
	{		
		if !(_x in _allUnits) then {
			_allUnits pushBack _x;	
		};
		true;
	} count (call BIS_fnc_listCuratorPlayers);
		
	{			
		if ((isPlayer _x) and {alive _x}) then {				
=======
private ["_result","_index","_players_in_group","_add_to_near","_was_speaking", "_spectator"];
_players_in_group = count (units (group player));
_result = [];
if (alive player) then {
	private "_allUnits";
	_allUnits = allUnits;
	_index = 0;
	{			
		if (isPlayer _x) then {
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
			_spectator = _x getVariable "tf_forceSpectator";
			if (isNil "_spectator") then {
				_spectator = false;
			};
			if (!_spectator) then {
<<<<<<< HEAD
				_result pushBack _x;	
			};
		};
		true;
=======
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
			};
		};
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	} count _allUnits;
};
_result