private ["_to_remove", "_allRadios", "_personalRadio", "_riflemanRadio", "_defaultRadio"];
_to_remove = [];
_allRadios = _this;

_personalRadio = nil;
_riflemanRadio = nil;

switch (player call BIS_fnc_objectSide) do {
	case west: {_personalRadio = TF_defaultWestPersonalRadio; _riflemanRadio = TF_defaultWestRiflemanRadio;};
	case east: {_personalRadio = TF_defaultEastPersonalRadio; _riflemanRadio = TF_defaultEastRiflemanRadio;};
	default {_personalRadio = TF_defaultGuerPersonalRadio; _riflemanRadio = TF_defaultGuerRiflemanRadio;};
};

if ((TF_give_personal_radio_to_regular_soldier) or {leader player == player}) then {
	_defaultRadio = _personalRadio;
} else {
	_defaultRadio = _riflemanRadio;
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
		_to_remove set [_forEachIndex, _defaultRadio];
	};
} forEach _to_remove;
_to_remove