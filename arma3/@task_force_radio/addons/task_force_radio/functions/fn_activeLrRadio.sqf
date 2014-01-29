private ["_radios", "_found"];
_radios = call TFAR_fnc_lrRadiosList;
if (isNil "lr_active_radio") then {		
	if (count _radios > 0) then {
		lr_active_radio = _radios select 0;		
	};
} else {
	_found = false;
	{
		if (((_x select 0) == (lr_active_radio select 0)) and ((_x select 1) == (lr_active_radio select 1))) exitWith {_found = true};
	} forEach _radios;
	if !(_found) then {
		if (count _radios > 0) then {
			lr_active_radio = _radios select 0;		
		} else {
			lr_active_radio = nil;
		};
	}
};
lr_active_radio