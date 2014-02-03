/**
 * Checks _this for LW radio presence
 * @example _present = (vehicle player) call TFAR_fnc_hasVehicleRadio;
 * @param vehicle
 * @return True|False
 */
 if (_this getVariable ["tf_hasRadio", false]) exitWith {true};
(getNumber(configFile >> "CfgVehicles" >> (typeof _this) >> "tf_hasLRradio") == 1)