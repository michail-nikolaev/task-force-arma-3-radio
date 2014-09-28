private ["_item", "_freq", "_pos", "_unit_pos", "_p", "_manpack", "_lrs", "_isolation"];
_unit_pos = eyepos currentUnit;
{
	_pos = getPosASL _x;
	_p = [(_pos select 0) - (_unit_pos select 0), (_pos select 1) - (_unit_pos select 1), (_pos select 2) - (_unit_pos select 2)];
	{
		if ((_x call TFAR_fnc_isRadio) and {_x call TFAR_fnc_getSwSpeakers}) then {
			_freq = format ["%1%2", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode];
			if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
				_freq = _freq + format ["|%1%2", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode];
			};			
			tf_speakerRadios pushBack (format ["%1	%2	%3	%4	%5	%6", _x, _freq,  "", _p, _x call TFAR_fnc_getSwVolume, "no"]);
		};		
	} forEach ((getItemCargo _x) select 0);	
		
	
	{		
		if  ((_x getVariable ["tf_lr_speakers", false]) and {[typeof (_x), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1}) then {
			_manpack = [_x, "radio_settings"];
			if (_manpack call TFAR_fnc_getLrSpeakers) then {
				_freq = format ["%1%2", _manpack call TFAR_fnc_getLrFrequency, _manpack call TFAR_fnc_getLrRadioCode];
				if ((_manpack call TFAR_fnc_getAdditionalLrChannel) > -1) then {
					_freq = _freq + format ["|%1%2", [_manpack, (_manpack call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _manpack call TFAR_fnc_getLrRadioCode];
				};
				_radio_id = netId (_manpack select 0);
				if (_radio_id == '') then {
					_radio_id = str (_manpack select 0);
				};

				tf_speakerRadios pushBack (format ["%1	%2	%3	%4	%5	%6", _radio_id, _freq,  "", _p, _manpack call TFAR_fnc_getLrVolume, "no"]);		
			};
		};
	
	} forEach (everyBackpack _x);		
	
} forEach (nearestObjects [getPos currentUnit, ["WeaponHolder", "GroundWeaponHolder"], TF_speakerDistance]);

{
	if ((_x getVariable ["tf_lr_speakers", false]) and {_x call TFAR_fnc_hasVehicleRadio}) then {
		_pos = getPosASL _x;
		_p = [(_pos select 0) - (_unit_pos select 0), (_pos select 1) - (_unit_pos select 1), (_pos select 2) - (_unit_pos select 2)];
		
		_lrs = [];
		if (isNull (gunner _x) && {count (_x getVariable ["gunner_radio_settings", []]) > 0}) then {
			_lrs pushBack [_x, "gunner_radio_settings"];
		};
		if (isNull (driver _x) && {count (_x getVariable ["driver_radio_settings", []]) > 0}) then {
			_lrs pushBack [_x, "driver_radio_settings"];
		};		
		if (isNull (commander _x) && {count (_x getVariable ["commander_radio_settings", []]) > 0}) then {
			_lrs pushBack [_x, "commander_radio_settings"];
		};
		if (isNull (_x turretUnit [0]) && {count (_x getVariable ["turretUnit_0_radio_setting", []]) > 0}) then {
			_lrs pushBack [_x, "turretUnit_0_radio_setting"];
		};
		
		{
			if (_x call TFAR_fnc_getLrSpeakers) then {
				_freq = format ["%1%2", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode];
				if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
					_freq = _freq + format ["|%1%2", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode];
				};
				_radio_id = netId (_x select 0);
				if (_radio_id == '') then {
					_radio_id = str (_x select 0);
				};
				_radio_id =  _radio_id + (_x select 1);
				_isolation = netid (_x select 0);
				if (_isolation == "") then {
					_isolation = "singleplayer";
				};
				_isolation = _isolation + "_" + str ([(typeof (_x select 0)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty);

				tf_speakerRadios pushBack (format ["%1	%2	%3	%4	%5	%6", _radio_id, _freq,  "", _p, _x call TFAR_fnc_getLrVolume, _isolation]);		
			};
		}		
		forEach (_lrs);

	};
} forEach  (currentUnit nearEntities [["LandVehicle", "Air"], TF_speakerDistance]);