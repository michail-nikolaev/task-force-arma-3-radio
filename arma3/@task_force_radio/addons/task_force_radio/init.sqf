disableSerialization;
#include "diary.sqf"
#include "\task_force_radio\define.h"
#define SHIFTL 42
#define CTRLL 29
#define ALTL 56

ADDON_VERSION = "0.7.0 beta";

MIN_SW_FREQ = 30;
MAX_SW_FREQ = 512;

MAX_SW_VOLUME = 10;
MAX_LR_VOLUME = 10;
MAX_DD_VOLUME = 10;

sw_volume_level = 7;
lr_volume_level = 7;
dd_volume_level = 7;

MIN_ASIP_FREQ = 30;
MAX_ASIP_FREQ = 87;

MIN_DD_FREQ = 32;
MAX_DD_FREQ = 41;

FREQ_ROUND_POWER = 10;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_RADIO_DIALOG_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDC_ANPRC152_RADIO_DIALOG;

IDC_RT1523G_RADIO_DIALOG_EDIT_ID = IDC_RT1523G_RADIO_DIALOG_EDIT;
IDC_RT1523G_RADIO_DIALOG_ID = IDC_RT1523G_RADIO_DIALOG;

IDC_DIDER_RADIO_DIALOG_ID = IDC_DIVER_RADIO_DIALOG;
IDC_DIVER_RADIO_EDIT_ID = IDC_DIVER_RADIO_EDIT;
IDC_DIVER_RADIO_DEPTH_ID = IDC_DIVER_RADIO_DEPTH;

