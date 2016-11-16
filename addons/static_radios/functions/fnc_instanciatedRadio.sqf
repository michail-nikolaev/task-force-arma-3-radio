#include "script_component.hpp"

/*
    Name: TFAR_static_radios_fnc_instanciatedRadio

    Author(s):
        Dedmen

    Description:
        Instanciates Radio if it isn't already.
        Internal use only!

    Parameters:
        OBJECT - The weaponholder containing the Radio

    Returns:
        STRING - classname of instanciate Radio

    Example:
        _this call TFAR_static_radios_fnc_instanciatedRadio;
*/
params ["_radioContainer"];

_radioClass = (((getItemCargo _radioContainer) select 0) select 0);
if (_radioContainer call TFAR_fnc_isLRRadio) exitWith {_radioContainer};
if !(_radioClass call TFAR_fnc_isPrototypeRadio) exitWith {_radioClass};

_radioInstanciated = ([_radioClass] call TFAR_fnc_instanciateRadios select 0);
diag_log ["TFAR_static_radios_fnc_instanciatedRadio",_this,_radioClass,_radioInstanciated];
if (_radioInstanciated != _radioClass) then {
    _radioContainer addWeaponCargoGlobal ["arifle_MX_F", 1];
    clearItemCargoGlobal _radioContainer;
    _radioContainer addItemCargoGlobal [_radioInstanciated, 1];
    clearWeaponCargoGlobal _radioContainer;
};
_radioInstanciated
