// client side mission script to debug some stuff


//addMissionEventHandler ["Draw3D", {
onEachFrame {
	private[ "_vehpos", "_endpount", "_parents", "_label"  ];
	{
		_vehpos = getPos _x;
		_endpount = [_vehpos select 0, _vehpos select 1, (_vehpos select 2) + 3];
		//diag_log format["%1 %2", _vehpos, _endpount];
		_parents = [ (configFile >> "CfgVehicles" >> typeof _x), true ] call BIS_fnc_returnParents;

		_label = "";

		for "_i" from (count _parents - 1)  to 0 step -1 do {
			_label = _label + format["%1/", _parents select _i ];
		};

		drawLine3D [ _vehpos, _endpount, [1,1,1,.45] ];
		drawIcon3D [ 
			getText (configFile >> "CfgVehicles" >> typeof _x >> "picture"),
			[0, 1, 0, .85], _endpount, 1, 1, 0, _label, 1, 0.05, "PuristaMedium"
		];
	} foreach ((position player) nearEntities [ "All", 5 ]);
};
//} ];
