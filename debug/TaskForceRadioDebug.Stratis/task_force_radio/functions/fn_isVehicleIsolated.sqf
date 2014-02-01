/**
 * Checks _this for sound isolation
 * @example _params = (vehicle player) call TFAR_fnc_isVehicleIsolated;
 * @param vehicle
 * @return _isolated = True|False
 */
private ["_isolated"];

// all vehs is full open by default, let's strict some below
_isolated = 0;

switch true do {
	// Heavy Armour
	case ( _this isKindOf "Tank" ): { _isolated = 1; }; // tanks are usually very armored

	// Cars
	case ( _this isKindOf "Wheeled_APC_F"): { _isolated = 0.6; }; // APC
	case ( _this isKindOf "MRAP_01_base_F" ): { _isolated = 0.51; }; // Hunter
	case ( _this isKindOf "MRAP_02_base_F" ): { _isolated = 0.51; }; // Ifrit
	case ( _this isKindOf "MRAP_03_base_F" ): { _isolated = 0.51; }; // Strider
	case ( _this isKindOf "I_MRAP_03_F" ): { _isolated = 0.51; }; // Strider Ind
	case ( _this isKindOf "Car"): { _isolated = 0.1; }; // almost open

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