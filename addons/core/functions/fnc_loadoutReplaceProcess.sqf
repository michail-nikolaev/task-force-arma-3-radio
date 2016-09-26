/*
 	Name: TFAR_fnc_loadoutReplaceProcess

 	Author(s):
		zgmrvn

 	Description:
 		iterates through player's loadouts and replaces actual radios with prototypes

	Parameters:
		Nothing

 	Returns:
		Nothing

 	Example:
		[] call TFAR_fnc_loadoutReplaceProcess;
*/

private _loadouts = profileNamespace getVariable ["bis_fnc_saveinventory_data", []];

// _loadouts is an associative array [loadoutName, loadoutContent, loadoutName, ...], so we have to skip the name in our loop
for [{private _i = (count _loadouts) - 1}, {_i > 0}, {_i = _i - 2}] do {
	_inventory = _loadouts select _i;

	// iterate through each container
	{
		_content = _x;

		// iterate through each item of the container
		{
			_class = ConfigFile >> "CfgWeapons" >> _x;

			// if the item is actual radio, not a radio prototype
			if ((isClass _class) && (isNumber (_class >> "tf_radio"))) then {
				// find his parent prototype
				_parent = ([_class, true] call BIS_fnc_returnParents) select 1;

				// then erease the content value with it
				_content set [_forEachIndex, _parent];
			};
		} forEach _content;
	} forEach [
		(_inventory select 0) select 1, // uniform content
		(_inventory select 1) select 1,	// vest content
		(_inventory select 2) select 1,	// backpack content
		_inventory select 9				// assigned items
	];
};