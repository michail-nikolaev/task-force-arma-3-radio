#include "script_component.hpp"

/*
    Name: TFAR_fnc_sendSpeakerRadios

    Author(s):
        Dedmen

    Description:
        Send infos about SpeakerRadios to Teamspeak Plugin

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_sendSpeakerRadios;
*/


//If there is no one near the player this would execute every 2 frames.. which is total overkill
private _lastExec = TFAR_ConfigCacheNamespace getVariable "TFAR_fnc_sendSpeakerRadioslastExec"; //Magic feat commy2
if ((diag_tickTime - _lastExec) < 0.5) exitWith {}; //Don't run if we already ran less than 500ms ago
TFAR_ConfigCacheNamespace setVariable ["TFAR_fnc_sendSpeakerRadioslastExec",diag_tickTime];

//TFAR_speakerRadios are radios carried by people that are on speaker
private _speakerRadios = TFAR_speakerRadios;

//Get radios on ground
{
    private _pos = getPosASL _x;
    private _waveZ = _pos select 2;
    if (_waveZ > 0) then {
        {
            if ((_x call TFAR_fnc_isRadio) and {_x call TFAR_fnc_getSwSpeakers}) then {
                private _radioCode = _x call TFAR_fnc_getSwRadioCode;
                private _frequencies = [format ["%1%2", _x call TFAR_fnc_getSwFrequency, _radioCode]];
                private _additionalChannel = _x call TFAR_fnc_getAdditionalSwChannel;
                if (_additionalChannel > -1) then {
                    _frequencies pushBack format ["%1%2", [_x, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency, _radioCode];
                };

                _speakerRadios pushBack ([_x/*radio_id*/,_frequencies joinString "|",""/*nickname*/,_pos,_x call TFAR_fnc_getSwVolume, "no"/*vehicle*/] joinString TF_new_line);
            };
            true;
        } count ((getItemCargo _x) select 0);

        {
            if  ((_x getVariable ["TFAR_LRSpeakersEnabled", false]) and {[typeof (_x), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1}) then {
                private _manpack = [_x, "radio_settings"];
                if (_manpack call TFAR_fnc_getLrSpeakers) then {
                    private _radioCode = _manpack call TFAR_fnc_getLrRadioCode;
                    private _frequencies = [format ["%1%2", _manpack call TFAR_fnc_getLrFrequency, _radioCode]];
                    private _additionalChannel = _manpack call TFAR_fnc_getAdditionalLrChannel;
                    if (_additionalChannel > -1) then {
                        _frequencies pushBack format ["%1%2", [_manpack, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency, _radioCode];
                    };
                    private _radio_id = netId _x;
                    _speakerRadios pushBack ([_radio_id,_frequencies joinString "|",""/*nickname*/,_pos,_manpack call TFAR_fnc_getLrVolume, "no"/*vehicle*/] joinString TF_new_line);
                };
            };
            true;
        } count (everyBackpack _x);
    };
    true;
} count (nearestObjects [getPos TFAR_currentUnit, ["WeaponHolder", "WeaponHolderSimulated"], TF_speakerDistance]);
//#TODO doesn't catch static LRRadio backpacks on ground because they are not in any Holder
//Are you sure? nearestObjects seems to return a container and backpacks returns radio backpacks.. Should verify that again It may not see them because of TFAR_LRSpeakersEnabled not set

//Get vehicle radios on speaker
{
    if ((_x getVariable ["TFAR_LRSpeakersEnabled", false]) and {_x call TFAR_fnc_hasVehicleRadio}) then {
        private _pos = getPosASL _x;
        if (_pos select 2 >= TF_UNDERWATER_RADIO_DEPTH) then {
            private _lrs = [];

            if (isNull (gunner _x) && {count (_x getVariable ["gunner_radio_settings", []]) > 0}) then {
                _lrs pushBack [_x, "gunner_radio_settings"];
            };
            if (isNull (driver _x) && {count (_x getVariable ["driver_radio_settings", []]) > 0}) then {
                _lrs pushBack [_x, "driver_radio_settings"];
            };
            if (isNull (commander _x) && {count (_x getVariable ["commander_radio_settings", []]) > 0}) then {
                _lrs pushBack [_x, "commander_radio_settings"];
            };
            if (isNull (_x call TFAR_fnc_getCopilot) && {count (_x getVariable ["turretUnit_0_radio_setting", []]) > 0}) then {
                _lrs pushBack [_x, "turretUnit_0_radio_setting"];
            };

            {
                if (_x call TFAR_fnc_getLrSpeakers) then {
                    private _radioCode = _x call TFAR_fnc_getLrRadioCode;
                    private _frequencies = [format ["%1%2", _x call TFAR_fnc_getLrFrequency, _radioCode]];
                    private _additionalChannel = _x call TFAR_fnc_getAdditionalLrChannel;
                    if (_additionalChannel > -1) then {
                        _frequencies pushBack format["%1%2", [_x, _additionalChannel + 1] call TFAR_fnc_getChannelFrequency, _radioCode];
                    };
                    private _radio_id = netId (_x select 0) + (_x select 1);
                    private _isolation = netid (_x select 0) + "_" + str ([(typeof (_x select 0)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty);

                    _speakerRadios pushBack ([_radio_id,_frequencies joinString "|","",_pos,_x call TFAR_fnc_getLrVolume, _isolation] joinString TF_new_line);
                };
                true;
            } count (_lrs);
        };

    };
    true;
} count (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_speakerDistance]);

private _empty = (count _speakerRadios == 0);
//If we didn't have speakers in last call and don't have any now. Skip calling Extension
if (!(missionnamespace getVariable ["TFAR_hadSpeakers",false]) && _empty) exitWith {};
TFAR_hadSpeakers = !_empty;

"task_force_radio_pipe" callExtension format["SPEAKERS	%1~",_speakerRadios joinString TF_vertical_tab];//Async call will always return "OK"
TFAR_speakerRadios = [];
