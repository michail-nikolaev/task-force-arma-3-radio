/**
 * Checks _this for LW radio presence
 * @example _present = (vehicle player) call TFAR_fnc_hasVehicleRadio;
 * @param vehicle
 * @return True|False
 */
private "_result";
_result = _this getVariable "tf_hasRadio";
if (isNil "_result") then
{
	_result = ([(typeof _this), "tf_hasLRradio"] call TFAR_fnc_getConfigProperty == 1);
};
_result