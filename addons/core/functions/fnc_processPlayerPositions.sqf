#include "script_component.hpp"

/*
    Name: TFAR_fnc_processPlayerPositions

    Author(s):
        NKey

    Description:
        Process some player positions on each call and sends it to the plugin.

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_processPlayerPositions;
*/
if (getClientStateNumber != 10) exitWith {"BI HAS CRAPPY WEIRD BUGS U KNOW! (Keeps PFH from firing after server disconnect)"};
//if (isNull (findDisplay 46)) exitWith {};
//if (isNull TFAR_currentUnit) exitWith {};
private _startTime = diag_tickTime;

//Process queued Near Players
if (!TFAR_currentNearPlayersProcessed) then {
    private _nearPlayersCount = count TFAR_currentNearPlayersProcessing;
    if (_nearPlayersCount == 0) exitWith {TFAR_currentNearPlayersProcessed = true};
    private _playersToProcess = _nearPlayersCount min 30;//Plugin POS info takes about 10 microseconds meaning 10 position updates block for 0.1 ms
    if (_playersToProcess == 0) exitWith {TFAR_currentNearPlayersProcessed = true};

    {
        params ["_unit"];
        private _controlled = _unit getVariable "TFAR_controlledUnit";
        private _unitName = name _unit;
        if (_unit getVariable ["TFAR_forceSpectator",false]) then {
            _unitName = _unit getVariable ["TFAR_spectatorName","any"];
        };
        if !(isNil "_controlled") then {
            [_controlled, true, _unitName] call PROFCONTEXT_NORTN(TFAR_fnc_sendPlayerInfo);
        } else {
            [_unit, true, _unitName] call PROFCONTEXT_NORTN(TFAR_fnc_sendPlayerInfo);
        };
    } forEach (TFAR_currentNearPlayersProcessing select [0,_playersToProcess]); //commy2

    //private _startIndex = _nearPlayersCount - _playersToProcess; //Is min 0
    //for "_y" from _startIndex to _nearPlayersCount-1 step 1 do {
    //    private _unit = (TFAR_currentNearPlayersProcessing select _y);
    //};

    //Remove processed Units from array
    TFAR_currentNearPlayersProcessing deleteRange [0,_playersToProcess];
    //We just processed the last players
    if ((_nearPlayersCount - _playersToProcess) == 0) exitWith {TFAR_currentNearPlayersProcessed = true};
};

//Don't process anymore if we already blocked too long (5 millisec)
if ((diag_tickTime - _startTime) > 0.005) exitWith {};

//Process queued Far players
if (!TFAR_currentFarPlayersProcessed) then {
    private _farPlayersCount = count TFAR_currentFarPlayersProcessing;
    if (_farPlayersCount == 0) exitWith {TFAR_lastFarPlayerProcessTime = diag_tickTime;TFAR_currentFarPlayersProcessed = true};
    private _playersToProcess = _farPlayersCount min 50;//Plugin POS info takes about 10 microseconds meaning 10 position updates block for 0.1 ms
    if (_playersToProcess == 0) exitWith {TFAR_lastFarPlayerProcessTime = diag_tickTime;TFAR_currentFarPlayersProcessed = true};

    {
        params ["_unit"];
        private _controlled = _unit getVariable ["TFAR_controlledUnit", objNull];
        private _unitName = name _unit;
        if (_unit getVariable ["TFAR_forceSpectator",false]) then {
            _unitName = _unit getVariable ["TFAR_spectatorName","any"];
        };
        if (isNull _controlled) then {
            [_unit, false, _unitName] call PROFCONTEXT_NORTN(TFAR_fnc_sendPlayerInfo);
        } else {
            [_controlled, false, _unitName] call PROFCONTEXT_NORTN(TFAR_fnc_sendPlayerInfo);
        };
    } forEach (TFAR_currentFarPlayersProcessing select [0,_playersToProcess]); //commy2

    //private _startIndex = _farPlayersCount - _playersToProcess; //Is min 0
    //for "_y" from _startIndex to _farPlayersCount-1 step 1 do {
    //    private _unit = (TFAR_currentFarPlayersProcessing select _y);
    //};

    //Remove processed Units from array
    TFAR_currentFarPlayersProcessing deleteRange [0,_playersToProcess];
    //We just processed the last players
    if ((_farPlayersCount - _playersToProcess) == 0) exitWith {TFAR_lastFarPlayerProcessTime = diag_tickTime;TFAR_currentFarPlayersProcessed = true};
};



//Rescan Players
private _needNearPlayerScan = ((diag_tickTime - TFAR_lastPlayerScanTime) > TFAR_PLAYER_RESCAN_TIME) && TFAR_currentNearPlayersProcessed;

if (_needNearPlayerScan) then {
    TFAR_currentNearPlayers = call TFAR_fnc_getNearPlayers;
    /*
    Want to process Curators on NearPlayers because even if they are not near,
    their controlled unit may be.
    */
    {
        TFAR_currentNearPlayers pushBackUnique _x;
        true;
    } count (call BIS_fnc_listCuratorPlayers);//Add curators


    private _other_units = allPlayers - TFAR_currentNearPlayers;

    TFAR_currentFarPlayers = [];
    {
        if (isPlayer _x) then {
            TFAR_currentFarPlayers pushBackUnique _x;
        };
        true;
    } count _other_units;
    TFAR_lastPlayerScanTime = diag_tickTime;
};

//Queue new updates to plugin if last one processed
if (TFAR_currentNearPlayersProcessed) then {
    call PROFCONTEXT_NORTN(TFAR_fnc_sendSpeakerRadios);//send Speaker radio infos to plugin Has to be here because it needs a variable from NearPlayer processing
    TFAR_currentNearPlayersProcessing = +TFAR_currentNearPlayers;//Copy array for processing
    TFAR_currentNearPlayersProcessed = false;
};

//Only process FarPlayers once a TFAR_FAR_PLAYER_UPDATE_TIME
if ((diag_tickTime - TFAR_lastFarPlayerProcessTime) < TFAR_FAR_PLAYER_UPDATE_TIME) exitWith {};

//Queue new updates to plugin if last one processed
if (TFAR_currentFarPlayersProcessed) then {
    call TFAR_fnc_pluginNextDataFrame;//Doing this here causes NearPlayers to only expire after TFAR_FAR_PLAYER_UPDATE_TIME
    TFAR_currentFarPlayersProcessing = +TFAR_currentFarPlayers;//Copy array for processing
    TFAR_currentFarPlayersProcessed = false;
};
