#include "script_component.hpp"

/*
    Name: TFAR_static_radios_fnc_moduleStaticRadio

    Author(s):
        Dedmen

    Description:
        Handles placing Static Radio for Zeus module
        Internal use only!

    Parameters:
        Control - #TODO

    Returns:
        NOTHING

    Example:
        _this call TFAR_static_radios_fnc_moduleStaticRadio;
*/


params ["_control"];
private _display = ctrlParent _control;
private _logic = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target",objNull];

private _unit = (attachedTo _logic);
_classname =  ((getItemCargo _unit) select 0) select 0;

if !((_unit call TFAR_fnc_isLRRadio) || {(_classname call TFAR_fnc_isPrototypeRadio)} || {(_classname call TFAR_fnc_isRadio)}) exitWith {
    hint "This has to be used on a Radio";
    _display closeDisplay 0;
    deleteVehicle _logic;
};

private _fnc_onUnload = {
    private _logic = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target",objNull];
    if (isNull _logic) exitWith {};

    if (_this select 1 == 2) then {
        deleteVehicle _logic;
    };
};

private _fnc_onConfirm = {
    params [["_ctrlButtonOK", controlNull, [controlNull]]];
    //_ctrlButtonOK ctrlRemoveAllEventHandlers "buttonClick"; //This crashes Arma! https://feedback.bistudio.com/T121356
    private _display = ctrlparent _ctrlButtonOK;
    if (isNull _display) exitWith {};

    private _logic = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target",objNull];
    if (isNull _logic) exitWith {};
    private _unit = (attachedTo _logic);

    _FreqControl = _display displayCtrl 20611804;
    _ChannelControl = _display displayCtrl 20611806;
    _SpeakerControl = _display displayCtrl 20611808;

    _freq = ctrlText _FreqControl;
    _channel = ctrlText _ChannelControl;
    _speaker = cbChecked _SpeakerControl;

    ["TFAR_StaticRadioEvent", [_unit,_freq,_channel,_speaker]] call CBA_fnc_serverEvent;

    deleteVehicle _logic;
};

_display displayAddEventHandler ["unload", _fnc_onUnload];
_control ctrlAddEventHandler ["buttonClick", _fnc_onConfirm];


_parent = (ctrlParent _control);

_randomFrequencies = _classname call TFAR_static_radios_fnc_generateFrequencies;

_FreqControl = _parent displayCtrl 20611804;
_ChannelControl = _parent displayCtrl 20611806;
_SpeakerControl = _parent displayCtrl 20611808;

_FreqControl ctrlSetText (str _randomFrequencies);
_ChannelControl ctrlSetText "1";

/*
_listBox = _parent displayCtrl 20611802;

_backpackRadios = "(getNumber (_x >> 'tf_hasLRradio') == 1) && (((configName _x) select [0,4]) == 'TFAR')" configClasses (configFile >> "CfgVehicles");
_handheldRadios = "(getNumber (_x >> 'tf_prototype') == 1)  && (((configName _x) select [0,4]) == 'TFAR')" configClasses (configFile >> "CfgWeapons");

{
    _listBox lbAdd (configName _x);
    true
} count (_backpackRadios + _handheldRadios);

*/
