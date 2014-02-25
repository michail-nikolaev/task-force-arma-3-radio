//#define DEBUG_MODE_FULL

if (isNil "tf_no_auto_long_range_radio") then {
	tf_no_auto_long_range_radio = false;
};

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

	if (([west, resistance] call BIS_fnc_areFriendly) and {!([east, resistance] call BIS_fnc_areFriendly)}) then {
		tf_guer_radio_code = "_bluefor";
	};

	if (([east, resistance] call BIS_fnc_areFriendly) and {!([west, resistance] call BIS_fnc_areFriendly)}) then {
		tf_guer_radio_code = "_opfor";
	};
};
if (isNil "TF_defaultWestBackpack") then {
	TF_defaultWestBackpack = "tf_rt1523g";
};
if (isNil "TF_defaultEastBackpack") then {
	TF_defaultEastBackpack = "tf_mr3000";
};
if (isNil "TF_defaultGuerBackpack") then {
	TF_defaultGuerBackpack = "tf_anprc155";
};

if (isNil "TF_defaultWestPersonalRadio") then {
	TF_defaultWestPersonalRadio = "tf_anprc152";
};
if (isNil "TF_defaultEastPersonalRadio") then {
	TF_defaultEastPersonalRadio = "tf_fadak";
};
if (isNil "TF_defaultGuerPersonalRadio") then {
	TF_defaultGuerPersonalRadio = "tf_anprc148jem";
};

disableSerialization;
#include "diary.sqf"

waitUntil {time > 0};
waitUntil {!(isNull player)};
titleText [localize ("STR_init"), "PLAIN"];

#include "define.h"

#include "script.h"

TF_radio_request_mutex = false;

TF_use_saved_sw_setting = false;
TF_saved_active_sw_settings = nil;

TF_use_saved_lr_setting = false;
TF_saved_active_lr_settings = nil;

TF_MAX_SW_VOLUME = 10;
TF_MAX_LR_VOLUME = 10;
TF_MAX_DD_VOLUME = 10;

TF_dd_volume_level = 7;

TF_MIN_DD_FREQ = 32;
TF_MAX_DD_FREQ = 41;

TF_HintFnc = nil;

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

TF_tangent_sw_pressed = false;
TF_tangent_lr_pressed = false;
TF_tangent_dd_pressed = false;

