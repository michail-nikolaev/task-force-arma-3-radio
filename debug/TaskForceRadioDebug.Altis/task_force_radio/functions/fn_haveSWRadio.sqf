private ["_result"];
_result = false;
{	
	if (_x call TFAR_fnc_isRadio) exitWith {_result = true};
	
} forEach (assignedItems player);
_result