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
};

disableSerialization;
#include "diary.sqf"

waitUntil {time > 0};
waitUntil {!(isNull player)};
titleText [localize ("STR_init"), "PLAIN"];

#include "define.h"
#include "vehicles.sqf"

#define SHIFTL 42
#define CTRLL 29
#define ALTL 56
#define ACTIVE_CHANNEL_OFFSET 0
#define VOLUME_OFFSET 1


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

getSwRadioCode = 
{
	private ["_result"];
	_result = "";
	if (([_this, "tf_anprc152_"] call CBA_fnc_find) == 0) then {
		_result = tf_west_radio_code;
	};
	if (([_this, "tf_anprc148jem_"] call CBA_fnc_find) == 0) then {
		_result = tf_guer_radio_code;
	};
	if (([_this, "tf_fadak_"] call CBA_fnc_find) == 0) then {
		_result = tf_east_radio_code;
	};
	_result;
};

getLrRadioCode = 
{
	private ["_radio_object", "_result"];
	_radio_object = _this select 0;
	_result = "";
	if ((_radio_object) isKindOf "Bag_Base") then {				
		if (typeOf(_radio_object) == "tf_rt1523g") then {
			_result = tf_west_radio_code;
		};
		if (typeOf(_radio_object) == "tf_anprc155") then {
			_result = tf_guer_radio_code;
		};
		if (typeOf(_radio_object) == "tf_mr3000") then {
			_result = tf_east_radio_code;
		};
	} else {
		if (((_radio_object) call tfr_getVehicleSide) == west) then {
			_result = tf_west_radio_code;
		};
		if (((_radio_object) call tfr_getVehicleSide) == resistance) then {
			_result = tf_guer_radio_code;
		};
		if (((_radio_object) call tfr_getVehicleSide) == east) then {
			_result = tf_east_radio_code;
		};
	};
	_result;
};

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
	private ["_settings"];
	_settings = _this call getSwSettings;
	_settings select ACTIVE_CHANNEL_OFFSET;
};

getLrChannel = 
{
	private ["_settings"];
	_settings = _this call getLrSettings;
	_settings select ACTIVE_CHANNEL_OFFSET;
	
};

setSwChannel = 
{
	private ["_settings", "_radio_id", "_channel_to_set"];
	_radio_id = _this select 0;
	_channel_to_set = _this select 1;
	_settings = _radio_id call getSwSettings;
	_settings set [ACTIVE_CHANNEL_OFFSET, _channel_to_set];
	[_radio_id, _settings] call setSwSetting;
};


