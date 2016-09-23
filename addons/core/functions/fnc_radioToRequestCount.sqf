/*
 	Name: TFAR_fnc_radioToRequestCount
 	
 	Author(s):
		NKey
		L-H

 	Description:
		Searches through all the items assigned to and on the player and checks if it is a prototype radio
		and then creates an array of all the classnames of the prototype radios and returns it.
	
	Parameters:
		BOOLEAN - Regardless of whether the radio is prototype or not, return it as a radio to be replaced.
 	
 	Returns:
		ARRAY - List of all radio classes to be replaced.
 	
 	Example:
		_radios = false call TFAR_fnc_radioToRequestCount;
*/
private ["_to_remove", "_allRadios", "_personalRadio", "_riflemanRadio", "_defaultRadio", "_classes"];
waitUntil {sleep 0.1;!(isNull TFAR_currentUnit)};

_to_remove = [];
_allRadios = _this;

_personalRadio = nil;
_riflemanRadio = nil;

_classes = call TFAR_fnc_getDefaultRadioClasses;
_personalRadio = _classes select 1;
_riflemanRadio = _classes select 2;

if ((TF_give_personal_radio_to_regular_soldier) or {leader TFAR_currentUnit == TFAR_currentUnit} or {rankId TFAR_currentUnit >= 2}) then {
	_defaultRadio = _personalRadio;
} else {
	_defaultRadio = _riflemanRadio;
};

TF_settingsToCopy = [];
{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
		_to_remove pushBack _x;
        TF_first_radio_request = true;
    } else {
		if (_x call TFAR_fnc_isRadio) then {
			if ((_x call TFAR_fnc_getRadioOwner) == "") then {
				[_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
			};
			if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
				_to_remove pushBack _x;
				TF_settingsToCopy set [0, _x];
				TF_first_radio_request = true;
			};
		};
	};	
	true;
} count (assignedItems TFAR_currentUnit);
{
    if (_x call TFAR_fnc_isPrototypeRadio) then {
        _to_remove pushBack _x;
    } else {		
		if (_x call TFAR_fnc_isRadio) then {
			if ((_x call TFAR_fnc_getRadioOwner) == "") then {
				[_x, getPlayerUID player] call TFAR_fnc_setRadioOwner;
			};
			if (((_x call TFAR_fnc_getRadioOwner) != (getPlayerUID player)) or _allRadios) then {
				_to_remove pushBack _x;
				TF_settingsToCopy pushBack _x;
			};
		};
	};
	true;
} count (items TFAR_currentUnit);

{
	TFAR_currentUnit unassignItem _x;
	TFAR_currentUnit removeItem _x;
	if (_x == "ItemRadio") then {
		_to_remove set [_forEachIndex, _defaultRadio];
	};
} forEach _to_remove;
_to_remove