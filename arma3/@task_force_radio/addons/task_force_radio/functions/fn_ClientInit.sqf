//#define DEBUG_MODE_FULL

//tf_no_auto_long_range_radio = true;

if (isNil "tf_radio_channel_name") then {
	tf_radio_channel_name = "TaskForceRadio";
};
if (isNil "tf_radio_channel_password") then {
	tf_radio_channel_password = "123";
};
if (isNil "tf_west_radio_code") then {
	tf_west_radio_code = "_bluefor";
};
if (isNil "tf_east_radio_code") then {
	tf_east_radio_code = "_opfor";
};
if (isNil "tf_guer_radio_code") then {
	tf_guer_radio_code = "_independent";

	if ([west, resistance] call BIS_fnc_areFriendly) then {
		tf_guer_radio_code = "_bluefor";
	};

	if ([east, resistance] call BIS_fnc_areFriendly) then {
		tf_guer_radio_code = "_opfor";
	};
};

disableSerialization;
#include "diary.sqf"

waitUntil {time > 0};
waitUntil {!(isNull player)};
titleText [localize ("STR_init"), "PLAIN"];

#include "\task_force_radio\define.h"

#include "script.h"

radio_request_mutex = false;

use_saved_sw_setting = false;
saved_active_sw_settings = nil;

use_saved_lr_setting = false;
saved_active_lr_settings = nil;

MAX_SW_VOLUME = 10;
MAX_LR_VOLUME = 10;
MAX_DD_VOLUME = 10;

dd_volume_level = 7;

MIN_DD_FREQ = 32;
MAX_DD_FREQ = 41;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_RADIO_DIALOG_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDC_ANPRC152_RADIO_DIALOG;

IDC_ANPRC155_RADIO_DIALOG_EDIT_ID = IDC_ANPRC155_EDIT155;
IDC_ANPRC155_RADIO_DIALOG_ID = IDC_ANPRC155_RADIO_DIALOG;

IDC_ANPRC148JEM_RADIO_DIALOG_EDIT_ID = IDC_ANPRC148JEM_EDIT148;
IDC_ANPRC148JEM_RADIO_DIALOG_ID = IDC_ANPRC148JEM_DIALOG;

IDC_FADAK_RADIO_DIALOG_EDIT_ID = IDC_FADAK_EDIT_FADAK;
IDC_FADAK_RADIO_DIALOG_ID = IDC_FADAK_RADIO_DIALOG;

IDC_RT1523G_RADIO_DIALOG_EDIT_ID = IDC_RT1523G_RADIO_DIALOG_EDIT;
IDC_RT1523G_RADIO_DIALOG_ID = IDC_RT1523G_RADIO_DIALOG;

IDC_MR3000_RADIO_DIALOG_EDIT_ID = IDC_MR3000_MR3000_EDIT;
IDC_MR3000_RADIO_DIALOG_ID = IDC_MR3000_RADIO_DIALOG;

IDC_DIDER_RADIO_DIALOG_ID = IDC_DIVER_RADIO_DIALOG;
IDC_DIVER_RADIO_EDIT_ID = IDC_DIVER_RADIO_EDIT;
IDC_DIVER_RADIO_DEPTH_ID = IDC_DIVER_RADIO_DEPTH;

#include "keys.sqf"

tangent_sw_pressed = false;
tangent_lr_pressed = false;
tangent_dd_pressed = false;

