private ["_result"];
_result = [];
{	
	if (_x call TFAR_fnc_isRadio) then 
	{
		_result set[count _result, _x];
	};
} forEach (assignedItems player);

{
	if (_x call TFAR_fnc_isRadio) then 
	{
		_result set[count _result, _x];
	};
} forEach (items player);
_result