#include "script_component.hpp"

private _menu = [];
if (count (TFAR_currentUnit call TFAR_fnc_lrRadiosList) > 1) then {
    private _menuDef = ["main", localize LSTRING(select_lr_radio), "buttonList", "", false];
    private _positions = [];
    private _pos = 0;

    {
        _command = format["TF_lr_dialog_radio = (TFAR_currentUnit call TFAR_fnc_lrRadiosList) select %1;[{call TFAR_fnc_onLrDialogOpen;}, [], 0.2] call CBA_fnc_waitAndExecute;", _pos];
        _submenu = "";
        _active_radio = call TFAR_fnc_activeLrRadio;
        if (((_x select 0) != (_active_radio select 0)) or ((_x select 1) != (_active_radio select 1))) then {
            _command = format["TF_lr_dialog_radio = (TFAR_currentUnit call TFAR_fnc_lrRadiosList) select %1;", _pos];
            _submenu = "_this call TFAR_fnc_lrRadioSubMenu";
        };
        _position = [
            getText(configFile >> "CfgVehicles"  >> typeOf(_x select 0) >> "displayName"),
            _command,
            getText(configFile >> "CfgVehicles"  >> typeOf(_x select 0) >> "picture"),
            "",
            _submenu,
            -1,
            true,
            true
        ];
        _positions pushBack _position;
        _pos = _pos + 1;
        true;
    } count (TFAR_currentUnit call TFAR_fnc_lrRadiosList);

    _menu = [
        _menuDef,
        _positions
    ];
} else {
    if (call TFAR_fnc_haveLRRadio) then {
        TF_lr_dialog_radio = call TFAR_fnc_activeLrRadio;
        call TFAR_fnc_onLrDialogOpen;
    };
};
_menu
