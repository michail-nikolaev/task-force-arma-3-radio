#include "script_component.hpp"

/*
    Name: TFAR_fnc_preparePositionCoordinates

    Author(s):
        NKey

    Description:
        Prepares the position coordinates of the passed unit.

    Parameters:
        0: OBJECT - unit
        1: BOOLEAN - Is near player
        3: STRING - Unit name

    Returns:
        String

    Example:

*/
params ["_unit", "_nearPlayer","_unitName"];

private _pos = call (_unit getVariable ["TF_fnc_position", TFAR_fnc_defaultPositionCoordinates]); //_this get's forwarded without specifying it - perf improvement

private _isolated_and_inside = false; //_isInVehicle && {_unit call TFAR_fnc_vehicleIsIsolatedAndInside};
private _vehicle = "no"; //if (_isInVehicle) then {_unit call TFAR_fnc_vehicleId} else {"no"};
if (!isNull (objectParent _unit)) then {//_isInVehicle
    _vehicle = _unit call TFAR_fnc_vehicleId;
    _isolated_and_inside = _unit call TFAR_fnc_vehicleIsIsolatedAndInside;
};

private _eyeDepth = _pos select 2;//Inlined version of TFAR_fnc_eyeDepth to save performance
private _can_speak = (_eyeDepth > 0 || _isolated_and_inside); //Inlined version of TFAR_fnc_canSpeak to save performance
private _isRemotePlayer = !(_unit isEqualTo TFAR_currentUnit);
private _useSw = true;
private _useLr = true;
private _useDd = 0;//Numbers are faster than true/false because https://feedback.bistudio.com/T123419
if (_eyeDepth < 0) then {
    _useSw = [_unit, _isolated_and_inside, _can_speak, _eyeDepth] call TFAR_fnc_canUseSWRadio;
    _useLr = [_unit, _isolated_and_inside, _eyeDepth] call TFAR_fnc_canUseLRRadio;
    _useDd = [_eyeDepth, _isolated_and_inside] call TFAR_fnc_canUseDDRadio;
};

private _object_interception = 0;
private _terrainInterception = 0;

if (_nearPlayer) then {
    if (TFAR_currentUnit distance _unit <= TF_speakerDistance) then {
        if (_unit getVariable ["TFAR_LRSpeakersEnabled", false] && _useLr) then {
            {
                if (_x call TFAR_fnc_getLrSpeakers) then {
                    private _radioCode = _x call TFAR_fnc_getLrRadioCode;
                    private _frequencies = [format ["%1%2", _x call TFAR_fnc_getLrFrequency, _radioCode]];
                    if ((_x call TFAR_fnc_getAdditionalLrChannel) > -1) then {
                        _frequencies pushBack format ["%1%2", [_x, (_x call TFAR_fnc_getAdditionalLrChannel) + 1] call TFAR_fnc_getChannelFrequency, _radioCode];
                    };
                    private _radio_id = netId (_x select 0);
                    TFAR_speakerRadios pushBack ([_radio_id,_frequencies joinString "|",_unitName,[], _x call TFAR_fnc_getLrVolume, _vehicle, (getPosASL _unit) select 2] joinString TF_new_line);
                };
                true;
            } count (_unit call TFAR_fnc_lrRadiosList);
        };

        if (_unit getVariable ["TFAR_SRSpeakersEnabled", false] && _useSw) then {
            {
                if (_x call TFAR_fnc_getSwSpeakers) then {
                    private _radioCode = _x call TFAR_fnc_getSwRadioCode;
                    private _frequencies = [format ["%1%2", _x call TFAR_fnc_getSwFrequency, _radioCode]];
                    if ((_x call TFAR_fnc_getAdditionalSwChannel) > -1) then {
                        _frequencies pushBack format ["%1%2", [_x, (_x call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_getChannelFrequency, _radioCode];
                    };
                    private _radio_id = _x;
                    TFAR_speakerRadios pushBack ([_radio_id,_frequencies joinString "|",_unitName,[], _x call TFAR_fnc_getSwVolume, _vehicle, (getPosASL _unit) select 2] joinString TF_new_line);
                };
                true;
            } count (_unit call TFAR_fnc_radiosList);
        };
    };

    if (TFAR_objectInterceptionEnabled && _isRemotePlayer) then {
        _object_interception = _unit call TFAR_fnc_objectInterception;
    };
} else {
    _terrainInterception = _unit call TFAR_fnc_calcTerrainInterception;
};

private _isSpectating = _unit getVariable ["TFAR_forceSpectator",false];
private _isEnemy = false;
if (_isRemotePlayer && {TFAR_currentUnit getVariable ["TFAR_forceSpectator",false]}) then { //If we are not spectating we are not interested if he is enemy
    _isEnemy = [playerSide, side _unit] call BIS_fnc_sideIsEnemy;
};

private _curViewDir = if (_isSpectating) then {(positionCameraToWorld [0,0,1]) vectorDiff (positionCameraToWorld [0,0,0])} else {getCameraViewDirection _unit};//Inlined version of TFAR_fnc_currentDirection

private _data = [
    //"POS",
    "POS	%1	%2	%3	%4	%5	%6	%7	%8	%9	%10	%11	%12	%13",
    _unitName,
    _pos, _curViewDir,//Position
    _can_speak, _useSw, _useLr, _useDd, _vehicle,
    _terrainInterception,
    _unit getVariable ["tf_voiceVolume", 1.0],//Externally used API variable. Don't change name
    _object_interception, //Interceptions
    _isSpectating, _isEnemy
    ];

(format _data) //format is actually faster. 0.128 vs 0.131

//(_data joinString "	")
