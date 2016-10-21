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

//TFAR_speakerRadios are radios carried by people that are on speaker
private _speakerRadios = TFAR_speakerRadios;
private _unitPos = eyepos TFAR_currentUnit;

//Get radios on ground
{
    private _pos = getPosASL _x;
    private _waveZ = _pos select 2;
    if (_waveZ > 0) then {
        private _relativePos = _pos vectorDiff _unitPos;
        {
            if ((_x call TFAR_fnc_isRadio) and {_x call TFAR_fnc_getSwSpeakers}) then {
                private _frequencies = [format ["%1%2", _x call TFAR_fnc_getSwFrequency, _x call TFAR_fnc_getSwRadioCode]];
                private _additionalChannel = _x call TFAR_fnc_getAdditionalSwChannel;
                if (_additionalChannel > -1) then {
                    _frequencies pushBack format ["%1%2", [_x, _additionalChannel + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getSwRadioCode];
                };

                _speakerRadios pushBack ([_x/*radio_id*/,_frequencies joinString "|",""/*nickname*/,_relativePos,_x call TFAR_fnc_getSwVolume, "no"/*vehicle*/, _waveZ] joinString TF_new_line);
            };
            true;
        } count ((getItemCargo _x) select 0);

        {
            if  ((_x getVariable ["TFAR_LRSpeakersEnabled", false]) and {[typeof (_x), "tf_hasLRradio", 0] call TFAR_fnc_getConfigProperty == 1}) then {
                private _manpack = [_x, "radio_settings"];
                if (_manpack call TFAR_fnc_getLrSpeakers) then {
                    private _frequencies = [format ["%1%2", _manpack call TFAR_fnc_getLrFrequency, _manpack call TFAR_fnc_getLrRadioCode]];
                    if ((_manpack call TFAR_fnc_getAdditionalLrChannel) > -1) then {
                        _frequencies pushBack format ["%1%2", [_manpack, (_manpack call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _manpack call TFAR_fnc_getLrRadioCode];
                    };
                    private _radio_id = netId (_manpack select 0);
                    if (_radio_id == '') then {
                        _radio_id = str (_manpack select 0);
                    };
                    _speakerRadios pushBack ([_radio_id,_frequencies joinString "|",""/*nickname*/,_relativePos,_manpack call TFAR_fnc_getLrVolume, "no"/*vehicle*/, _waveZ/*waveZ*/] joinString TF_new_line);
                };
            };
            true;
        } count (everyBackpack _x);
    };
    true;
} count (nearestObjects [getPos TFAR_currentUnit, ["WeaponHolder", "GroundWeaponHolder", "WeaponHolderSimulated"], TF_speakerDistance]);

//Get vehicle radios on speaker
{
    if ((_x getVariable ["TFAR_LRSpeakersEnabled", false]) and {_x call TFAR_fnc_hasVehicleRadio}) then {
        private _pos = getPosASL _x;
        if (_pos select 2 >= TF_UNDERWATER_RADIO_DEPTH) then {
            private _relativePos = _pos vectorDiff _unitPos;
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
                    private _frequencies = [format ["%1%2", _x call TFAR_fnc_getLrFrequency, _x call TFAR_fnc_getLrRadioCode]];
                    if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
                        _frequencies pushBack format ["|%1%2", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_GetChannelFrequency, _x call TFAR_fnc_getLrRadioCode];
                    };
                    private _radio_id = netId (_x select 0);
                    if (_radio_id == '') then {
                        _radio_id = str (_x select 0);
                    };
                    _radio_id =  _radio_id + (_x select 1);
                    private _isolation = netid (_x select 0);
                    if (_isolation == "") then {
                        _isolation = "singleplayer";
                    };
                    _isolation = _isolation + "_" + str ([(typeof (_x select 0)), "tf_isolatedAmount", 0.0] call TFAR_fnc_getConfigProperty);

                    _speakerRadios pushBack ([_radio_id,_frequencies,"",_relativePos,_x call TFAR_fnc_getLrVolume, _isolation, _pos select 2] joinString TF_new_line);
                };
                true;
            } count (_lrs);
        };

    };
    true;
} count (TFAR_currentUnit nearEntities [["LandVehicle", "Air", "Ship"], TF_speakerDistance]);

"task_force_radio_pipe" callExtension format["SPEAKERS	%1~",_speakerRadios joinString TF_vertical_tab];//Async call will always return "OK"
TFAR_speakerRadios = [];