dd_frequency = str (round (((random (MAX_DD_FREQ - MIN_DD_FREQ)) + MIN_DD_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER);

speak_volume_level = "normal";
sw_dialog_radio = nil;

lr_dialog_radio = nil;
lr_active_radio = nil;

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
tf_msPerStep = 0;

tf_nearPlayers = [];
tf_farPlayers = [];

tf_nearPlayersIndex = 0;
tf_nearPlayersProcessed = true;

tf_farPlayersIndex = 0;
tf_farPlayersProcessed = true;

tf_msNearPerStepMax = 0.05;
tf_msNearPerStepMin = 1.00;
tf_msNearPerStep = tf_msNearPerStepMax;
tf_nearUpdateTime = 0.5;

tf_msFarPerStepMax = 0.07;
tf_msFarPerStepMin = 2.00;
tf_msFarPerStep = tf_msFarPerStepMax;
tf_farUpdateTime = 7;

tf_lastFrequencyInfoTick = 0;
tf_lastNearPlayersUpdate = 0;

tf_lastError = false;

tf_msSpectatorPerStepMax = 0.035;

[] spawn {
	
	waituntil {!(IsNull (findDisplay 46))};

	["player", [[dialog_sw_scancode, [dialog_sw_shift == 1, dialog_sw_ctrl == 1, dialog_sw_alt == 1]]], -3, '_this call TFAR_fnc_swRadioMenu'] call CBA_fnc_flexiMenu_Add;

	[tangent_sw_scancode, [tangent_sw_shift == 1, tangent_sw_ctrl == 1, tangent_sw_alt == 1], {call TFAR_fnc_onSwTangentPressed}, "keydown", "2"] call CBA_fnc_addKeyHandler;
	[tangent_sw_scancode, [tangent_sw_shift == 1, tangent_sw_ctrl == 1, tangent_sw_alt == 1], {call TFAR_fnc_onSwTangentReleased}, "keyup", "_2"] call CBA_fnc_addKeyHandler;

	[sw_channel_1_scancode, [sw_channel_1_shift == 1, sw_channel_1_ctrl == 1, sw_channel_1_alt == 1], {[0] call TFAR_fnc_processSWChannelKeys}, "keydown", "3"] call CBA_fnc_addKeyHandler;
	[sw_channel_2_scancode, [sw_channel_2_shift == 1, sw_channel_2_ctrl == 1, sw_channel_2_alt == 1], {[1] call TFAR_fnc_processSWChannelKeys}, "keydown", "4"] call CBA_fnc_addKeyHandler;
	[sw_channel_3_scancode, [sw_channel_3_shift == 1, sw_channel_3_ctrl == 1, sw_channel_3_alt == 1], {[2] call TFAR_fnc_processSWChannelKeys}, "keydown", "5"] call CBA_fnc_addKeyHandler;
	[sw_channel_4_scancode, [sw_channel_4_shift == 1, sw_channel_4_ctrl == 1, sw_channel_4_alt == 1], {[3] call TFAR_fnc_processSWChannelKeys}, "keydown", "6"] call CBA_fnc_addKeyHandler;
	[sw_channel_5_scancode, [sw_channel_5_shift == 1, sw_channel_5_ctrl == 1, sw_channel_5_alt == 1], {[4] call TFAR_fnc_processSWChannelKeys}, "keydown", "7"] call CBA_fnc_addKeyHandler;
	[sw_channel_6_scancode, [sw_channel_6_shift == 1, sw_channel_6_ctrl == 1, sw_channel_6_alt == 1], {[5] call TFAR_fnc_processSWChannelKeys}, "keydown", "8"] call CBA_fnc_addKeyHandler;
	[sw_channel_7_scancode, [sw_channel_7_shift == 1, sw_channel_7_ctrl == 1, sw_channel_7_alt == 1], {[6] call TFAR_fnc_processSWChannelKeys}, "keydown", "9"] call CBA_fnc_addKeyHandler;
	[sw_channel_8_scancode, [sw_channel_8_shift == 1, sw_channel_8_ctrl == 1, sw_channel_8_alt == 1], {[7] call TFAR_fnc_processSWChannelKeys}, "keydown", "10"] call CBA_fnc_addKeyHandler;	

	[tangent_lr_scancode, [tangent_lr_shift == 1, tangent_lr_ctrl == 1, tangent_lr_alt == 1], {call TFAR_fnc_onLRTangentPressed}, "keydown", "11"] call CBA_fnc_addKeyHandler;
	[tangent_lr_scancode, [tangent_lr_shift == 1, tangent_lr_ctrl == 1, tangent_lr_alt == 1], {call TFAR_fnc_onLRTangentReleased}, "keyup", "_11"] call CBA_fnc_addKeyHandler;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
	["player", [[dialog_lr_scancode, [dialog_lr_shift == 1, dialog_lr_ctrl == 1, dialog_lr_alt == 1]]], -3, '_this call TFAR_fnc_lrRadioMenu'] call CBA_fnc_flexiMenu_Add;

	[lr_channel_1_scancode, [lr_channel_1_shift == 1, lr_channel_1_ctrl == 1, lr_channel_1_alt == 1], {[0] call TFAR_fnc_processLRChannelKeys}, "keydown", "13"] call CBA_fnc_addKeyHandler;
	[lr_channel_2_scancode, [lr_channel_2_shift == 1, lr_channel_2_ctrl == 1, lr_channel_2_alt == 1], {[1] call TFAR_fnc_processLRChannelKeys}, "keydown", "14"] call CBA_fnc_addKeyHandler;
	[lr_channel_3_scancode, [lr_channel_3_shift == 1, lr_channel_3_ctrl == 1, lr_channel_3_alt == 1], {[2] call TFAR_fnc_processLRChannelKeys}, "keydown", "15"] call CBA_fnc_addKeyHandler;
	[lr_channel_4_scancode, [lr_channel_4_shift == 1, lr_channel_4_ctrl == 1, lr_channel_4_alt == 1], {[3] call TFAR_fnc_processLRChannelKeys}, "keydown", "16"] call CBA_fnc_addKeyHandler;
	[lr_channel_5_scancode, [lr_channel_5_shift == 1, lr_channel_5_ctrl == 1, lr_channel_5_alt == 1], {[4] call TFAR_fnc_processLRChannelKeys}, "keydown", "17"] call CBA_fnc_addKeyHandler;
	[lr_channel_6_scancode, [lr_channel_6_shift == 1, lr_channel_6_ctrl == 1, lr_channel_6_alt == 1], {[5] call TFAR_fnc_processLRChannelKeys}, "keydown", "18"] call CBA_fnc_addKeyHandler;
	[lr_channel_7_scancode, [lr_channel_7_shift == 1, lr_channel_7_ctrl == 1, lr_channel_7_alt == 1], {[6] call TFAR_fnc_processLRChannelKeys}, "keydown", "19"] call CBA_fnc_addKeyHandler;
	[lr_channel_8_scancode, [lr_channel_8_shift == 1, lr_channel_8_ctrl == 1, lr_channel_8_alt == 1], {[7] call TFAR_fnc_processLRChannelKeys}, "keydown", "20"] call CBA_fnc_addKeyHandler;	
	[lr_channel_9_scancode, [lr_channel_9_shift == 1, lr_channel_9_ctrl == 1, lr_channel_9_alt == 1], {[8] call TFAR_fnc_processLRChannelKeys}, "keydown", "21"] call CBA_fnc_addKeyHandler;	

	[tangent_dd_scancode, [tangent_dd_shift == 1, tangent_dd_ctrl == 1, tangent_dd_alt == 1], {call TFAR_fnc_onDDTangentReleased}, "keyup", "_22"] call CBA_fnc_addKeyHandler;
	[tangent_dd_scancode, [tangent_dd_shift == 1, tangent_dd_ctrl == 1, tangent_dd_alt == 1], {call TFAR_fnc_onDDTangentPressed}, "keydown", "22"] call CBA_fnc_addKeyHandler;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];
	[dialog_dd_scancode, [dialog_dd_shift == 1, dialog_dd_ctrl == 1, dialog_dd_alt == 1], {call TFAR_fnc_onDDDialogOpen}, "keydown", "23"] call CBA_fnc_addKeyHandler;

	[speak_volume_scancode, [speak_volume_shift == 1, speak_volume_ctrl == 1, speak_volume_alt == 1], {call TFAR_fnc_onSpeakVolumeChange}, "keydown", "24"] call CBA_fnc_addKeyHandler;	

	if (isMultiplayer) then {
		call TFAR_fnc_sendVersionInfo;
		["processPlayerPositionsHandler", "onEachFrame", "TFAR_fnc_processPlayerPositions"] call BIS_fnc_addStackedEventHandler;
		
		player addMPEventHandler ["MPKilled", {(_this select 0) call TFAR_fnc_sendPlayerKilled}];
	};
};

first_radio_request = true;
last_request_time = 0;

player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];
player addEventHandler ["killed", {use_saved_sw_setting = true; use_saved_lr_setting = true; first_radio_request = true;}];
call TFAR_fnc_processRespawn;

respawnedAt = time;

[] spawn {
	waitUntil {!(isNull player)};
	sleep 5;
	call TFAR_fnc_radioReplaceProcess;
};

[] spawn {
	waitUntil {!((isNil "server_addon_version") and (time < 20))};
	if (isNil "server_addon_version") then {
		hintC (localize "STR_no_server");
	} else {
		if (server_addon_version != TF_ADDON_VERSION) then {
			hintC format[localize "STR_different_version", server_addon_version, TF_ADDON_VERSION];
		};
	};
};