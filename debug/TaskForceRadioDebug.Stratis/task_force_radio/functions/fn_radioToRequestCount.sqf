private ["_to_remove", "_allRadios", "_personalRadio"];
_to_remove = [];
_allRadios = _this;

_personalRadio = nil;

switch (player call BIS_fnc_objectSide) do {
	case west: {_personalRadio = TF_defaultWestPersonalRadio};
	case east: {_personalRadio = TF_defaultEastPersonalRadio};
	default {_personalRadio = TF_defaultGuerPersonalRadio};
};

{
	if ((_x call TFAR_fnc_isPrototypeRadio) or ((_x call TFAR_fnc_isRadio) and _allRadios)) then 
	{
		_to_remove set[(count _to_remove), _x];
		TF_first_radio_request = true;
	};
} forEach (assignedItems player);

{
	if ((_x call TFAR_fnc_isPrototypeRadio) or ((_x call TFAR_fnc_isRadio) and _allRadios)) then 
	{
		_to_remove set[(count _to_remove), _x];
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