// by commy2 v0.4
 
private "_fnc_getTurrets";
 
_fnc_getTurrets = {
        private ["_vehicle", "_config", "_turrets", "_fnc_addTurrets"];
 
        _vehicle = _this select 0;
 
        _config = configFile >> "CfgVehicles" >> typeOf _vehicle;
 
        _turrets = [];
 
        _fnc_addTurret = {
                private ["_config", "_path", "_count", "_index"];
 
                _config = _this select 0;
                _path = _this select 1;
 
                _config = _config >> "Turrets";
                _count = count _config;
 
                for "_index" from 0 to (_count - 1) do {
                        _turrets set [count _turrets, _path + [_index]];
                        [_config select _index, [_index]] call _fnc_addTurret;
                };
        };
 
        [_config, []] call _fnc_addTurret;
 
        _turrets
};
 
private "_fnc_getTurretIndex";
 
_fnc_getTurretIndex = {
        private ["_unit", "_vehicle", "_turrets", "_units", "_index"];
 
        _unit = _this select 0;
        _vehicle = vehicle _unit;
 
        _turrets = [_vehicle] call _fnc_getTurrets;
 
        _units = [];
        {
                _units set [count _units, _vehicle turretUnit _x];
        } forEach _turrets;
 
        _index = _units find _unit;
 
        if (_index == -1) exitWith {[]};
 
        _turrets select _index;
};
 
private ["_unit", "_vehicle", "_config", "_animation", "_action", "_inAction", "_turretIndex", "_count", "_index", "_result"];
 
_unit = _this select 0;
_vehicle = vehicle _unit;
_config = configFile >> "CfgVehicles" >> typeOf _vehicle;
_result = false;

if (_vehicle== _unit) then {
	_result = true;
} else {
	if ((driver _vehicle == _unit) && {getNumber(_config >> "forceHideDriver") == 1}) then {
		_result = false;
	} else {
		if ((commander _vehicle == _unit) && {getNumber(_config >> "forceHideCommander") == 1}) then {
			_result = false;
		} else {
			_animation = animationState _unit;
 
			if (_unit == driver _vehicle) then {
					_action = getText (_config >> "driverAction");
					_inAction = getText (_config >> "driverInAction");
			} else {
					_turretIndex = [_unit] call _fnc_getTurretIndex;
			 
					_count = count _turretIndex;
			 
					for "_index" from 0 to (_count - 1) do {
							_config = _config >> "Turrets";
							_config = _config select (_turretIndex select _index);
					};
			 
					_action = getText (_config >> "gunnerAction");
					_inAction = getText (_config >> "gunnerInAction");					
			};
			 
			if (_action == "" || {_inAction == ""} || {_action == _inAction}) exitWith {_result = false};
			 
			_animation = toArray _animation;
			_animation resize (count toArray _action);
			_animation = toString _animation;
			_result = (_animation == _action);
		};		
	};
};
_result;


