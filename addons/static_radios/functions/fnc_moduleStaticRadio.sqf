#include "script_component.hpp"

/*
  Name: TFAR_static_radios_fnc_moduleStaticRadio

  Author: Dedmen
    Handles placing Static Radio for Zeus module

  Arguments:
    0: The control given by the EventHandler <CONTROL>

  Return Value:
    None

  Example:
    _this call TFAR_static_radios_fnc_moduleStaticRadio;

  Public: No
*/

params ["_control"];

private _display = ctrlParent _control;
private _logic = missionNamespace getVariable ["BIS_fnc_initCuratorAttributes_target",objNull];

private _unit = (attachedTo _logic);
private _classname =  ((getItemCargo _unit) select 0) select 0;

if !((_unit call TFAR_fnc_isLRRadio) || {(_classname call TFAR_fnc_isPrototypeRadio)} || {(_classname call TFAR_fnc_isRadio)}) exitWith {
    //This is not a radio
    hint localize LSTRING(moduleStaticRadio_hint);
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

    _FreqControl = _display displayCtrl 2611804;
    _ChannelControl = _display displayCtrl 2611806;
    _SpeakerControl = _display displayCtrl 2611808;
    _VolumeControl = _parent displayCtrl 2611810;

    _freq = ctrlText _FreqControl;
    _channel = ctrlText _ChannelControl;
    _speaker = cbChecked _SpeakerControl;
    _volume = sliderPosition _VolumeControl;

    ["TFAR_StaticRadioEvent", [_unit,_freq,_channel,_speaker, round _volume]] call CBA_fnc_serverEvent;

    deleteVehicle _logic;
};

_display displayAddEventHandler ["unload", _fnc_onUnload];
_control ctrlAddEventHandler ["buttonClick", _fnc_onConfirm];



//Check if radio is already instanciated
private _settings = [];
if (_classname call TFAR_fnc_isRadio && {_classname call TFAR_fnc_hasSettings}) then {
    _settings = _classname call TFAR_fnc_getSwSettings;
};

if (_classname call TFAR_fnc_isLRRadio && {[[_classname,"radio_settings"]] call TFAR_fnc_hasSettings}) then {
    _settings = [_classname,"radio_settings"] call TFAR_fnc_getLrSettings;
};

private _FreqControl = _display displayCtrl 2611804;
private _ChannelControl = _display displayCtrl 2611806;
private _SpeakerControl = _display displayCtrl 2611808;
private _VolumeControl = _display displayCtrl 2611810;
private _VolumeEditControl = _display displayCtrl 2611811;


//Edit volume control
_VolumeControl sliderSetRange [1, 50];

if !(_settings isEqualTo []) then {
    _VolumeControl sliderSetPosition (_settings param [VOLUME_OFFSET, TFAR_default_radioVolume]);
    _SpeakerControl cbSetChecked (_settings param [TFAR_SW_SPEAKER_OFFSET, false]);
} else {
    _VolumeControl sliderSetPosition TFAR_default_radioVolume;
};

_VolumeControl ctrlSetTooltip (localize LSTRING(moduleStaticRadio_ATT_RadioVolume_tooltip));
_VolumeControl ctrlAddEventHandler ["SliderPosChanged", {
    params ["_slider"];
    private _edit = (ctrlParent _slider) displayCtrl 2611811;
    private _value = sliderPosition _slider;
    _edit ctrlSetText ([_value, 1, 0] call CBA_fnc_formatNumber);
}];

private _value = sliderPosition _VolumeControl;
_VolumeEditControl ctrlSetText ([_value, 1, 0] call CBA_fnc_formatNumber);

_VolumeEditControl ctrlAddEventHandler ["KillFocus", {
    params ["_edit"];
    private _slider = (ctrlParent _edit) displayCtrl 2611810;
    private _value = ((parseNumber ctrlText _edit) min 50) max 1;
    _slider sliderSetPosition _value;
    _edit ctrlSetText str _value;
}];

private _frequencies = [];

//If radio is already instanciated, load frequencies from it.
if !(_settings isEqualTo []) then {
    _frequencies = _settings param [TFAR_FREQ_OFFSET, []];
};

if (_frequencies isEqualTo []) then {
    _frequencies = _classname call TFAR_static_radios_fnc_generateFrequencies;
};

_FreqControl ctrlSetText str _frequencies;

private _currentChannel = if !(_settings isEqualTo []) then {
                            _settings param [ACTIVE_CHANNEL_OFFSET, -1]+1; //We display channel+1 so that users think 1 is first channel
                        } else {1};

_ChannelControl ctrlSetText str _currentChannel;

/*
_listBox = _parent displayCtrl 20611802;

_backpackRadios = "(getNumber (_x >> 'tf_hasLRradio') == 1) && (((configName _x) select [0,4]) == 'TFAR')" configClasses (configFile >> "CfgVehicles");
_handheldRadios = "(getNumber (_x >> 'tf_prototype') == 1)  && (((configName _x) select [0,4]) == 'TFAR')" configClasses (configFile >> "CfgWeapons");

{
    _listBox lbAdd (configName _x);
    true
} count (_backpackRadios + _handheldRadios);

*/
