#include "script_component.hpp"

/*
  Name: TFAR_fnc_processTangent

  Author: NKey, Garth de Wet (L-H)
    Called when tangent is released.

  Arguments:
    0: Hint text <STRING>
    1: Request string <STRING>
    2: Hint display time - 0 won't show a hint <STRING> (Optional)

  Return Value:
    None

  Example:
    _hintText = format[localize LSTRING(transmit_end),format ["%1<img size='1.5' image='%2'/>",[_radio select 0, "displayName"] call TFAR_fnc_getLrRadioProperty,
        getText(configFile >> "CfgVehicles" >> typeof (_radio select 0) >> "picture")],(_radio call TFAR_fnc_getLrChannel) + 1, call TFAR_fnc_currentLRFrequency];
    _request = format["TANGENT_LR	RELEASED	%1%2	%3	%4", call TFAR_fnc_currentLRFrequency, (call TFAR_fnc_activeLrRadio) call TFAR_fnc_getLrRadioCode,
        ([_radio select 0, "tf_range"]call TFAR_fnc_getLrRadioProperty) * (call TFAR_fnc_getTransmittingDistanceMultiplicator), [_radio select 0, "tf_subtype"] call TFAR_fnc_getLrRadioProperty];
    [_hintText, _request] call TFAR_fnc_processTangent;

  Public: Yes
 */
params ["_hintText","_request",["_timer",2.5]];
//private _timer = 2.5;

//if ((count _this) == 3) then{
//    _timer = _this select 2;
//};
if (_hintText != "") then {
    [parseText _hintText, _timer] call TFAR_fnc_showHint;
};
if (isMultiplayer) then {
    "task_force_radio_pipe" callExtension _request + "~";//Async call will always return "OK"
};