TF_dd_frequency = str (round (((random (TF_MAX_DD_FREQ - TF_MIN_DD_FREQ)) + TF_MIN_DD_FREQ) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER);

TF_speak_volume_level = "normal";
TF_sw_dialog_radio = nil;

TF_lr_dialog_radio = nil;
TF_lr_active_radio = nil;

tf_lastNearFrameTick = diag_tickTime;
tf_lastFarFrameTick = diag_tickTime;
tf_msPerStep = 0;

tf_nearPlayers = [];
tf_farPlayers = [];

tf_nearPlayersIndex = 0;
tf_nearPlayersProcessed = true;

tf_farPlayersIndex = 0;
tf_farPlayersProcessed = true;

tf_msNearPerStepMax = 0.025;
tf_msNearPerStepMin = 0.1;
tf_msNearPerStep = tf_msNearPerStepMax;
tf_nearUpdateTime = 0.3;

tf_msFarPerStepMax = 0.035;
tf_msFarPerStepMin = 1.00;
tf_msFarPerStep = tf_msFarPerStepMax;
tf_farUpdateTime = 3.5;

tf_lastFrequencyInfoTick = 0;
tf_lastNearPlayersUpdate = 0;

tf_lastError = false;

tf_msSpectatorPerStepMax = 0.035;

[] spawn {
	waituntil {!(IsNull (findDisplay 46))};

	["player", [[TF_dialog_sw_scancode, TF_dialog_sw_modifiers]], -3, '_this call TFAR_fnc_swRadioMenu'] call CBA_fnc_flexiMenu_Add;

	[TF_tangent_sw_scancode, TF_tangent_sw_modifiers, {call TFAR_fnc_onSwTangentPressed}, "keydown", "2"] call CBA_fnc_addKeyHandler;
	[TF_tangent_sw_scancode, TF_tangent_sw_modifiers, {call TFAR_fnc_onSwTangentReleased}, "keyup", "_2"] call CBA_fnc_addKeyHandler;

	[TF_sw_channel_1_scancode, TF_sw_channel_1_modifiers, {[0] call TFAR_fnc_processSWChannelKeys}, "keydown", "3"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_2_scancode, TF_sw_channel_2_modifiers, {[1] call TFAR_fnc_processSWChannelKeys}, "keydown", "4"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_3_scancode, TF_sw_channel_3_modifiers, {[2] call TFAR_fnc_processSWChannelKeys}, "keydown", "5"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_4_scancode, TF_sw_channel_4_modifiers, {[3] call TFAR_fnc_processSWChannelKeys}, "keydown", "6"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_5_scancode, TF_sw_channel_5_modifiers, {[4] call TFAR_fnc_processSWChannelKeys}, "keydown", "7"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_6_scancode, TF_sw_channel_6_modifiers, {[5] call TFAR_fnc_processSWChannelKeys}, "keydown", "8"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_7_scancode, TF_sw_channel_7_modifiers, {[6] call TFAR_fnc_processSWChannelKeys}, "keydown", "9"] call CBA_fnc_addKeyHandler;
	[TF_sw_channel_8_scancode, TF_sw_channel_8_modifiers, {[7] call TFAR_fnc_processSWChannelKeys}, "keydown", "10"] call CBA_fnc_addKeyHandler;	

	[TF_tangent_lr_scancode, TF_tangent_lr_modifiers, {call TFAR_fnc_onLRTangentPressed}, "keydown", "11"] call CBA_fnc_addKeyHandler;
	[TF_tangent_lr_scancode, TF_tangent_lr_modifiers, {call TFAR_fnc_onLRTangentReleased}, "keyup", "_11"] call CBA_fnc_addKeyHandler;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onLRTangentReleasedHack"];
	["player", [[TF_dialog_lr_scancode, TF_dialog_lr_modifiers]], -3, '_this call TFAR_fnc_lrRadioMenu'] call CBA_fnc_flexiMenu_Add;

	[TF_lr_channel_1_scancode, TF_lr_channel_1_modifiers, {[0] call TFAR_fnc_processLRChannelKeys}, "keydown", "13"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_2_scancode, TF_lr_channel_2_modifiers, {[1] call TFAR_fnc_processLRChannelKeys}, "keydown", "14"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_3_scancode, TF_lr_channel_3_modifiers, {[2] call TFAR_fnc_processLRChannelKeys}, "keydown", "15"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_4_scancode, TF_lr_channel_4_modifiers, {[3] call TFAR_fnc_processLRChannelKeys}, "keydown", "16"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_5_scancode, TF_lr_channel_5_modifiers, {[4] call TFAR_fnc_processLRChannelKeys}, "keydown", "17"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_6_scancode, TF_lr_channel_6_modifiers, {[5] call TFAR_fnc_processLRChannelKeys}, "keydown", "18"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_7_scancode, TF_lr_channel_7_modifiers, {[6] call TFAR_fnc_processLRChannelKeys}, "keydown", "19"] call CBA_fnc_addKeyHandler;
	[TF_lr_channel_8_scancode, TF_lr_channel_8_modifiers, {[7] call TFAR_fnc_processLRChannelKeys}, "keydown", "20"] call CBA_fnc_addKeyHandler;	
	[TF_lr_channel_9_scancode, TF_lr_channel_9_modifiers, {[8] call TFAR_fnc_processLRChannelKeys}, "keydown", "21"] call CBA_fnc_addKeyHandler;	

	[TF_tangent_dd_scancode, TF_tangent_dd_modifiers, {call TFAR_fnc_onDDTangentReleased}, "keyup", "_22"] call CBA_fnc_addKeyHandler;
	[TF_tangent_dd_scancode, TF_tangent_dd_modifiers, {call TFAR_fnc_onDDTangentPressed}, "keydown", "22"] call CBA_fnc_addKeyHandler;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call TFAR_fnc_onDDTangentReleasedHack"];
	[TF_dialog_dd_scancode, TF_dialog_dd_modifiers, {call TFAR_fnc_onDDDialogOpen}, "keydown", "23"] call CBA_fnc_addKeyHandler;

	[TF_speak_volume_scancode, TF_speak_volume_modifiers, {call TFAR_fnc_onSpeakVolumeChange}, "keydown", "24"] call CBA_fnc_addKeyHandler;	

	if (isMultiplayer) then {
		call TFAR_fnc_sendVersionInfo;
		["processPlayerPositionsHandler", "onEachFrame", "TFAR_fnc_processPlayerPositions"] call BIS_fnc_addStackedEventHandler;
		
		player addMPEventHandler ["MPKilled", {(_this select 0) call TFAR_fnc_sendPlayerKilled}];
	};
};

TF_first_radio_request = true;
TF_last_request_time = 0;

player addEventHandler ["respawn", {call TFAR_fnc_processRespawn}];
player addEventHandler ["killed", {TF_use_saved_sw_setting = true; TF_use_saved_lr_setting = true; TF_first_radio_request = true;}];
call TFAR_fnc_processRespawn;

TF_respawnedAt = time;

[] spawn {
	waitUntil {!(isNull player)};
	sleep 5;
	call TFAR_fnc_radioReplaceProcess;
};

[] spawn {
	waitUntil {!((isNil "TF_server_addon_version") and (time < 20))};
	if (isNil "TF_server_addon_version") then {
		hintC (localize "STR_no_server");
	} else {
		if (TF_server_addon_version != TF_ADDON_VERSION) then {
			hintC format[localize "STR_different_version", TF_server_addon_version, TF_ADDON_VERSION];
		};
	};
};