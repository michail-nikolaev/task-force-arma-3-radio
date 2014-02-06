/**
 * TFAR_fnc_getSwRadioCode
 * Returns side of vehicle, based on model of vehicle, not on who is captured
 * Used for radio model
 * @param vehicle
 * @return side
 *
*/
private ["_result"];
_result = missionNamespace getVariable [getText(configFile >> "CfgWeapons" >> _this >> "tf_encryptionCode"), ""];

_result