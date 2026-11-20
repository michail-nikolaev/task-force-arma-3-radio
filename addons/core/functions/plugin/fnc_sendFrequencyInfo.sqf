#include "script_component.hpp"

/*
  Name: TFAR_fnc_sendFrequencyInfo

  Author: NKey
    Notifies the plugin about the radios currently being used by the player and various settings active on the radio.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_sendFrequencyInfo;

  Public: Yes
*/

if (getClientStateNumber != 10) exitWith {"BI HAS CRAPPY WEIRD BUGS U KNOW! (Keeps PFH from firing after server disconnect)"};

private _timeSinceLastUpdate = diag_tickTime - (GVAR(VehicleConfigCacheNamespace) getVariable "lastRadioSettingUpdate");
private _lastExec = diag_tickTime - (GVAR(VehicleConfigCacheNamespace) getVariable "TFAR_fnc_sendFrequencyInfo_lastExec");

//Only call every 2 seconds if we had no update to our Radio settings for longer than 5 seconds.
if (_timeSinceLastUpdate > 5 && _lastExec < 2) exitWith {};

PROFCONTEXT_LOGTRAP(FreqInfoTrap,TFAR_fnc_sendFrequencyInfo);

GVAR(VehicleConfigCacheNamespace) setVariable ["TFAR_fnc_sendFrequencyInfo_lastExec",diag_tickTime];

// send frequencies
private _freq = ["No_SW_Radio"];
private _freq_lr = ["No_LR_Radio"];

private _appendFrequencies = {
    params ["_entries", "_radio", "_radioId"];
    {
        _x params ["_frequency", "_volume", "_stereo"];
        _entries pushBack format ["%1|%2|%3|%4", _frequency, _volume, _stereo, _radioId];
    } forEach (_radio call TFAR_fnc_getRadioChannelSettings);
};

private _isolated_and_inside = TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside;
private _depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
private _can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;
private _currentUnitIsRemote = TFAR_currentUnit != player;

private _swRadios = TFAR_currentUnit call TFAR_fnc_radiosList; //Calling haveSWRadio and radiosList will iterate players inventory twice == bad performance. (reference to old code)

//Radios in spectator are disabled because of bug in CBA/ACE that disables CBA keybinds in spectator, doesn't make sense to have radios if you can't configure

if (((count _swRadios > 0) || _currentUnitIsRemote) && {[TFAR_currentUnit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio} && {!(TFAR_currentUnit getVariable ["TFAR_forceSpectator", false])}) then {
    _freq = [];
    private _playerRadios = [];
    if (_currentUnitIsRemote) then {
        _playerRadios = player call TFAR_fnc_radiosList;
        _swRadios = _swRadios + _playerRadios;
    };
    {
        // While remote controlling, the player can still hear their own radios.
        if (_x in _playerRadios || {!(_x call TFAR_fnc_getSwSpeakers)}) then {
            [_freq, _x, _x] call _appendFrequencies;
        };
    } forEach _swRadios;
};

private _lrRadios = TFAR_currentUnit call TFAR_fnc_lrRadiosList; //Calling haveLRRadio would call lrRadiosList anyway (reference to old code)

if (((count _lrRadios > 0) || _currentUnitIsRemote) && {[TFAR_currentUnit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio} && {!(TFAR_currentUnit getVariable ["TFAR_forceSpectator", false])}) then {
    _freq_lr = [];
    // lrRadiosList already includes the player's radios during remote control.
    private _playerRadios = if (_currentUnitIsRemote) then {player call TFAR_fnc_lrRadiosList} else {[]};
    {
        if (_x in _playerRadios || {!(_x call TFAR_fnc_getLrSpeakers)}) then {
            [_freq_lr, _x, typeOf (_x select 0)] call _appendFrequencies;
        };
    } forEach _lrRadios;
};
private _alive = alive TFAR_currentUnit;

private _nickname = if (_alive) then {name player} else {profileName};

_nickname = (TFAR_currentUnit getVariable ["TFAR_unitName", _nickname]);

private _globalVolume = TFAR_currentUnit getVariable ["tf_globalVolume",1.0];//used API variable. Don't change

//smaller value == bigger range
private _receivingDistanceMultiplicator = (TFAR_currentUnit getVariable ["tf_receivingDistanceMultiplicator",1.0]) * (1/TFAR_globalRadioRangeCoef);

//Async call will always return "OK"
private _request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10~",//#TODO reorder
    _freq, _freq_lr,
    _alive,
    TF_speak_volume_meters min TF_max_voice_volume,
    _nickname, waves, TF_terrain_interception_coefficient, _globalVolume, _receivingDistanceMultiplicator, TF_speakerDistance];

"task_force_radio_pipe" callExtension _request;
