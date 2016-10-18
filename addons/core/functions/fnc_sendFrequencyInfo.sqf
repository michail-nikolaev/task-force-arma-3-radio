#include "script_component.hpp"

/*
    Name: TFAR_fnc_sendFrequencyInfo

    Author(s):
        NKey

    Description:
        Notifies the plugin about the radios currently being used by the player and various settings active on the radio.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_sendFrequencyInfo;
*/

// send frequencies
private _freq = ["No_SW_Radio"];
private _freq_lr = ["No_LR_Radio"];
private _freq_dd = "No_DD_Radio";

private _isolated_and_inside = TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside;
private _depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
private _can_speak = [_isolated_and_inside, _depth] call TFAR_fnc_canSpeak;

if (((call TFAR_fnc_haveSWRadio) or (TFAR_currentUnit != player)) and {[TFAR_currentUnit, _isolated_and_inside, _can_speak, _depth] call TFAR_fnc_canUseSWRadio}) then {
    _freq = [];
    private _radios = TFAR_currentUnit call TFAR_fnc_radiosList;
    if (TFAR_currentUnit != player) then {
        _radios = _radios + (player call TFAR_fnc_radiosList);
    };
    {
        if ([_x] call TFAR_fnc_RadioOn)then{
            if (!(_x call TFAR_fnc_getSwSpeakers) or {(TFAR_currentUnit != player) and (_x in (player call TFAR_fnc_radiosList))}) then {
                if ((_x call TFAR_fnc_getAdditionalSwChannel) == (_x call TFAR_fnc_getSwChannel)) then {
                    _freq pushBack format ["%1%2|%3|%4|%5", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getAdditionalSwStereo,typeOf _x];
                } else {
                    _freq pushBack format ["%1%2|%3|%4|%5", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getSwStereo,typeOf _x];
                    if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
                        _freq pushBack format ["%1%2|%3|%4|%5", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode, _x call TFAR_fnc_getSwVolume, _x call TFAR_fnc_getAdditionalSwStereo,typeOf _x];
                    };
                };
            };
        };
        true;
    } count (_radios);
};
if (((call TFAR_fnc_haveLRRadio) or (TFAR_currentUnit != player)) and {[TFAR_currentUnit, _isolated_and_inside, _depth] call TFAR_fnc_canUseLRRadio}) then {
    _freq_lr = [];
    private _radios = TFAR_currentUnit call TFAR_fnc_lrRadiosList;
    if (TFAR_currentUnit != player) then {
        _radios = _radios + (player call TFAR_fnc_lrRadiosList);
    };
    {
        if ([_x] call TFAR_fnc_RadioOn) then {
            if (!(_x call TFAR_fnc_getLrSpeakers) or {(TFAR_currentUnit != player) and (_x in (player call TFAR_fnc_lrRadiosList))}) then {
                if ((_x call TFAR_fnc_getAdditionalLrChannel) == (_x call TFAR_fnc_getLrChannel)) then {
                    _freq_lr pushBack format ["%1%2|%3|%4|%5", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getAdditionalLrStereo,typeOf _x];
                } else {
                    _freq_lr pushBack format ["%1%2|%3|%4|%5", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getLrStereo,typeOf _x];
                    if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
                        _freq_lr pushBack format ["%1%2|%3|%4|%5", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode, _x call TFAR_fnc_getLrVolume, _x call TFAR_fnc_getAdditionalLrStereo,typeOf _x];
                    };
                };
            };
        };
        true;
    } count (_radios);
};
if ((call TFAR_fnc_haveDDRadio) and {[_depth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio}) then {
    _freq_dd = TF_dd_frequency;
};
private _alive = alive TFAR_currentUnit;
if (_alive) then {
    TFAR_player_name = name player;
};

private _nickname = TFAR_player_name;
private _globalVolume = TFAR_currentUnit getVariable ["tf_globalVolume",1.0];
private _voiceVolume = TFAR_currentUnit getVariable ["tf_voiceVolume",1.0];
private _spectator = TFAR_currentUnit getVariable ["tf_forceSpectator",false];
if (_spectator) then {
    _alive = false;
};
private _receivingDistanceMultiplicator = TFAR_currentUnit getVariable ["tf_receivingDistanceMultiplicator",1.0];
//Async call will always return "OK"
private _request = format["FREQ	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13~", str(_freq), str(_freq_lr), _freq_dd, _alive, TF_speak_volume_meters min TF_max_voice_volume, TF_dd_volume_level, _nickname, waves, TF_terrain_interception_coefficient, _globalVolume, _voiceVolume, _receivingDistanceMultiplicator, TF_speakerDistance];
_result = "task_force_radio_pipe" callExtension _request;
