private ["_result", "_to_remove", "_allRadios", "_personalRadio"];
_result = 0;
_to_remove = [];
_allRadios = _this;

_personalRadio = nil;

if ((player call BIS_fnc_objectSide) == west) then {
	_personalRadio = TF_defaultWestPersonalRadio;
} else {
	if ((player call BIS_fnc_objectSide) == east) then {
		_personalRadio = TF_defaultEastPersonalRadio;
	} else {
		_personalRadio = TF_defaultGuerPersonalRadio;
	};
};

{
	if ((_x call TFAR_fnc_isPrototypeRadio) or ((_x call TFAR_fnc_isRadio) and _allRadios)) then 
	{
		_to_remove set[_result, _x];
		_result = _result + 1;
		TF_first_radio_request = true;
	};
} forEach (assignedItems player);

{
	if ((_x call TFAR_fnc_isPrototypeRadio) or ((_x call TFAR_fnc_isRadio) and _allRadios)) then 
	{
		_to_remove set[_result, _x];
		_result = _result + 1;
	};
} forEach (items player);
{
	player unassignItem _x;
	player removeItem _x;
	if (_x == "ItemRadio") then
	{
		_to_remove set [_forEachIndex, _personalRadio];
	};
} forEach _to_remove;
_to_remove