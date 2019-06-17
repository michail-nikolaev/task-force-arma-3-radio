#include "script_component.hpp"

/*
  Name: TFAR_fnc_CopySettings

  Author: Garth de Wet (L-H)
    Copies the settings from a radio to another.

  Arguments:
    0: Source Radio (SR/LR) <ARRAY|STRING>
    1: Destination Radio (SR/LR) <ARRAY|STRING>

  Return Value:
    None

  Example:
    // LR - LR
    [(call TFAR_fnc_activeLrRadio),[(vehicle player), "driver"]] call TFAR_fnc_copySettings;
    // SW - SW
    [(call TFAR_fnc_activeSwRadio),"TFAR_anprc148jem_20"] call TFAR_fnc_copySettings

  Public: Yes
*/

params ["_source", "_destination"];

//LR radios are Arrays. SW are not
private _isDLR = (_destination isEqualType []);
private _isSLR = (_source isEqualType []);

if (_isSLR) then {
    private _settings = _source call TFAR_fnc_GetLRSettings;
    if (_isDLR) then {
        [_destination,[]+_settings] call TFAR_fnc_SetLRSettings;
    } else {
        diag_log localize LSTRING(copySetting_LR_SW_Warning);
        hint localize LSTRING(copySetting_LR_SW_Warning);
    };
} else {
    private _settings = _source call TFAR_fnc_GetSwSettings;
    if (!_isDLR) then {
        _settings = []+_settings;
        _support_additional = [_destination, "tf_additional_channel", 0] call DFUNC(getWeaponConfigProperty);
        if ((isNil "_support_additional") or {_support_additional == 0}) then {
            _settings set [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1];
        };
        [_destination, _settings] call TFAR_fnc_SetSwSettings;
    } else {
        diag_log localize LSTRING(copySetting_SW_LR_Warning);
        hint localize LSTRING(copySetting_SW_LR_Warning);
    };
};
