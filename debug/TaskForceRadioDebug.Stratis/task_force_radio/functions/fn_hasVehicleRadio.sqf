/**
 * Checks _this for LW radio presence
 * @example _present = (vehicle player) call TFAR_fnc_hasVehicleRadio;
 * @param vehicle
 * @return True|False
 */
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
	"Truck_01_base_F", // Blufor HEMTT 
	"Truck_02_base_F", //Opfor Zamak
	"Wheeled_APC_F", // APC
	"Boat_Armed_01_base_F", // Armed Speedboat
	"C_Boat_Civil_01_police_F", //Motorboat (Police)
	"C_Boat_Civil_01_rescue_F", //Motorboat (Rescue)
	"SDV_01_base_F" //SDV
];

{ if ( _this isKindOf _x ) exitWith { _presence = true; }; } foreach _classes_with_radios;

_presence