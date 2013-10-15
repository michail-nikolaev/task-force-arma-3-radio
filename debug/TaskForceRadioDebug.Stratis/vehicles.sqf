/**
 * Checks _this for sound isolation
 * @example _params = (vehicle player) call tfr_isVehicleIsolated;
 * @param vehicle
 * @return _isolated = True|False
 */
tfr_isVehicleIsolated = {
	private ["_isolated"];

	// all vehs is full open by default, let's strict some below
	_isolated = 0;

	switch true do {
		// Heavy Armour
		case ( _this isKindOf "Tank" ): { _isolated = 1; }; // tanks are usually very armored

		// Cars
		case ( _this isKindOf "Wheeled_APC"): { _isolated = 0.6; }; // armored light 
		case ( _this isKindOf "MRAP_01_base_F" ): { _isolated = 0.51; }; // Hunter
		case ( _this isKindOf "O_MRAP_02_F" ): { _isolated = 0.51; }; // Ifrit
		case ( _this isKindOf "MRAP_03_base_F" ): { _isolated = 0.51; }; // Strider
		case ( _this isKindOf "I_MRAP_03_F" ): { _isolated = 0.51; }; // Strider Ind
		case ( _this isKindOf "Car"): { _isolated = 0.1; } // almost open

		// Air
		case ( _this isKindOf "Heli_Light_02_base_F" ): { _isolated = 0.7 }; // Orca
		case ( _this isKindOf "Heli_Attack_02_base_F" ): { _isolated = 0.7 }; // Mi-48
		case ( _this isKindOf "Heli_Attack_01_base_F" ): { _isolated = 0.7 }; // AH-99
		case ( _this isKindOf "Heli_Transport_01_base_F" ): { _isolated = 0.3 }; // UH-80 opened by gun pods
		case ( _this isKindOf "Heli_Transport_02_base_F" ): { _isolated = 0.8 }; // CH-49 Mohawk

		// planes TBD - open for now
		case ( _this isKindOf "Parachute" ): { _isolated = 0; }; // to exclude from below
		case ( _this isKindOf "Air"): { _isolated = 0.1; }; // armored light
	};

	_isolated > 0.5
};

/**
 * Checks _this for LW radio presence
 * @example _present = (vehicle player) call tfr_hasVehicleRadio;
 * @param vehicle
 * @return True|False
 */
tfr_hasVehicleRadio = {
	private ["_presence", "_classes_with_radios"];
	// presence of radio station
	_presence = false;

	_classes_with_radios = [ 
		"Tank", "Air", "Wheeled_APC", // Common classes
		"MRAP_01_base_F", //Hunter
		"MRAP_02_base_F", //Ifrit
		"O_MRAP_02_F", //Ifrit
		"MRAP_03_base_F", //Strider
		"I_MRAP_03_F", //Strider
		"Offroad_01_armed_base_F", //Armed jeep
		"B_Truck_01_mover_F", // Blufor HEMTT 
		"Truck_02_base_F", //Opfor Zamak
		"Boat_Armed_01_base_F", // Armed Speedboat
		"C_Boat_Civil_01_police_F", //Motorboat (Police)
		"C_Boat_Civil_01_rescue_F", //Motorboat (Rescue)
		"SDV_01_base_F", //SDV
	];

	{ if ( _this isKindOf _x ) exitWith { _presence = true; }; } foreach _classes_with_radios;

	_presence
};

/**
 * Returns side of vehicle, based on model of vehicle, not on who is captured
 * Used for radio model
 * @param vehicle
 * @return side
 */
tfr_getVehicleSide = {
	private[ "_west_models", "_east_models", "_res_models", "_side"  ];
	
	_west_models = [
		/// LAND
		"MRAP_01_base_F",
		"APC_Tracked_01_base_F",
		"MBT_01_base_F", // M2A1 Slammer, M4 Scorcher, M5 Sandstorm MLRS
		"APC_Wheeled_01_base_F", // AMV-7 Marshall

		/// AIR
		"Heli_Attack_01_base_F", // AH-99
		"Heli_Light_01_base_F", // MH-9, AH-9
		"Heli_Transport_01_base_F", // UH-80 Ghost Hawk

		/// SUB
		"B_SDV_01_F",
		"B_Boat_Armed_01_minigun_F",
	];

	_east_models = [
		/// LAND
		"MRAP_02_base_F",
		"APC_Tracked_02_base_F",
		"MBT_02_base_F", // T-100 Varsuk
		"APC_Wheeled_02_base_F", // Marid

		/// AIR
		"Heli_Attack_02_base_F", //Mi-48 Kajman
		"Heli_Light_02_base_F", // Orca
		"Heli_Transport_02_base_F", //CH-49 Mohawk

		// SHIP
		"O_SDV_01_F",
		"O_Boat_Armed_01_hmg_F",
	];

	_res_models = [
		/// LAND
		"MRAP_03_base_F", // strider
		"APC_Wheeled_03_base_F", // AFV-4 Gorgon

		/// AIR
		"Plane_Fighter_03_base_F", // A-143 Buzzard

		/// SHIP
		"I_SDV_01_F",
		"I_Boat_Armed_01_minigun_F",
	];

	_side = civilian; //by default

	{ if ( _this isKindOf _x ) exitWith { _side = west; }; } foreach west_models;
	{ if ( _this isKindOf _x ) exitWith { _side = east; }; } foreach east_models;
	{ if ( _this isKindOf _x ) exitWith { _side = resistance; }; } foreach res_models;
	
	_side
};
