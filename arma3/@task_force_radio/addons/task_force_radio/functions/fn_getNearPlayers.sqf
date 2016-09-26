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
		if ((isPlayer _x) and {alive _x}) then {				
			_spectator = _x getVariable "tf_forceSpectator";
			if (isNil "_spectator") then {
				_spectator = false;
			};
			if (!_spectator) then {
				_result pushBack _x;	
			};
		};
		true;
	} count _allUnits;
};
_result