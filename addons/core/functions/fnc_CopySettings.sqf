#include "script_component.hpp"

/*
    Name: TFAR_fnc_copySettings

    Author(s):
        L-H

    Description:
        Copies the settings from a radio to another.

    Parameters:
        0:ARRAY/STRING - Source Radio (SW/LR)
        1:ARRAY/STRING - Destination Radio (SW/LR)

    Returns:
        Nothing

    Example:
    // LR - LR
    [(call TFAR_fnc_activeLrRadio),[(vehicle player), "driver"]] call TFAR_fnc_copySettings;
    // SW - SW
    [(call TFAR_fnc_activeSwRadio),"TFAR_anprc148jem_20"] call TFAR_fnc_copySettings
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
        diag_log "TFAR - unable to copy from LR to SW";
        hint "TFAR - unable to copy from LR to SW";
    };
} else {
    private _settings = _source call TFAR_fnc_GetSwSettings;
    if (!_isDLR) then {
        _settings = []+_settings;
        _support_additional = [_destination, "tf_additional_channel", 0] call DFUNC(getConfigWeaponProperty);
        if ((isNil "_support_additional") or {_support_additional == 0}) then {
            _settings set [TFAR_ADDITIONAL_CHANNEL_OFFSET, -1];
        };
        [_destination, _settings] call TFAR_fnc_SetSwSettings;
    } else {
        diag_log "TFAR - unable to copy from SW to LR";
        hint "TFAR - unable to copy from SW to LR";
    };
};
