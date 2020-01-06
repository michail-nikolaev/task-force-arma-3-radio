#include "script_component.hpp"

/*
  Name: TFAR_fnc_processPlayerPositions

  Author: NKey
    Process some player positions on each call and sends it to the plugin.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_processPlayerPositions;

  Public: No
*/

if (getClientStateNumber != 10) exitWith {};

private _startTime = diag_tickTime;

//Process queued Near Players
if (!TFAR_currentNearPlayersProcessed) then {

    if (TFAR_currentNearPlayersProcessing isEqualTo []) exitWith {TFAR_currentNearPlayersProcessed = true};

    private _nearPlayersCount = count TFAR_currentNearPlayersProcessing;

    private _playersToProcess = _nearPlayersCount min 30; //Plugin POS info takes about 100 microseconds meaning 10 position updates block for 1 ms
    if (_playersToProcess == 0) exitWith {TFAR_currentNearPlayersProcessed = true};

    {
        private _controlled = _x getVariable ["TFAR_controlledUnit", objNull];
        private _unitName = _x getVariable ["TFAR_unitName", name _x];
        if (_x getVariable ["TFAR_forceSpectator", false]) then {
            _unitName = _x getVariable ["TFAR_spectatorName", _unitName];
        };
        if (isNull _controlled) then {
            [_x, true, _unitName] call TFAR_fnc_sendPlayerInfo;
        } else {
            [_controlled, true, _unitName] call TFAR_fnc_sendPlayerInfo;
        };
    } count (TFAR_currentNearPlayersProcessing select [0, _playersToProcess]); //commy2

    //Remove processed Units from array
    TFAR_currentNearPlayersProcessing deleteRange [0, _playersToProcess];
    //We just processed the last players
    if ((_nearPlayersCount - _playersToProcess) isEqualTo 0) exitWith {TFAR_currentNearPlayersProcessed = true};
};

//Don't process anymore if we already blocked too long (5 millisec)
if ((diag_tickTime - _startTime) > 0.005) exitWith {};

//Process queued Far players
if (!TFAR_currentFarPlayersProcessed) then {
    if (TFAR_currentFarPlayersProcessing isEqualTo []) exitWith {
        TFAR_lastFarPlayerProcessTime = diag_tickTime;
        TFAR_currentFarPlayersProcessed = true;
    };

    private _farPlayersCount = count TFAR_currentFarPlayersProcessing;
    private _playersToProcess = _farPlayersCount min 50; //Plugin POS info takes about 10 microseconds meaning 10 position updates block for 0.1 ms
    if (_playersToProcess isEqualTo 0) exitWith {
        TFAR_lastFarPlayerProcessTime = diag_tickTime;
        TFAR_currentFarPlayersProcessed = true;
    };

    {
        private _controlled = _x getVariable ["TFAR_controlledUnit", objNull];
        private _unitName = _x getVariable ["TFAR_unitName", name _x];
        if (_x getVariable ["TFAR_forceSpectator", false]) then {
            _unitName = _x getVariable ["TFAR_spectatorName", _unitName];
        };
        if (isNull _controlled) then {
            [_x, false, _unitName] call TFAR_fnc_sendPlayerInfo;
        } else {
            [_controlled, false, _unitName] call TFAR_fnc_sendPlayerInfo;
        };
    } count (TFAR_currentFarPlayersProcessing select [0, _playersToProcess]); //commy2

    //Remove processed Units from array
    TFAR_currentFarPlayersProcessing deleteRange [0, _playersToProcess];
    //We just processed the last players
    if ((_farPlayersCount - _playersToProcess) isEqualTo 0) exitWith {
        TFAR_lastFarPlayerProcessTime = diag_tickTime;
        TFAR_currentFarPlayersProcessed = true;
    };
};



//Rescan Players
private _needNearPlayerScan = TFAR_currentNearPlayersProcessed && {(diag_tickTime - TFAR_lastPlayerScanTime) > TFAR_PLAYER_RESCAN_TIME};

if (_needNearPlayerScan) then {
    TFAR_currentNearPlayers = call TFAR_fnc_getNearPlayers;
    /*
    Want to process Curators on NearPlayers because even if they are not near,
    their controlled unit may be.
    */

    TFAR_currentNearPlayers append (allCurators apply {getAssignedCuratorUnit _x} select {!isNull _x});//Add curators

    TFAR_currentNearPlayers = TFAR_currentNearPlayers arrayIntersect TFAR_currentNearPlayers; //Remove duplicates

    TFAR_currentFarPlayers = (allPlayers - TFAR_currentNearPlayers) select {isPlayer _x};

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
