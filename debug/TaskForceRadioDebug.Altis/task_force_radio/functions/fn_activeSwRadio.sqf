private ["_result"];
_result = nil;
{	
	if (_x call TFAR_fnc_isRadio) exitWith {_result = _x};
	
} forEach (assignedItems player);
_result