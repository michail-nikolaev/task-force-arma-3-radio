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

private _isolated_and_inside = TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside;
private _depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
private _can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;

private _swRadios = TFAR_currentUnit call PROFCONTEXT_RTN(TFAR_fnc_radiosList); //Calling haveSWRadio and radiosList will iterate players inventory twice == bad performance. (reference to old code)

if (((count _swRadios > 0) or (TFAR_currentUnit != player)) and {[TFAR_currentUnit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio}) then {
    _freq = [];
    private _playerRadios = [];
    if (TFAR_currentUnit != player) then {
        _playerRadios = (player call TFAR_fnc_radiosList);
        _swRadios = _swRadios + _playerRadios;
    };
    {
        if ([_x] call TFAR_fnc_RadioOn) then {
            if (!(_x call TFAR_fnc_getSwSpeakers) //If speakers are enabled we will not have it on our headset at the same time... I think...
                or {(TFAR_currentUnit != player) and {_x in _playerRadios}} //When remote controlling a unit.. Still hear your original Radios
            ) then {
                private _radioCode = _x call TFAR_fnc_getSwRadioCode;
                private _volume = _x call TFAR_fnc_getSwVolume;
                _freq pushBack format ["%1%2|%3|%4|%5", _x call TFAR_fnc_getSwFrequency, _radioCode, _volume, _x call TFAR_fnc_getSwStereo, _x];
                private _additionalChannel = _x call TFAR_fnc_getAdditionalSwChannel;
                if (_additionalChannel > -1 && {_additionalChannel != (_x call TFAR_fnc_getSwChannel)}) then {
                    _freq pushBack format ["%1%2|%3|%4|%5", [_x, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency, _radioCode, _volume, _x call TFAR_fnc_getAdditionalSwStereo, _x];
                };
            };
        };
        true;
    } count (_swRadios);
};

private _lrRadios = TFAR_currentUnit call PROFCONTEXT_RTN(TFAR_fnc_lrRadiosList); //Calling haveLRRadio would call lrRadiosList anyway (reference to old code)

if (((count _lrRadios > 0) or (TFAR_currentUnit != player)) and {[TFAR_currentUnit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio}) then {
    _freq_lr = [];
    private _playerRadios = [];
    if (TFAR_currentUnit != player) then {
        _playerRadios = (player call TFAR_fnc_lrRadiosList);
        _lrRadios = _lrRadios + _playerRadios;
    };
    {
        if ([_x] call TFAR_fnc_RadioOn) then {
            if (!(_x call TFAR_fnc_getLrSpeakers)
                or {(TFAR_currentUnit != player) and {_x in _playerRadios}} //When remote controlling a unit.. Still hear your original Radios
            ) then {
                private _radioCode = _x call TFAR_fnc_getLrRadioCode;
                private _volume = _x call TFAR_fnc_getLrVolume;
                private _additionalChannel = _x call TFAR_fnc_getAdditionalLrChannel;
                _freq_lr pushBack format ["%1%2|%3|%4|%5", _x call TFAR_fnc_getLrFrequency, _radioCode, _volume, _x call TFAR_fnc_getLrStereo, typeof (_x select 0)];
                if (_additionalChannel > -1 && {_additionalChannel != (_x call TFAR_fnc_getLrChannel)}) then {
                    _freq_lr pushBack format ["%1%2|%3|%4|%5", [_x, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency, _radioCode, _volume, _x call TFAR_fnc_getAdditionalLrStereo, typeof (_x select 0)];
                };
            };
        };
        true;
    } count (_lrRadios);
};
private _alive = alive TFAR_currentUnit;

private _nickname = if (_alive) then {name player} else {profileName};

private _globalVolume = TFAR_currentUnit getVariable ["tf_globalVolume",1.0];//used API variable. Don't change

private _receivingDistanceMultiplicator = TFAR_currentUnit getVariable ["tf_receivingDistanceMultiplicator",1.0];
//Async call will always return "OK"
private _request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10~",//#TODO reorder
    str(_freq), str(_freq_lr),
    _alive,
    TF_speak_volume_meters min TF_max_voice_volume,
    _nickname, waves, TF_terrain_interception_coefficient, _globalVolume, _receivingDistanceMultiplicator, TF_speakerDistance];

"task_force_radio_pipe" callExtension _request;