MAX_CHANNELS = 8;
sw_frequencies = [0, 0, 0, 0, 0, 0, 0, 0];
for "_i" from 0 to (count sw_frequencies) step 1 do {
	sw_frequencies set [_i, (str (round (((random (MAX_SW_FREQ - MIN_SW_FREQ)) + MIN_SW_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER))];
};
sw_active_channel = 0;

MAX_LR_CHANNELS = 9;
lr_frequencies = [0, 0, 0, 0, 0, 0, 0, 0, 0];
for "_i" from 0 to (count lr_frequencies) step 1 do {
	lr_frequencies set [_i, str (round (((random (MAX_ASIP_FREQ - MIN_ASIP_FREQ)) + MIN_ASIP_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER)];
};
lr_active_channel = 0;

#include "keys.sqf"

tangent_sw_pressed = false;
tangent_lr_pressed = false;
tangent_dd_pressed = false;

dd_frequency = str (round (((random (MAX_DD_FREQ - MIN_DD_FREQ)) + MIN_DD_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER);

speak_volume_level = "normal";

[] spawn {
	hintSilent (localize "STR_waiting");	
	sleep 4;
	hintSilent "";

	haveSWRadio = 
	{
		("ItemRadio" in assignedItems player);
	};
	haveLRRadio = 
	{
		(backpack player == "tf_rt1523g") or ((vehicle player != player) and ((gunner (vehicle player) == player) or (driver (vehicle player) == player) or (commander (vehicle player) == player) or ((vehicle player) turretUnit [0] == player)));		
	};
	haveDDRadio = 
	{
		((vest player == "V_RebreatherIR") or (vest player == "V_RebreatherB") or (vest player == "V_RebreatherIA"));
	};
	processSWChannelKeys = 
	{		
		_scancode = _this select 0;
		_shift = _this select 1;
		_ctrl = _this select 2;
		_alt = _this select 3;
		_sw_channel_scancode = _this select 4;
		_sw_channel_shift = _this select 5;
		_sw_channel_ctrl = _this select 6;
		_sw_channel_alt = _this select 7;
		_sw_channel_number = _this select 8;

		if ((_scancode == _sw_channel_scancode) and (_shift == _sw_channel_shift) and (_ctrl == _sw_channel_ctrl) and (_alt == _sw_channel_alt)) then {
			sw_active_channel = _sw_channel_number;
			_hintText = format[localize "STR_active_sw_channel", sw_active_channel + 1];
			hint parseText (_hintText);
			if (dialog) then {
				call updateSWDialogToChannel;
			}			
		
		};

	};
	processLRChannelKeys = 
	{		
		_scancode = _this select 0;
		_shift = _this select 1;
		_ctrl = _this select 2;
		_alt = _this select 3;
		_lr_channel_scancode = _this select 4;
		_lr_channel_shift = _this select 5;
		_lr_channel_ctrl = _this select 6;
		_lr_channel_alt = _this select 7;
		_lr_channel_number = _this select 8;

		if ((_scancode == _lr_channel_scancode) and (_shift == _lr_channel_shift) and (_ctrl == _lr_channel_ctrl) and (_alt == _lr_channel_alt)) then {
			lr_active_channel = _lr_channel_number;
			_hintText = format[localize "STR_active_lr_channel", lr_active_channel + 1];
			hint parseText (_hintText);
			if (dialog) then {
				call updateLRDialogToChannel;
			}			
		
		};

	};
	currentSWFrequency = 
	{
		(sw_frequencies select sw_active_channel);
	};
	currentLRFrequency = 
	{
		(lr_frequencies select lr_active_channel);
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
		ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT, call currentSWFrequency];
		_channelText =  format["C%1", (sw_active_channel + 1)];
		ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_CHANNEL_EDIT, _channelText];
	};
	updateLRDialogToChannel = 
	{
		ctrlSetText [IDC_RT1523G_RADIO_DIALOG_EDIT, call currentLRFrequency];
		_channelText =  format["CH: %1", (lr_active_channel + 1)];
		ctrlSetText [IDC_RT1523G_RADIO_DIALOG_CHANNEL_EDIT, _channelText];
	};
	eyeDepth = { // _this - player
		((eyepos _this) select 2) + ((getPosASLW _this) select 2) - ((getPosASL _this) select 2);
	};

	canSpeak = { ((_this call eyeDepth) > 0); };

	canUseSWRadio =	{ ((_this call eyeDepth) > 0); };

	canUseLRRadio =	{
		_player = _this;
		(((_player call eyeDepth > 0)) 
			or ( 
				(vehicle _player != _player) and ((_player call eyeDepth) > -3) and (isAbleToBreathe _player)
			 ));
	};

	canUseDDRadio =	{ ((_this call eyeDepth) < 0); };

	inWaterHint = 
	{
		hintSilent parseText (localize "STR_in_water_hint");
	};
	onGroundHint = 
	{
		hintSilent parseText (localize "STR_on_ground_hint");
	};

	radio_keyDown =
	{
		private["_result", "_request", "_ctrl", "_scancode", "_shift", "_alt"];

		_scancode = _this select 1;		
		if (_this select 2 and _scancode != SHIFTL) then {_shift = 1} else {_shift = 0};
		if (_this select 3 and _scancode != CTRLL) then {_ctrl = 1} else {_ctrl = 0};
		if (_this select 4 and _scancode != ALTL) then {_alt = 1} else {_alt = 0};

		if (alive player) then {
			if (call haveSWRadio) then {
				if (!(tangent_sw_pressed) and (_scancode == tangent_sw_scancode) and (_shift == tangent_sw_shift) and (_ctrl == tangent_sw_ctrl) and (_alt == tangent_sw_alt)) then {
					if (player call canUseSWRadio) then { 
						_hintText = format[localize "STR_transmit_sw", call currentSWFrequency];
						hintSilent parseText (_hintText);
						_request = format["TANGENT@PRESSED@%1", call currentSWFrequency];
						_result = "task_force_radio_pipe" callExtension _request;
						tangent_sw_pressed = true;
					} else {
						call inWaterHint;
					}
				};
	
				if ((_scancode == dialog_sw_scancode) and (_shift == dialog_sw_shift) and (_ctrl == dialog_sw_ctrl) and (_alt == dialog_sw_alt)) then {
					if !(dialog) then {
						createDialog "anprc152_radio_dialog";
						call updateSWDialogToChannel;
					}
				};
				[_scancode, _shift, _ctrl, _alt, sw_channel_1_scancode, sw_channel_1_shift, sw_channel_1_ctrl, sw_channel_1_alt, 0] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_2_scancode, sw_channel_2_shift, sw_channel_2_ctrl, sw_channel_2_alt, 1] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_3_scancode, sw_channel_3_shift, sw_channel_3_ctrl, sw_channel_3_alt, 2] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_4_scancode, sw_channel_4_shift, sw_channel_4_ctrl, sw_channel_4_alt, 3] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_5_scancode, sw_channel_5_shift, sw_channel_5_ctrl, sw_channel_5_alt, 4] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_6_scancode, sw_channel_6_shift, sw_channel_6_ctrl, sw_channel_6_alt, 5] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_7_scancode, sw_channel_7_shift, sw_channel_7_ctrl, sw_channel_7_alt, 6] call processSWChannelKeys;
				[_scancode, _shift, _ctrl, _alt, sw_channel_8_scancode, sw_channel_8_shift, sw_channel_8_ctrl, sw_channel_8_alt, 7] call processSWChannelKeys;
			};
			if (call haveLRRadio) then {
				if (!(tangent_lr_pressed) and (_scancode == tangent_lr_scancode) and (_shift == tangent_lr_shift) and (_ctrl == tangent_lr_ctrl) and (_alt == tangent_lr_alt)) then { 
					if (player call canUseLRRadio) then {
						_hintText = format[localize "STR_transmit_lr", call currentLRFrequency];
						hintSilent parseText (_hintText);
						_request = format["TANGENT_LR@PRESSED@%1", call currentLRFrequency];
						_result = "task_force_radio_pipe" callExtension _request;
						tangent_lr_pressed = true;
					} else {
						call inWaterHint;
					}

				};
	
				if ((_scancode == dialog_lr_scancode) and (_shift == dialog_lr_shift) and (_ctrl == dialog_lr_ctrl) and (_alt == dialog_lr_alt)) then {
					if !(dialog) then {
						createDialog "rt1523g_radio_dialog";
						call updateLRDialogToChannel;
					}
				};
				[_scancode, _shift, _ctrl, _alt, lr_channel_1_scancode, lr_channel_1_shift, lr_channel_1_ctrl, lr_channel_1_alt, 0] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_2_scancode, lr_channel_2_shift, lr_channel_2_ctrl, lr_channel_2_alt, 1] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_3_scancode, lr_channel_3_shift, lr_channel_3_ctrl, lr_channel_3_alt, 2] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_4_scancode, lr_channel_4_shift, lr_channel_4_ctrl, lr_channel_4_alt, 3] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_5_scancode, lr_channel_5_shift, lr_channel_5_ctrl, lr_channel_5_alt, 4] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_6_scancode, lr_channel_6_shift, lr_channel_6_ctrl, lr_channel_6_alt, 5] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_7_scancode, lr_channel_7_shift, lr_channel_7_ctrl, lr_channel_7_alt, 6] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_8_scancode, lr_channel_8_shift, lr_channel_8_ctrl, lr_channel_8_alt, 7] call processLRChannelKeys;
				[_scancode, _shift, _ctrl, _alt, lr_channel_9_scancode, lr_channel_9_shift, lr_channel_9_ctrl, lr_channel_9_alt, 8] call processLRChannelKeys;
			};
			if (call haveDDRadio) then {
				if (!(tangent_dd_pressed) and (_scancode == tangent_dd_scancode) and (_shift == tangent_dd_shift) and (_ctrl == tangent_dd_ctrl) and (_alt == tangent_dd_alt)) then {
					if (player call canUseDDRadio) then { 
						_hintText = format[localize "STR_transmit_dd", dd_frequency];
						hintSilent parseText (_hintText);
						_request = format["TANGENT_DD@PRESSED@%1", dd_frequency];
						_result = "task_force_radio_pipe" callExtension _request;
						tangent_dd_pressed = true;
					} else {
						call onGroundHint;
					}
				};
	
				if ((_scancode == dialog_dd_scancode) and (_shift == dialog_dd_shift) and (_ctrl == dialog_dd_ctrl) and (_alt == dialog_dd_alt)) then {
					if !(dialog) then {
						createDialog "diver_radio_dialog";
						call updateDDDialog;
					}
				};
			};
			if ((_scancode == speak_volume_scancode) and (_shift == speak_volume_shift) and (_ctrl == speak_volume_ctrl) and (_alt == speak_volume_alt)) then {
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
		};
	};
	
			
	
	radio_keyUp =
	{
		private["_result", "_request", "_ctrl", "_scancode", "_shift", "_alt"];

		_scancode = _this select 1;		
		if (_this select 2 and _scancode != SHIFTL) then {_shift = 1} else {_shift = 0};
		if (_this select 3 and _scancode != CTRLL) then {_ctrl = 1} else {_ctrl = 0};
		if (_this select 4 and _scancode != ALTL) then {_alt = 1} else {_alt = 0};

		if (alive player) then {		
			if ((tangent_sw_pressed) and ((_scancode == tangent_sw_scancode) or (_shift != tangent_sw_shift) or (_ctrl != tangent_sw_ctrl) or (_alt != tangent_sw_alt))) then { 
				hintSilent "";
				_request = format["TANGENT@RELEASED@%1", call currentSWFrequency];
				_result = "task_force_radio_pipe" callExtension _request;	
				tangent_sw_pressed = false;
			};
			if ((tangent_lr_pressed) and ((_scancode == tangent_lr_scancode) or (_shift != tangent_lr_shift) or (_ctrl != tangent_lr_ctrl) or (_alt != tangent_lr_alt))) then { 
				hintSilent "";
				_request = format["TANGENT_LR@RELEASED@%1", call currentLRFrequency];
				_result = "task_force_radio_pipe" callExtension _request;	
				tangent_lr_pressed = false;
			};
			if ((tangent_dd_pressed) and ((_scancode == tangent_dd_scancode) or (_shift != tangent_dd_shift) or (_ctrl != tangent_dd_ctrl) or (_alt != tangent_dd_alt))) then { 
				hintSilent "";
				_request = format["TANGENT_DD@RELEASED@%1", dd_frequency];
				_result = "task_force_radio_pipe" callExtension _request;	
				tangent_dd_pressed = false;
			};
		};
	};
	
	preparePositionCoordinates = 		
	{
		_x = _this;
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
		
		
		(format["POS@%1@%2@%3@%4@%5@%6@%7@%8@%9", _xname, _current_x, _current_y, _current_z, _current_rotation_horizontal, _x call canSpeak, _x call canUseSWRadio, _x call canUseLRRadio, _x call canUseDDRadio]);	
	};
		
		
	_prev_result = "OK";
	_have_display_46 = false;

	while {true} do {
		if (isMultiplayer) then {			
			{		
				if (isPlayer _x) then {
					_request = _x call preparePositionCoordinates;
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
			} forEach playableUnits;
		};
		sleep 0.2;
		// send current sw freq
		if (isMultiplayer) then {
			_freq = "No_SW_Radio";
			_freq_lr = "No_LR_Radio";
			_freq_dd = "No_DD_Radio";
			if ((call haveSWRadio) and (player call canUseSWRadio)) then {
				_freq = call currentSWFrequency;
			};
			if ((call haveLRRadio) and (player call canUseLRRadio)) then {
				_freq_lr = call currentLRFrequency;
			};
			if ((call haveDDRadio) and (player call canUseDDRadio)) then {
				_freq_dd = dd_frequency;
			};

			_alive = alive player;
			_nickname = name player;
			_request = format["FREQ@%1@%2@%3@%4@%5@%6@%7@%8@%9@%10", _freq, _freq_lr, _freq_dd, _alive, speak_volume_level, sw_volume_level, lr_volume_level, dd_volume_level, _nickname, waves];
			_result = "task_force_radio_pipe" callExtension _request;
		};
		_request = format["VERSION@%1", ADDON_VERSION];
		_result = "task_force_radio_pipe" callExtension _request;

		if !(isNull (findDisplay 46)) then {	
			if !(_have_display_46) then {
				hint (localize "STR_init");
				sleep 1;
				_keyUpCallback = (findDisplay 46) displayAddEventHandler ["keyUp", "_this call radio_keyUp"];
				_keyDownCallback = (findDisplay 46) displayAddEventHandler ["keyDown", "_this call radio_keyDown"];
				hintSilent "";
				if (_keyUpCallback >= 0 and _keyDownCallback >= 0) then {			
					_have_display_46 = true;
				}
			};			
		} else {
			_have_display_46 = false;
		};
	}
};

[] spawn {
	sleep 5;
	if (leader player == player) then {		
		removeBackpack player;
		player addBackpack "tf_rt1523g";
	};
};