setLrChannel = 
{
	private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	_settings = [_radio_object, _radio_qualifier] call getLrSettings;
	_settings set [ACTIVE_CHANNEL_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call setLrSettings;
};


getSwFrequency = 
{
	private ["_settings"];
	_settings = _this call getSwSettings;
	_settings select (FREQ_OFFSET + (_settings select ACTIVE_CHANNEL_OFFSET));
};

getLrFrequency = 
{
	private ["_settings"];
	_settings = _this call getLrSettings;
	_settings select (FREQ_OFFSET + (_settings select ACTIVE_CHANNEL_OFFSET));
};

setSwVolume = 
{
	private ["_settings", "_radio_id", "_value"];
	_radio_id = _this select 0;
	_value = _this select 1;
	_settings = _radio_id call getSwSettings;
	_settings set [VOLUME_OFFSET, _value];
	[_radio_id, _settings] call setSwSetting;
};

setLrVolume = 
{
	private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	_settings = [_radio_object, _radio_qualifier] call getLrSettings;
	_settings set [VOLUME_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call setLrSettings;
};

getSwVolume =
{
	private ["_settings"];
	_settings = _this call getSwSettings;
	_settings select VOLUME_OFFSET;
};

getLrVolume = 
{	
	private ["_settings"];
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
	private ["_radio_object", "_radio_qualifier", "_value", "_settings"];
	_radio_object = _this select 0;
	_radio_qualifier = _this select 1;
	_value = _this select 2;
	
	_settings = [_radio_object, _radio_qualifier] call getLrSettings;
	_settings set [(_settings select ACTIVE_CHANNEL_OFFSET) + FREQ_OFFSET, _value];
	[_radio_object, _radio_qualifier, _settings] call setLrSettings;
};

getSwSettings = 
{
	private ["_variableName", "_value", "_preset"];
	_variableName = format["%1_settings", _this];
	_value = missionNamespace getVariable _variableName;
	if (isNil "_value") then {
		if (!(use_saved_sw_setting) or (isNil "saved_active_sw_settings")) then {		
			_value = (group player) getVariable "tf_sw_frequency";
			if (isNil "_value") then {
				_value = call generateSwSetting;
			};			
		} else {
			_value = saved_active_sw_settings;
		};
		if (use_saved_sw_setting) then {
			use_saved_sw_setting = false;
		};
		[_this, + _value] call setSwSetting;
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
		if (!(use_saved_lr_setting) or (isNil "saved_active_lr_settings")) then {
			_value = (group player) getVariable "tf_lr_frequency";
			if (isNil "_value") then {
				_value = call generateLrSettings;			
			};
		} else {
			_value = saved_active_lr_settings;
		};
		if (use_saved_lr_setting) then {
			use_saved_lr_setting = false;
		};
		[_radio_object, _radio_qualifier, + _value] call setLrSettings;
	};
	_value;
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

	if ((call haveSWRadio) and {alive player}) then {		
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

	if ((call haveLRRadio) and {alive player}) then {
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
	private ["_depth", "_depthText"];
	ctrlSetText [IDC_DIVER_RADIO_EDIT_ID, dd_frequency];
	_depth = round (((eyepos player) select 2) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER;
	_depthText =  format["%1m", _depth];
	ctrlSetText [IDC_DIVER_RADIO_DEPTH_ID, _depthText];
};
updateSWDialogToChannel = 
{
	private ["_channelText"];
	ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT, sw_dialog_radio call getSwFrequency];
	_channelText =  format["C%1", (sw_dialog_radio call getSwChannel) + 1];
	ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_CHANNEL_EDIT, _channelText];
};
updateLRDialogToChannel = 
{
	private ["_channelText"];
	ctrlSetText [IDC_RT1523G_RADIO_DIALOG_EDIT, lr_dialog_radio call getLrFrequency];
	_channelText =  format["CH: %1", (lr_dialog_radio call getLrChannel) + 1];
	ctrlSetText [IDC_RT1523G_RADIO_DIALOG_CHANNEL_EDIT, _channelText];
};
eyeDepth = 
{	
	((eyepos _this) select 2) + ((getPosASLW _this) select 2) - ((getPosASL _this) select 2);
};

vehicleIsIsolatedAndInside = 
{
	private ["_result"];
	_result = false;
	if (vehicle _this != _this) then {
		if ((vehicle _this) call tfr_isVehicleIsolated) then {
			if !([_this] call CBA_fnc_isTurnedOut) then {
				_result = true;
			};
		};
	};
	_result;
};

canSpeak = 
{
	private ["_result", "_player", "_isolated_and_inside"];

	_result = false;
	_player = _this select 0;
	_isolated_and_inside = _this select 1;

	if ((_player call eyeDepth) > 0) then {
		_result = true;
	} else {
		_result = _isolated_and_inside;
	};
	_result;

};
canUseSWRadio =
{
	private ["_player", "_isolated_and_inside", "_result", "_depth"];

	_result = false;
	_player = _this select 0;
	_depth = _player call eyeDepth;

	if (_depth > 0) then {
		_result = true;
	} else {
		if ((_this select 2) and {_depth > -1} and {vehicle _player != _player}) then {
			if ((_this select 1) or {isAbleToBreathe _player}) then {
				_result = true;
			};
		};
	};
	_result;
};
canUseLRRadio =
{
	private ["_player", "_isolated_and_inside", "_result", "_depth"];

	_player = _this select 0;
	_isolated_and_inside = _this select 1;
	_depth = _player call eyeDepth;
	_result = false;

	if (_depth > 0) then {
		_result = true;
	} else {
		if ((vehicle _player != _player) and {_depth > -3}) then {
			if ((_isolated_and_inside) or {isAbleToBreathe _player}) then {
				_result = true;
			};
		};
	};

	_result;
};
canUseDDRadio =
{
	private ["_player", "_isolated_and_inside"];

	_player = _this select 0;
	_isolated_and_inside = _this select 1;

	((_player call eyeDepth) < 0) and !(_isolated_and_inside);
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
	private["_result", "_request", "_hintText"];
	if (!(tangent_sw_pressed) and {alive player} and {call haveSWRadio}) then {
		if ([player, player call vehicleIsIsolatedAndInside, [player, player call vehicleIsIsolatedAndInside] call canSpeak] call canUseSWRadio) then { 
			_hintText = format[localize "STR_transmit_sw", call currentSWFrequency];
			hintSilent parseText (_hintText);
			_request = format["TANGENT@PRESSED@%1%2",call currentSWFrequency, (call activeSwRadio) call getSwRadioCode];
			if (isMultiplayer) then {
				_result = "task_force_radio_pipe" callExtension _request;
			};
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
		_request = format["TANGENT@RELEASED@%1%2",call currentSWFrequency, (call activeSwRadio) call getSwRadioCode];
		if (isMultiplayer) then {
			_result = "task_force_radio_pipe" callExtension _request;
		};
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
			if (([sw_dialog_radio, "tf_fadak_"] call CBA_fnc_find) == 0) then {
				createDialog "fadak_radio_dialog";
			};

			call updateSWDialogToChannel;
		};
	};
	true;
};

onLRTangentPressed = 
{
	private["_result", "_request", "_hintText"];
	if (!(tangent_lr_pressed) and {alive player} and {call haveLRRadio}) then {
		if ([player, player call vehicleIsIsolatedAndInside] call canUseLRRadio) then {
			_hintText = format[localize "STR_transmit_lr", call currentLRFrequency];
			hintSilent parseText (_hintText);
			_request = format["TANGENT_LR@PRESSED@%1%2", call currentLRFrequency, (call activeLrRadio) call getLrRadioCode];
			if (isMultiplayer) then {
				_result = "task_force_radio_pipe" callExtension _request;
			};
			tangent_lr_pressed = true;
		} else {
			call inWaterHint;
		}
	};
	true;
};

onLRTangentReleased = 
{
	private["_result", "_request"];	
	if ((tangent_lr_pressed) and {alive player}) then {
		hintSilent "";
		_request = format["TANGENT_LR@RELEASED@%1%2", call currentLRFrequency, (call activeLrRadio) call getLrRadioCode];
		if (isMultiplayer) then {
			_result = "task_force_radio_pipe" callExtension _request;
		};
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
	false;
};

onLRDialogOpen = 
{
	private ["_dialog_to_open"];
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
					if (typeOf(lr_dialog_radio select 0) == "tf_mr3000") then {
						_dialog_to_open = "mr3000_radio_dialog";
					};
				} else {
					if (((lr_dialog_radio select 0) call tfr_getVehicleSide) == west) then {
						_dialog_to_open = "rt1523g_radio_dialog";
					};
					if (((lr_dialog_radio select 0) call tfr_getVehicleSide) == resistance) then {
						_dialog_to_open = "anprc155_radio_dialog";
					};
					if (((lr_dialog_radio select 0) call tfr_getVehicleSide) == east) then {
						_dialog_to_open = "mr3000_radio_dialog";
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
	private["_result", "_request", "_hintText"];
	if (!(tangent_dd_pressed) and {alive player} and {call haveDDRadio}) then {
		if ([player, player call vehicleIsIsolatedAndInside] call canUseDDRadio) then { 
			_hintText = format[localize "STR_transmit_dd", dd_frequency];
			hintSilent parseText (_hintText);
			_request = format["TANGENT_DD@PRESSED@%1", dd_frequency];
			if (isMultiplayer) then {
				_result = "task_force_radio_pipe" callExtension _request;
			};
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
		if (isMultiplayer) then {
			_result = "task_force_radio_pipe" callExtension _request;
		};
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
	false;
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

vehicleId = 
{
	private["_result"];
	_result = "no";
	if (((vehicle _this) != _this) and {(vehicle _this) call tfr_isVehicleIsolated}) then {
		_result = netid (vehicle _this);
		if (_result == "") then {
			_result = "singleplayer";
		};
		if ([_this] call CBA_fnc_isTurnedOut) then {
			_result = _result + "_turnout";
		};
	};
	_result;
};


preparePositionCoordinates = 		
{
	private ["_x_player", "_current_eyepos", "_x_playername", "_current_x", "_current_y", "_current_z", "_current_look_at_x", "_current_look_at_y", "_current_look_at_z", "_current_hyp_horizontal", "_current_rotation_horizontal", "_player_pos", "_isolated_and_inside", "_can_speak"];
	_x_player = _this;
	_current_eyepos = eyepos _x_player;
	_x_playername = name _x_player;

	_current_x = (_current_eyepos select 0);
	_current_y = (_current_eyepos select 1);
	_current_z = (_current_eyepos select 2);

	_current_look_at = screenToWorld [0.5,0.5];
	_current_look_at_x = (_current_look_at select 0) - _current_x;
	_current_look_at_y = (_current_look_at select 1) - _current_y;
	_current_look_at_z = (_current_look_at select 2) - _current_z;

	_isolated_and_inside = _x_player call vehicleIsIsolatedAndInside;

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
	_can_speak = [_x_player, _isolated_and_inside] call canSpeak;
	(format["POS@%1@%2@%3@%4@%5@%6@%7@%8@%9@%10", _x_playername, _current_x, _current_y, _current_z, _current_rotation_horizontal, _can_speak, [_x_player, _isolated_and_inside, _can_speak] call canUseSWRadio, [_x_player, _isolated_and_inside] call canUseLRRadio, [_x_player, _isolated_and_inside] call canUseDDRadio,  _x_player call vehicleId]);
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
	private ["_radios", "_found"];
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
	private ["_submenu"];
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
	private ["_menuDef", "_positions", "_active_radio", "_submenu", "_command"];
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
	private ["_submenu"];
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

	private ["_menuDef", "_positions", "_active_radio", "_submenu", "_command", "_pos"];
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
		if (call haveLRRadio) then {
			lr_dialog_radio = call activeLrRadio;
			call onLrDialogOpen;
		};
		nil;
	};
};

tf_lastFrameTick = diag_tickTime;
tf_msPerStep = 0;

tf_nearPlayers = [];
tf_farPlayers = [];

tf_nearPlayersIndex = 0;
tf_nearPlayersProcessed = true;

tf_farPlayersIndex = 0;
tf_farPlayersProcessed = true;

tf_msPerStep = 0.035;
tf_processingCounter = 0;

tf_lastFrequencyInfoTick = 0;
tf_lasNearPlayersUpdate = 0;

tf_lastError = false;

tf_fastProcessingCoeff = 0;

tf_sendFrequencyInfo = 
{
	private ["_request", "_result", "_freq", "_freq_lr", "_freq_dd", "_alive", "_nickname", "_isolated_and_inside", "_can_speak", "_elemsToProcess"];

	// send frequencies
	_freq = ["No_SW_Radio"];
	_freq_lr = ["No_LR_Radio"];
	_freq_dd = "No_DD_Radio";

	_isolated_and_inside = player call vehicleIsIsolatedAndInside;
	_can_speak = [player, _isolated_and_inside] call canSpeak;

	if ((call haveSWRadio) and {[player, _isolated_and_inside, _can_speak] call canUseSWRadio}) then {
		_freq = [];
		{
			_freq set[count _freq, format ["%1%2|%3", _x call getSwFrequency, _x call getSwRadioCode, _x call getSwVolume]];
		} forEach (call radiosList);
	};
	if ((call haveLRRadio) and {[player, _isolated_and_inside] call canUseLRRadio}) then {
		_freq_lr = [];
		{
			_freq_lr set[count _freq_lr, format ["%1%2|%3", _x call getLrFrequency, _x call getLrRadioCode, _x call getLrVolume]];
		} forEach (call lrRadiosList);				
	};
	if ((call haveDDRadio) and {[player, _isolated_and_inside] call canUseDDRadio}) then {
		_freq_dd = dd_frequency;
	};
	_alive = alive player;
	_nickname = name player;
	_request = format["FREQ@%1@%2@%3@%4@%5@%6@%7@%8@", str(_freq), str(_freq_lr), _freq_dd, _alive, speak_volume_level, dd_volume_level, _nickname, waves];
	_result = "task_force_radio_pipe" callExtension _request;
};

tf_getNearPlayers = 
{
	private ["_result", "_index", "_players_in_group", "_add_to_near"];
	_players_in_group = count (units (group player));
	_result = [];
	_index = 0;
	{			
		if (isPlayer _x) then {
			_add_to_near = false;
			if ((_players_in_group < 10) and {group player == group _x}) then {
				_add_to_near = true; 
			};

			_was_speaking = _x getVariable "tf_start_speaking";
			if (!(isNil "_was_speaking") and {diag_tickTime - _was_speaking < 20}) then {
				_add_to_near = true;
			};

			if ((player distance _x < 60) or {_add_to_near}) then {				
				_result set[_index, _x];
				_index = _index + 1;
			} 
		};
	} count allUnits;
	_result;
};

sendVersionInfo = 
{
	// send information about version
	_request = format["VERSION@%1@%2@%3", TF_ADDON_VERSION, tf_radio_channel_name, tf_radio_channel_password];
	_result = "task_force_radio_pipe" callExtension _request;
};

processPlayerPositions =
{
	private ["_request", "_result", "_elemsToProcess", "_other_units"];
	if !(isNull player) then {
		if ((tf_farPlayersProcessed) and {tf_nearPlayersProcessed}) then {
			tf_nearPlayersIndex = 0;
			tf_farPlayersIndex = 0;
	
			tf_nearPlayers = call tf_getNearPlayers;		
			_other_units = allUnits - tf_nearPlayers;
	
			tf_farPlayers = [];
			tf_farPlayersIndex = 0;	
			{
				if (isPlayer _x) then {
					tf_farPlayers set[tf_farPlayersIndex, _x];
					tf_farPlayersIndex = tf_farPlayersIndex + 1;
				};
			} count _other_units;
	
			tf_fastProcessingCoeff = 0;
			if (count tf_farPlayers < count tf_nearPlayers) then {
				tf_fastProcessingCoeff = 1;
			};
				
			tf_nearPlayersIndex = 0;
			tf_farPlayersIndex = 0;	
	
			if (count tf_farPlayers > 0) then {
				tf_farPlayersProcessed = false;
			};
			if (count tf_nearPlayers > 0) then {
				tf_nearPlayersProcessed = false;
			};
			call sendVersionInfo;
		} else {
			_elemsToProcess = (diag_tickTime - tf_lastFrameTick) / tf_msPerStep;
			if (_elemsToProcess >= 1) then {
				for "_y" from 0 to _elemsToProcess step 1 do {
					private ["_xplayer"];				
					if ((tf_processingCounter % 3 > tf_fastProcessingCoeff) and {count tf_farPlayers > 0}) then {
						_xplayer = tf_farPlayers select tf_farPlayersIndex;
						tf_farPlayersIndex = tf_farPlayersIndex + 1;
						if (tf_farPlayersIndex >= count tf_farPlayers) then {
							tf_farPlayersIndex = 0;
							tf_farPlayersProcessed = true;
						};
					} else {
						if (count tf_nearPlayers > 0) then {
							_xplayer = tf_nearPlayers select tf_nearPlayersIndex;
							tf_nearPlayersIndex = tf_nearPlayersIndex + 1;
							if (tf_nearPlayersIndex >= count tf_nearPlayers) then {
								tf_nearPlayersIndex = 0;							
								tf_nearPlayersProcessed = true;		
								if (diag_tickTime - tf_lastNearPlayersUpdate > 0.5) then {	
									tf_nearPlayers = call tf_getNearPlayers;
									tf_lastNearPlayersUpdate = diag_tickTime;
								};
	
							};
						};
					};
															
					
					_request = _xplayer call preparePositionCoordinates;
					_result = "task_force_radio_pipe" callExtension _request;
		
					if ((_result != "OK") and {_result != "SPEAKING"} and {_result != "NOT_SPEAKING"}) then 
					{
						hintSilent _result;
						tf_lastError = true;
					} else {
						if (tf_lastError) then {
							hintSilent "";
							tf_lastError = false;
						};
					};
					if (_result == "SPEAKING") then {
						_xplayer setRandomLip true;
						_xplayer setVariable ["tf_start_speaking", diag_tickTime];
					} else {
						_xplayer setRandomLip false;
					};								
	
					tf_processingCounter = tf_processingCounter + 1;
				};
				
				tf_lastFrameTick = diag_tickTime;
			};
		};
		if (diag_tickTime - tf_lastFrequencyInfoTick > 1) then {
			call tf_sendFrequencyInfo;
			tf_lastFrequencyInfoTick = diag_tickTime;
		};
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

	if (isMultiplayer) then {
		call sendVersionInfo;
		["processPlayerPositionsHandler", "onEachFrame", "processPlayerPositions"] call BIS_fnc_addStackedEventHandler;
	};
};

radiosList = 
{
	private ["_result"];
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
	if (((vehicle player) != player) and {(vehicle player) call tfr_hasVehicleRadio}) then {
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
	if ((backpack player == "tf_rt1523g") or {backpack player == "tf_anprc155"} or {backpack player == "tf_mr3000"}) then {
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
	private ["_result", "_to_remove", "_allRadios"];
	_result = 0;
	_to_remove = [];
	_allRadios = _this;

	{	
		if (("ItemRadio" == _x) or ((_x call isRadio) and _allRadios)) then 
		{
			_to_remove set[_result, _x];
			_result = _result + 1;
		};
	} forEach (assignedItems player);

	{
		if (("ItemRadio" == _x) or ((_x call isRadio) and _allRadios)) then 
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

first_radio_request = true;
last_request_time = 0;

requestRadios = 
{
	private ["_radio_count", "_variableName", "_responseVariableName", "_response"];

	waitUntil {
		if (!radio_request_mutex) exitWith {radio_request_mutex = true; true};
		false;
	};
	if (time - last_request_time > 3) then {
		last_request_time = time;
		_variableName = "radio_request_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
		_radio_count = _this call radioToRequestCount;
	
		if (_radio_count > 0) then {
			missionNamespace setVariable [_variableName, _radio_count];
			_responseVariableName = "radio_response_" + (getPlayerUID player) + str (player call BIS_fnc_objectSide);
			 missionNamespace setVariable [_responseVariableName, nil];
			publicVariableServer _variableName;
			titleText [localize ("STR_wait_radio"), "PLAIN"];
			waitUntil {!(isNil _responseVariableName)};
			_response = missionNamespace getVariable _responseVariableName;	
			{
				player addItem _x;
			} forEach _response;
			if ((count _response > 0) and (first_radio_request)) then 
			{
				first_radio_request = false;
				player assignItem (_response select 0);
			};
			titleText ["", "PLAIN"];
		};
		last_request_time = time;
	};
	radio_request_mutex = false;
};

radioReplaceProcess = 
{
	private ["_currentPlayerFlag", "_active_sw_radio", "_active_lr_radio"];
	while {true} do {
		if !(use_saved_sw_setting) then {
			if ((alive player) and (call haveSWRadio)) then {
				_active_sw_radio = call activeSwRadio;
				if !(isNil "_active_sw_radio") then {
					saved_active_sw_settings = _active_sw_radio call getSwSettings;
				} else {
					saved_active_sw_settings = nil;	
				};
			} else {
				saved_active_sw_settings = nil;	
			};
		};

		if !(use_saved_lr_setting) then {
			if ((alive player) and (call haveLRRadio)) then {
				_active_lr_radio = call activeLrRadio;
				if !(isNil "_active_lr_radio") then {
					saved_active_lr_settings = _active_lr_radio call getLrSettings;
				} else {
					saved_active_lr_settings = nil;	
				};
			} else {
				saved_active_lr_settings = nil;	
			};
		};

		sleep 2;
		if ((time - respawnedAt > 10) and (alive player)) then {
			false call requestRadios;
		};
		if !(isNull player) then {
			_currentPlayerFlag = player getVariable "tf_force_radio_active";
			if (isNil "_currentPlayerFlag") then {
				player setVariable ["tf_force_radio_active", TF_ADDON_VERSION, true];
			};
		}
	};
};

processRespawn =
{
	[] spawn {	
		waitUntil {!(isNull player)};	
		
		respawnedAt = time;
		if (alive player) then
		{
			if (leader player == player) then {	
				if ((isNil "tf_no_auto_long_range_radio") and {backpack player != "B_Parachute"}) then {
					if ((backpack player != "tf_rt1523g") and {backpack player != "tf_anprc155"} and {backpack player != "tf_mr3000"}) then {
						player action ["putbag", player];
						sleep 3;
						if ((player call BIS_fnc_objectSide) == west) then {
							player addBackpack "tf_rt1523g";
						} else {
							if ((player call BIS_fnc_objectSide) == east) then {
								player addBackpack "tf_mr3000";	
							} else {
								player addBackpack "tf_anprc155";
							};
						};
					};
				};
			};
			true call requestRadios;						
		};
	};
};

player addEventHandler ["respawn", {call processRespawn}];
player addEventHandler ["killed", {use_saved_sw_setting = true; use_saved_lr_setting = true; first_radio_request = true;}];
call processRespawn;

respawnedAt = time;

[] spawn {
	waitUntil {!(isNull player)};
	sleep 5;
	call radioReplaceProcess;
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


