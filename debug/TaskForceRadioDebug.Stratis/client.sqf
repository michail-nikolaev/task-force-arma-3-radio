#define DEBUG_MODE_FULL

disableSerialization;
#include "diary.sqf"

waitUntil {time > 0};
waitUntil {!(isNull player)};
titleText [localize ("STR_init"), "PLAIN"];

#include "task_force_radio\define.h"
#include "vehicles.sqf"

#define SHIFTL 42
#define CTRLL 29
#define ALTL 56
#define ACTIVE_CHANNEL_OFFSET 0
#define VOLUME_OFFSET 1
#define FREQ_OFFSET 2
MAX_CHANNELS = 8;

ADDON_VERSION = "0.7.0 beta";

MIN_SW_FREQ = 30;
MAX_SW_FREQ = 512;

MAX_SW_VOLUME = 10;
MAX_LR_VOLUME = 10;
MAX_DD_VOLUME = 10;

lr_volume_level = 7;
dd_volume_level = 7;

MIN_ASIP_FREQ = 30;
MAX_ASIP_FREQ = 87;

MIN_DD_FREQ = 32;
MAX_DD_FREQ = 41;

MAX_LR_CHANNELS = 9;


FREQ_ROUND_POWER = 10;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_RADIO_DIALOG_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDC_ANPRC152_RADIO_DIALOG;

IDC_ANPRC155_RADIO_DIALOG_EDIT_ID = IDC_ANPRC155_RADIO_DIALOG;
IDC_ANPRC155_RADIO_DIALOG_ID = IDC_ANPRC155_RADIO_DIALOG;

IDC_ANPRC148JEM_RADIO_DIALOG_EDIT_ID = IDC_ANPRC148JEM_EDIT148;
IDC_ANPRC148JEM_RADIO_DIALOG_ID = IDC_ANPRC148JEM_DIALOG;

IDC_RT1523G_RADIO_DIALOG_EDIT_ID = IDC_RT1523G_RADIO_DIALOG_EDIT;
IDC_RT1523G_RADIO_DIALOG_ID = IDC_RT1523G_RADIO_DIALOG;

IDC_DIDER_RADIO_DIALOG_ID = IDC_DIVER_RADIO_DIALOG;
IDC_DIVER_RADIO_EDIT_ID = IDC_DIVER_RADIO_EDIT;
IDC_DIVER_RADIO_DEPTH_ID = IDC_DIVER_RADIO_DEPTH;



setSwSetting = 
{
	private ["_radio_id", "_value", "_variableName"];
	_radio_id = _this select 0;
	_value = _this select 1;
	_variableName = format["%1_settings", _radio_id];	
	missionNamespace setVariable [_variableName, _value];
	publicVariable _variableName;
};

