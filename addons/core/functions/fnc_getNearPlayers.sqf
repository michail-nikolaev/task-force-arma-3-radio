#include "script_component.hpp"

private _players_in_group = count (units (group TFAR_currentUnit));
private _result = [];

if (alive TFAR_currentUnit) then {
    private _allUnits = TFAR_currentUnit nearEntities ["Man", TF_max_voice_volume];
    
    if (_players_in_group < 10) then {
        {
            if (_x != TFAR_currentUnit) then {
                _allUnits pushBack _x;
            };
            true;
        } count (units (group TFAR_currentUnit));
    };
    
    {
        private _vehicle = _x;
        {    
            _allUnits pushBack _x;
        } forEach (crew _vehicle);
    } forEach  (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_max_voice_volume]);
    
        
    {
        if ((isPlayer _x) and {alive _x}) then {
            private _spectator = _x getVariable ["tf_forceSpectator",false];
            if (!_spectator) then {
                _result pushBack _x;
            };
        };
        true;
    } count _allUnits;
};
_result
