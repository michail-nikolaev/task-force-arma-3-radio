private ["_result", "_to_remove", "_allRadios"];
_result = 0;
_to_remove = [];
_allRadios = _this;

{	
	if (("ItemRadio" == _x) or ((_x call TFAR_fnc_isRadio) and _allRadios)) then 
	{
		_to_remove set[_result, _x];
		_result = _result + 1;
	};
} forEach (assignedItems player);

{
	if (("ItemRadio" == _x) or ((_x call TFAR_fnc_isRadio) and _allRadios)) then 
	{
		_to_remove set[_result, _x];
		_result = _result + 1;
	};
} forEach (items player);
{
	player unassignItem _x;
	player removeItem _x;
} forEach _to_remove;
_result