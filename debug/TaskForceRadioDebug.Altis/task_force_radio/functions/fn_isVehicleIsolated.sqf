/**
 * Checks _this for sound isolation
 * @example _params = (vehicle player) call TFAR_fnc_isVehicleIsolated;
 * @param vehicle
 * @return _isolated = True|False
 */
private ["_isolated"];

_isolated = [(typeof _this), "tf_isolatedAmount"] call TFAR_fnc_getConfigProperty;

_isolated > 0.5