setLrSettings = 
{
	private ["_radio_object", "_radio_qualifier", "_value"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	_radio_object setVariable [_radio_qualifier, _value, true];
};


getSwChannel = 
{
	_settings = _this call getSwSettings;
	_settings select ACTIVE_CHANNEL_OFFSET;
};

getLrChannel = 
{
	_settings = _this call getLrSettings;
	_settings select ACTIVE_CHANNEL_OFFSET;
	
};

setSwChannel = 
{
	_radio_id = _this select 0;
	_channel_to_set = _this select 1;
	_settings = _radio_id call getSwSettings;
	_settings set [ACTIVE_CHANNEL_OFFSET, _channel_to_set];
	[_radio_id, _settings] call setSwSetting;
};


setLrChannel = 
{
	private ["_radio_object", "_radio_qualifier", "_value"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	_settings = [_radio_object, _radio_qualifier] call getLrSettings;
	_settings set [ACTIVE_CHANNEL_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call setLrSettings;
};


getSwFrequency = 
{
	_settings = _this call getSwSettings;
	_settings select (FREQ_OFFSET + (_settings select ACTIVE_CHANNEL_OFFSET));
};

getLrFrequency = 
{
	_settings = _this call getLrSettings;
	_settings select (FREQ_OFFSET + (_settings select ACTIVE_CHANNEL_OFFSET));
};

setSwVolume = 
{
	_radio_id = _this select 0;
	_value = _this select 1;
	_settings = _radio_id call getSwSettings;
	_settings set [VOLUME_OFFSET, _value];
	[_radio_id, _settings] call setSwSetting;
};

setLrVolume = 
{
	private ["_radio_object", "_radio_qualifier", "_value"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	_settings = [_radio_object, _radio_qualifier] call getLrSettings;
	_settings set [VOLUME_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call setLrSettings;
};

getSwVolume =
{
	_settings = _this call getSwSettings;
	_settings select VOLUME_OFFSET;
};

getLrVolume = 
{	
	_settings = _this call getLrSettings;
	_settings select VOLUME_OFFSET;	
};

setSwFrequency = 
{
	private ["_radio_id", "_freq", "_settings"];
	_radio_id = _this select 0;
	_freq = _this select 1;
	_settings = _radio_id call getSwSettings;
	_settings set [(_settings select ACTIVE_CHANNEL_OFFSET) + FREQ_OFFSET, _freq];
	[_radio_id, _settings] call setSwSetting;
};

setLrFrequency =
{
	private ["_radio_object", "_radio_qualifier", "_value"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	
	_settings = [_radio_object, _radio_qualifier] call getLrSettings;
	_settings set [(_settings select ACTIVE_CHANNEL_OFFSET) + FREQ_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call setLrSettings;
};

getSwSettings = 
{
	private ["_variableName", "_value"];
	_variableName = format["%1_settings", _this];
	_value = missionNamespace getVariable _variableName;
	if (isNil "_value") then {
		_value = call generateSwSetting;
		[_this, _value] call setSwSetting;
	};
	_value;
};

getLrSettings = 
{
	private ["_radio_object", "_radio_qualifier", "_value"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _radio_object getVariable _radio_qualifier;
	if (isNil "_value") then {
		_value = call generateLrSettings;
		[_radio_object, _radio_qualifier, _value] call setLrSettings;
	};
	_value;
};

generateSwSetting = 
{
	_sw_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0];
	for "_i" from FREQ_OFFSET to (FREQ_OFFSET + MAX_CHANNELS) step 1 do {
		_sw_frequencies set [_i, (str (round (((random (MAX_SW_FREQ - MIN_SW_FREQ)) + MIN_SW_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
	};
	_sw_frequencies;
};

generateLrSettings = 
{
	_lr_frequencies = [0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0];
	for "_i" from FREQ_OFFSET to (FREQ_OFFSET + MAX_LR_CHANNELS) step 1 do {
		_lr_frequencies set [_i, (str (round (((random (MAX_ASIP_FREQ - MIN_ASIP_FREQ)) + MIN_ASIP_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
	};
	_lr_frequencies;
};


#include "keys.sqf"

tangent_sw_pressed = false;
tangent_lr_pressed = false;
tangent_dd_pressed = false;

dd_frequency = str (round (((random (MAX_DD_FREQ - MIN_DD_FREQ)) + MIN_DD_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER);

speak_volume_level = "normal";
sw_dialog_radio = nil;

lr_dialog_radio = nil;
lr_active_radio = nil;

isRadio = 
{
	[ configFile >> "CfgWeapons"  >> _this, configFile >> "CfgWeapons" >>"ItemRadio"] call CBA_fnc_inheritsFrom
};


haveSWRadio = 
{	
	private ["_result"];
	_result = false;
	{	
		if (_x call isRadio) exitWith {_result = true};
		
	} forEach (assignedItems player);
	_result;
};
haveLRRadio = 
{
	count (call lrRadiosList) > 0;		
};
haveDDRadio = 
{
	((vest player == "V_RebreatherIR") or (vest player == "V_RebreatherB") or (vest player == "V_RebreatherIA"));
};


processSWChannelKeys = 
{				
	private ["_sw_channel_number", "_hintText"];
	_sw_channel_number = _this select 0;

	if (call haveSWRadio) then {		
		[call activeSwRadio, _sw_channel_number] call setSwChannel;

		_hintText = format[localize "STR_active_sw_channel", _sw_channel_number + 1];
		hint parseText (_hintText);
		if (dialog) then {
			call updateSWDialogToChannel;
		}			
	
	};
	true;

};
processLRChannelKeys = 
{			
	private ["_lr_channel_number", "_hintText"];
	_lr_channel_number = _this select 0;

	if (call haveLRRadio) then {
		_active_lr = call activeLrRadio;
		[_active_lr select 0, _active_lr select 1, _lr_channel_number] call setLrChannel;
		_hintText = format[localize "STR_active_lr_channel", _lr_channel_number + 1];
		hint parseText (_hintText);
		if (dialog) then {
			call updateLRDialogToChannel;
		}			
	
	};
	true;

};
currentSWFrequency = 
{
	(call activeSwRadio) call getSwFrequency;
};
currentLRFrequency = 
{
	(call activeLrRadio) call getLrFrequency;
};
updateDDDialog = 
{
	ctrlSetText [IDC_DIVER_RADIO_EDIT_ID, dd_frequency];
	_depth = round (((eyepos player) select 2) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER;
	_depthText =  format["%1m", _depth];
	ctrlSetText [IDC_DIVER_RADIO_DEPTH_ID, _depthText];
};
updateSWDialogToChannel = 
{
	ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT, sw_dialog_radio call getSwFrequency];
	_channelText =  format["C%1", (sw_dialog_radio call getSwChannel) + 1];
	ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_CHANNEL_EDIT, _channelText];
};
updateLRDialogToChannel = 
{
	ctrlSetText [IDC_RT1523G_RADIO_DIALOG_EDIT, lr_dialog_radio call getLrFrequency];
	_channelText =  format["CH: %1", (lr_dialog_radio call getLrChannel) + 1];
	ctrlSetText [IDC_RT1523G_RADIO_DIALOG_CHANNEL_EDIT, _channelText];
};
eyeDepth = 
{
	_player = _this select 0;
	((eyepos _player) select 2) + ((getPosASLW _player) select 2) - ((getPosASL _player) select 2);
};
canSpeak = 
{
	_player = _this select 0;
	(([_player] call eyeDepth) > 0);
};
canUseSWRadio =
{
	_player = _this select 0;
	(([_player] call eyeDepth) > 0);
};
canUseLRRadio =
{
	_player = _this select 0;
	((([_player] call eyeDepth > 0)) 
		or ( 
			(vehicle _player != _player) and (([_player] call eyeDepth) > -3) and (isAbleToBreathe _player)
		 ));
};
canUseDDRadio =
{
	_player = _this select 0;
	(([_player] call eyeDepth) < 0);
};

inWaterHint = 
{
	hintSilent parseText (localize "STR_in_water_hint");
};
onGroundHint = 
{
	hintSilent parseText (localize "STR_on_ground_hint");
};

onSwTangentPressed = 
{
	private["_result", "_request"];
	if (!(tangent_sw_pressed) and {alive player} and {call haveSWRadio}) then {
		if ([player] call canUseSWRadio) then { 
			_hintText = format[localize "STR_transmit_sw", [call activeSwRadio] call currentSWFrequency];
			hintSilent parseText (_hintText);
			_request = format["TANGENT@PRESSED@%1", [call activeSwRadio] call currentSWFrequency];
			_result = "task_force_radio_pipe" callExtension _request;
			tangent_sw_pressed = true;
		} else {
			call inWaterHint;
		};
	};
	true;
};

onSwTangentReleased = 
{
	private["_result", "_request"];
	if ((tangent_sw_pressed) and {alive player}) then {
		hintSilent "";
		_request = format["TANGENT@RELEASED@%1", [call activeSwRadio] call currentSWFrequency];
		_result = "task_force_radio_pipe" callExtension _request;	
		tangent_sw_pressed = false;
	};
	true;
};

onSwDialogOpen = 
{
	[] spawn {
		sleep 0.1;
		if ((alive player) and {!(isNil "sw_dialog_radio")} and {!dialog}) then {
			if (([sw_dialog_radio, "tf_anprc152_"] call CBA_fnc_find) == 0) then {
				createDialog "anprc152_radio_dialog";
			};
			if (([sw_dialog_radio, "tf_anprc148jem_"] call CBA_fnc_find) == 0) then {
				createDialog "anprc148jem_radio_dialog";
			};
			call updateSWDialogToChannel;
		};
	};
	true;
};

onLRTangentPressed = 
{
	private["_result", "_request"];
	if (!(tangent_lr_pressed) and {alive player} and {call haveLRRadio}) then {
		if ([player] call canUseLRRadio) then {
			_hintText = format[localize "STR_transmit_lr", [call activeLrRadio] call currentLRFrequency];
			hintSilent parseText (_hintText);
			_request = format["TANGENT_LR@PRESSED@%1", [call activeLrRadio] call currentLRFrequency];
			_result = "task_force_radio_pipe" callExtension _request;
			tangent_lr_pressed = true;
		} else {
			call inWaterHint;
		}
	};
	true;
};

onLRTangentReleased = 
{
	private["_result", "_request", "_return"];	
	if ((tangent_lr_pressed) and {alive player}) then {
		hintSilent "";
		_request = format["TANGENT_LR@RELEASED@%1", [call activeLrRadio] call currentLRFrequency];
		_result = "task_force_radio_pipe" callExtension _request;	
		tangent_lr_pressed = false;
	};
	true;
};

onLRTangentReleasedHack = 
{
	private ["_scancode"];
	_scancode = _this select 1; 
	if (((_scancode == CTRLL) and (tangent_lr_ctrl == 1))
	   or ((_scancode == ALTL) and (tangent_lr_alt == 1))
	   or ((_scancode == SHIFTL) and (tangent_lr_shift == 1)))
	 then {
		call onLRTangentReleased;
	};
};

onLRDialogOpen = 
{
	[] spawn {
		sleep 0.1;
	
		if ((alive player) and {call haveLRRadio}) then {
			if !(dialog) then {
				_dialog_to_open = "rt1523g_radio_dialog";

				if ((lr_dialog_radio select 0) isKindOf "Bag_Base") then {				
					if (typeOf(lr_dialog_radio select 0) == "tf_rt1523g") then {
						_dialog_to_open = "rt1523g_radio_dialog";
					};
					if (typeOf(lr_dialog_radio select 0) == "tf_anprc155") then {
						_dialog_to_open = "anprc155_radio_dialog";
					};
				} else {
					if (((lr_active_radio select 0) call tfr_getVehicleSide) == west) then {
						_dialog_to_open = "rt1523g_radio_dialog";
					};
					if (((lr_active_radio select 0) call tfr_getVehicleSide) == resistance) then {
						_dialog_to_open = "anprc155_radio_dialog";
					};
				};
				
			
				createDialog _dialog_to_open;
				call updateLRDialogToChannel;
			}
		};
	};
	true;
};

onDDTangentPressed = 
{
	private["_result", "_request"];
	if (!(tangent_dd_pressed) and {alive player} and {call haveDDRadio}) then {
		if ([player] call canUseDDRadio) then { 
			_hintText = format[localize "STR_transmit_dd", dd_frequency];
			hintSilent parseText (_hintText);
			_request = format["TANGENT_DD@PRESSED@%1", dd_frequency];
			_result = "task_force_radio_pipe" callExtension _request;
			tangent_dd_pressed = true;
		} else {
			call onGroundHint;
		}
	};
	true;
};

onDDTangentReleased = 
{
	private["_result", "_request"];
	if ((tangent_dd_pressed) and {alive player}) then {
		hintSilent "";
		_request = format["TANGENT_DD@RELEASED@%1", dd_frequency];
		_result = "task_force_radio_pipe" callExtension _request;	
		tangent_dd_pressed = false;
	};
	true;
};


onDDTangentReleasedHack = 
{
	private ["_scancode"];
	_scancode = _this select 1; 
	if (((_scancode == CTRLL) and (tangent_dd_ctrl == 1))
	   or ((_scancode == ALTL) and (tangent_dd_alt == 1))
	   or ((_scancode == SHIFTL) and (tangent_dd_shift == 1)))
	 then {
		call onDDTangentReleased;
	};
};

onDDDialogOpen = 
{
	if ((alive player) and {call haveDDRadio}) then {
		if !(dialog) then {
			createDialog "diver_radio_dialog";
			call updateDDDialog;
		};
	};
	true;
};

onSpeakVolumeChange = 
{
	private["_localName", "_hintText"];
	if (alive player) then
	{
		_localName = "STR_voice_normal";
		if (speak_volume_level == "Whispering") then {
			speak_volume_level = "normal";
			_localName = localize "STR_voice_normal";
		} else {
			if (speak_volume_level == "Normal") then {
				speak_volume_level = "yelling";
				_localName = localize "STR_voice_yelling";
			} else {
				speak_volume_level = "whispering";
				_localName = localize "STR_voice_whispering";
			}
		};
		_hintText = format[localize "STR_voice_volume", _localName];
		hintSilent parseText (_hintText);
	};
	true;
};

preparePositionCoordinates = 		
{
	_x = _this select 0;
	_current_eyepos = eyepos _x;
	_xname = name _x;
	_current_x = (_current_eyepos select 0);
	_current_y = (_current_eyepos select 1);
	_current_z = (_current_eyepos select 2);

	_current_look_at = screenToWorld [0.5,0.5];
	_current_look_at_x = (_current_look_at select 0) - _current_x;
	_current_look_at_y = (_current_look_at select 1) - _current_y;
	_current_look_at_z = (_current_look_at select 2) - _current_z;

	_current_rotation_horizontal = 0;
	_current_hyp_horizontal = sqrt(_current_look_at_x * _current_look_at_x + _current_look_at_y * _current_look_at_y);

	if (_current_hyp_horizontal > 0) then {

		if (_current_look_at_x < 0) then {
			_current_rotation_horizontal = round -acos(_current_look_at_y / _current_hyp_horizontal);
		}
		else
		{
			_current_rotation_horizontal = round acos(_current_look_at_y / _current_hyp_horizontal);
		};
	} else {
		_current_rotation_horizontal = 0;
	};
	while{_current_rotation_horizontal < 0} do {
		_current_rotation_horizontal = _current_rotation_horizontal + 360;
	};
	if (alive player) then 
	{
		_player_pos = eyepos player;
		_current_x = _current_x - (_player_pos select 0);
		_current_y = _current_y - (_player_pos select 1);
		_current_z = _current_z - (_player_pos select 2);
	};
	(format["POS@%1@%2@%3@%4@%5@%6@%7@%8@%9", _xname, _current_x, _current_y, _current_z, _current_rotation_horizontal, [_x] call canSpeak, [_x] call canUseSWRadio, [_x] call canUseLRRadio, [_x] call canUseDDRadio]);	
};

setActiveSwRadio = 
{
	player unassignItem (call activeSwRadio);
	player assignItem _this;
};

setActiveLrRadio = 
{
	lr_active_radio = _this;
};

activeSwRadio = 
{
	private ["_result"];
	_result = nil;
	{	
		if (_x call isRadio) exitWith {_result = _x};
		
	} forEach (assignedItems player);
	_result;
};

activeLrRadio = 
{
	_radios = call lrRadiosList;
	if (isNil "lr_active_radio") then {		
		if (count _radios > 0) then {
			lr_active_radio = _radios select 0;		
		};
	} else {
		_found = false;
		{
			if (((_x select 0) == (lr_active_radio select 0)) and ((_x select 1) == (lr_active_radio select 1))) exitWith {_found = true};
		} forEach _radios;
		if !(_found) then {
			if (count _radios > 0) then {
				lr_active_radio = _radios select 0;		
			} else {
				lr_active_radio = nil;
			};
		}
	};
	lr_active_radio;
};

swRadioSubMenu = 
{	
	_submenu = 
	[
		["secondary", localize "STR_select_action", "buttonList", "", false],
		[
			[localize "STR_select_action_setup", "call onSwDialogOpen;", "", localize "STR_select_action_setup_tooltip", "", -1, true, true],
			[localize "STR_select_action_use", "sw_dialog_radio call setActiveSwRadio", "", localize "STR_select_action_use_tooltip", "", -1, true, true]
		]		
	];
	_submenu;
};

swRadioMenu =
{	
	if ((count (call radiosList) > 1) or {(count (call radiosList) == 1) and !(call haveSWRadio) }) then
	{
		_menuDef = ["main", localize "STR_select_radio", "buttonList", "", false];
		_positions = [];
		{
			_command = format["sw_dialog_radio = '%1';call onSwDialogOpen;", _x];
			_submenu = "";
			_active_radio = call activeSwRadio;
			if ((isNil "_active_radio") or {_x != _active_radio}) then
			{
				_command = format["sw_dialog_radio = '%1';", _x];
				_submenu = "_this call swRadioSubMenu";
			};
			_position = [
				getText(configFile >> "CfgWeapons"  >> _x >> "displayName"), 
				_command, 
				getText(configFile >> "CfgWeapons"  >> _x >> "picture"),
				"",
				_submenu,
				-1,
				true,
				true
			];
			_positions set [count _positions, _position];
		} forEach (call radiosList);
		_menu =
		[
			_menuDef,
			_positions	
		];
		_menu;
	} else {
		if (call haveSWRadio) then {
			sw_dialog_radio = call activeSwRadio;
			call onSwDialogOpen;
		};
		nil;
	};
};

lrRadioSubMenu = 
{	
	_submenu = 
	[
		["secondary", localize "STR_select_action", "buttonList", "", false],
		[
			[localize "STR_select_action_setup", "call onLrDialogOpen;", "", localize "STR_select_action_setup_tooltip", "", -1, true, true],
			[localize "STR_select_action_use", "lr_dialog_radio call setActiveLrRadio", "", localize "STR_select_action_use_tooltip", "", -1, true, true]
		]		
	];
	_submenu;
};

lrRadioMenu = 
{

	if (count (call lrRadiosList) > 1) then
	{
		_menuDef = ["main", localize "STR_select_lr_radio", "buttonList", "", false];
		_positions = [];
		_pos = 0;
		{
			_command = format["lr_dialog_radio = (call lrRadiosList) select %1;call onLrDialogOpen;", _pos];
			_submenu = "";
			_active_radio = call activeLrRadio;
			if (((_x select 0) != (_active_radio select 0)) or ((_x select 1) != (_active_radio select 1))) then
			{
				_command = format["lr_dialog_radio = (call lrRadiosList) select %1;", _pos];
				_submenu = "_this call lrRadioSubMenu";
			};
			_position = [
				getText(configFile >> "CfgVehicles"  >> typeof(_x select 0) >> "displayName"), 
				_command, 
				getText(configFile >> "CfgVehicles"  >> typeof(_x select 0) >> "picture"),
				"",
				_submenu,
				-1,
				true,
				true
			];
			_positions set [count _positions, _position];
			_pos = _pos + 1;
		} forEach (call lrRadiosList);
		_menu =
		[
			_menuDef,
			_positions	
		];
		_menu;
	} else {
		if (call haveSWRadio) then {
			lr_dialog_radio = call activeLrRadio;
			call onLrDialogOpen;
		};
		nil;
	};
};



[] spawn {
	waituntil {!(IsNull (findDisplay 46))};


	["player", [[dialog_sw_scancode, [dialog_sw_shift == 1, dialog_sw_ctrl == 1, dialog_sw_alt == 1]]], -3, '_this call swRadioMenu'] call CBA_fnc_flexiMenu_Add;

	[tangent_sw_scancode, [tangent_sw_shift == 1, tangent_sw_ctrl == 1, tangent_sw_alt == 1], {call onSwTangentPressed}, "keydown", "2"] call CBA_fnc_addKeyHandler;
	[tangent_sw_scancode, [tangent_sw_shift == 1, tangent_sw_ctrl == 1, tangent_sw_alt == 1], {call onSwTangentReleased}, "keyup", "_2"] call CBA_fnc_addKeyHandler;

	[sw_channel_1_scancode, [sw_channel_1_shift == 1, sw_channel_1_ctrl == 1, sw_channel_1_alt == 1], {[0] call processSWChannelKeys}, "keydown", "3"] call CBA_fnc_addKeyHandler;
	[sw_channel_2_scancode, [sw_channel_2_shift == 1, sw_channel_2_ctrl == 1, sw_channel_2_alt == 1], {[1] call processSWChannelKeys}, "keydown", "4"] call CBA_fnc_addKeyHandler;
	[sw_channel_3_scancode, [sw_channel_3_shift == 1, sw_channel_3_ctrl == 1, sw_channel_3_alt == 1], {[2] call processSWChannelKeys}, "keydown", "5"] call CBA_fnc_addKeyHandler;
	[sw_channel_4_scancode, [sw_channel_4_shift == 1, sw_channel_4_ctrl == 1, sw_channel_4_alt == 1], {[3] call processSWChannelKeys}, "keydown", "6"] call CBA_fnc_addKeyHandler;
	[sw_channel_5_scancode, [sw_channel_5_shift == 1, sw_channel_5_ctrl == 1, sw_channel_5_alt == 1], {[4] call processSWChannelKeys}, "keydown", "7"] call CBA_fnc_addKeyHandler;
	[sw_channel_6_scancode, [sw_channel_6_shift == 1, sw_channel_6_ctrl == 1, sw_channel_6_alt == 1], {[5] call processSWChannelKeys}, "keydown", "8"] call CBA_fnc_addKeyHandler;
	[sw_channel_7_scancode, [sw_channel_7_shift == 1, sw_channel_7_ctrl == 1, sw_channel_7_alt == 1], {[6] call processSWChannelKeys}, "keydown", "9"] call CBA_fnc_addKeyHandler;
	[sw_channel_8_scancode, [sw_channel_8_shift == 1, sw_channel_8_ctrl == 1, sw_channel_8_alt == 1], {[7] call processSWChannelKeys}, "keydown", "10"] call CBA_fnc_addKeyHandler;	

	[tangent_lr_scancode, [tangent_lr_shift == 1, tangent_lr_ctrl == 1, tangent_lr_alt == 1], {call onLRTangentPressed}, "keydown", "11"] call CBA_fnc_addKeyHandler;
	[tangent_lr_scancode, [tangent_lr_shift == 1, tangent_lr_ctrl == 1, tangent_lr_alt == 1], {call onLRTangentReleased}, "keyup", "_11"] call CBA_fnc_addKeyHandler;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call onLRTangentReleasedHack"];
	["player", [[dialog_lr_scancode, [dialog_lr_shift == 1, dialog_lr_ctrl == 1, dialog_lr_alt == 1]]], -3, '_this call lrRadioMenu'] call CBA_fnc_flexiMenu_Add;

	[lr_channel_1_scancode, [lr_channel_1_shift == 1, lr_channel_1_ctrl == 1, lr_channel_1_alt == 1], {[0] call processLRChannelKeys}, "keydown", "13"] call CBA_fnc_addKeyHandler;
	[lr_channel_2_scancode, [lr_channel_2_shift == 1, lr_channel_2_ctrl == 1, lr_channel_2_alt == 1], {[1] call processLRChannelKeys}, "keydown", "14"] call CBA_fnc_addKeyHandler;
	[lr_channel_3_scancode, [lr_channel_3_shift == 1, lr_channel_3_ctrl == 1, lr_channel_3_alt == 1], {[2] call processLRChannelKeys}, "keydown", "15"] call CBA_fnc_addKeyHandler;
	[lr_channel_4_scancode, [lr_channel_4_shift == 1, lr_channel_4_ctrl == 1, lr_channel_4_alt == 1], {[3] call processLRChannelKeys}, "keydown", "16"] call CBA_fnc_addKeyHandler;
	[lr_channel_5_scancode, [lr_channel_5_shift == 1, lr_channel_5_ctrl == 1, lr_channel_5_alt == 1], {[4] call processLRChannelKeys}, "keydown", "17"] call CBA_fnc_addKeyHandler;
	[lr_channel_6_scancode, [lr_channel_6_shift == 1, lr_channel_6_ctrl == 1, lr_channel_6_alt == 1], {[5] call processLRChannelKeys}, "keydown", "18"] call CBA_fnc_addKeyHandler;
	[lr_channel_7_scancode, [lr_channel_7_shift == 1, lr_channel_7_ctrl == 1, lr_channel_7_alt == 1], {[6] call processLRChannelKeys}, "keydown", "19"] call CBA_fnc_addKeyHandler;
	[lr_channel_8_scancode, [lr_channel_8_shift == 1, lr_channel_8_ctrl == 1, lr_channel_8_alt == 1], {[7] call processLRChannelKeys}, "keydown", "20"] call CBA_fnc_addKeyHandler;	
	[lr_channel_9_scancode, [lr_channel_9_shift == 1, lr_channel_9_ctrl == 1, lr_channel_9_alt == 1], {[8] call processLRChannelKeys}, "keydown", "21"] call CBA_fnc_addKeyHandler;	

	[tangent_dd_scancode, [tangent_dd_shift == 1, tangent_dd_ctrl == 1, tangent_dd_alt == 1], {call onDDTangentReleased}, "keyup", "_22"] call CBA_fnc_addKeyHandler;
	[tangent_dd_scancode, [tangent_dd_shift == 1, tangent_dd_ctrl == 1, tangent_dd_alt == 1], {call onDDTangentPressed}, "keydown", "22"] call CBA_fnc_addKeyHandler;
	(findDisplay 46) displayAddEventHandler ["keyUp", "_this call onDDTangentReleasedHack"];
	[dialog_dd_scancode, [dialog_dd_shift == 1, dialog_dd_ctrl == 1, dialog_dd_alt == 1], {call onDDDialogOpen}, "keydown", "23"] call CBA_fnc_addKeyHandler;

	[speak_volume_scancode, [speak_volume_shift == 1, speak_volume_ctrl == 1, speak_volume_alt == 1], {call onSpeakVolumeChange}, "keydown", "24"] call CBA_fnc_addKeyHandler;
	
	

		
		
	_prev_result = "OK";

	while {true} do {
		if (isMultiplayer) then {
			{		
				if (isPlayer _x) then {
					_request = [_x] call preparePositionCoordinates;
					_result = "task_force_radio_pipe" callExtension _request;
					if (_result != "OK") then 
					{
						hintSilent _result;			
					} else {
						if (_prev_result != "OK") then {
							hintSilent "";
						}
					};
					_prev_result = _result;
				};
			} forEach allUnits;
		};
		sleep 0.2;
		// send current sw freq
		if (isMultiplayer) then {
			_freq = ["No_SW_Radio"];
			_freq_lr = ["No_LR_Radio"];
			_freq_dd = "No_DD_Radio";
			if ((call haveSWRadio) and ([player] call canUseSWRadio)) then {
				_freq = [];
				{
					_freq set[count _freq, format ["%1@%2", _x call getSwFrequency, _x call getSwVolume]];
				} forEach (call radiosList);
			};
			if ((call haveLRRadio) and ([player] call canUseLRRadio)) then {
				_freq_lr = [];
				{
					_freq_lr set[count _freq_lr, format ["%1@%2", _x call getLrFrequency, _x call getLrVolume]];
				} forEach (call lrRadiosList);
				_freq_lr = call currentLRFrequency;
			};
			if ((call haveDDRadio) and ([player] call canUseDDRadio)) then {
				_freq_dd = dd_frequency;
			};
			_alive = alive player;
			_nickname = name player;
			_request = format["FREQ@%1@%2@%3@%4@%5@%6@%7@%8@%9", str(_freq), str(_freq_lr), _freq_dd, _alive, speak_volume_level, lr_volume_level, dd_volume_level, _nickname, waves];
			_result = "task_force_radio_pipe" callExtension _request;
		};
		_request = format["VERSION@%1", ADDON_VERSION];
		_result = "task_force_radio_pipe" callExtension _request;
	}
};

radiosList = 
{
	_result = [];
	{	
		if (_x call isRadio) then 
		{
			_result set[count _result, _x];
		};
	} forEach (assignedItems player);

	{
		if (_x call isRadio) then 
		{
			_result set[count _result, _x];
		};
	} forEach (items player);
	_result;
};

vehicleLr = 
{
	private ["_result"];
	_result = [];
	if ((vehicle player) != player) then {
		if (gunner (vehicle player) == player) then {
			_result = [vehicle player, "gunner_radio_settings"];
		};
		if (driver (vehicle player) == player) then {
			_result = [vehicle player, "driver_radio_settings"];
		};
		if (commander (vehicle player) == player) then {
			_result = [vehicle player, "commander_radio_settings"];
		};
		if ((vehicle player) turretUnit [0] == player) then {
			_result = [vehicle player, "turretUnit_0_radio_setting"];
		};
	};
	_result;
};

backpackLr = 
{
	private ["_result"];
	_result = [];
	if ((backpack player == "tf_rt1523g") or {backpack player == "tf_anprc155"}) then {
		_result = [unitBackpack player, "radio_settings"];
	};
	_result;
};


lrRadiosList = 
{
	private ["_result", "_active_lr", "_vehicle_lr", "_backpack_lr"];
	_result = [];
	_active_lr = nil;
	if (!isNil "lr_active_radio") then {
		_active_lr = lr_active_radio;
	};
	_vehicle_lr = call vehicleLr;
	_backpack_lr = call backpackLr;

	if (!(isNil "_active_lr") and {(count _vehicle_lr > 0)} and {(_active_lr select 0) == (_vehicle_lr select 0)} and {(_active_lr select 1) == (_vehicle_lr select 1)}) then {
		_result set [count _result, _active_lr];
		if (count _backpack_lr > 0) then {
			_result set [count _result, _backpack_lr];
		};
	} else {
		if (count _backpack_lr > 0) then {
			_result set [count _result, _backpack_lr];
		};
		if (count _vehicle_lr > 0) then {
			_result set [count _result, _vehicle_lr];
		};
	};

	_result;	
};

radioToRequestCount = 
{
	_result = 0;
	_to_remove = [];

	{	
		if (("ItemRadio" == _x) or (_x call isRadio)) then 
		{
			_to_remove set[_result, _x];
			_result = _result + 1;
		};
	} forEach (assignedItems player);

	{
		if (("ItemRadio" == _x) or (_x call isRadio)) then 
		{
			_to_remove set[_result, _x];
			_result = _result + 1;
		};
	} forEach (items player);
	{
		player unassignItem _x;
		player removeItem _x;
	} forEach _to_remove;
	_result;
};

processRespawn =
{
	[] spawn {	
		waitUntil {!(isNull player)};	
		if (alive player) then
		{
			if (leader player == player) then {		
				if (backpack player != "tf_rt1523g") then {
					player action ["putbag", player];
					sleep 3;
					if (side player == west) then {
						player addBackpack "tf_rt1523g";
					} else {
						player addBackpack "tf_anprc155";
					};
				};
			};
			_variableName = "radio_request_" + (getPlayerUID player) + str (side player);
			_radio_count = call radioToRequestCount;
			missionNamespace setVariable [_variableName, _radio_count];
			_responseVariableName = "radio_response_" + (getPlayerUID player) + str (side player);
			 missionNamespace setVariable [_responseVariableName, nil];
			publicVariableServer _variableName;
			titleText [localize ("STR_wait_radio"), "PLAIN"];
			waitUntil {!(isNil _responseVariableName)};
			_response = missionNamespace getVariable _responseVariableName;	
			{
				player addItem _x;
			} forEach _response;
			if (count _response > 0) then 
			{
				player assignItem (_response select 0);
			};
			titleText ["", "PLAIN"];
						
		};
	};
};


player addEventHandler ["respawn", {call processRespawn}];
call processRespawn;


