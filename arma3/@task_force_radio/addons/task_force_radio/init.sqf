disableSerialization;
#include "\task_force_radio\define.h"
#define SHIFTL 42
#define CTRLL 29
#define ALTL 56

ADDON_VERSION = "0.6.1 beta";

MIN_SW_FREQ = 30;
MAX_SW_FREQ = 512;

MIN_ASIP_FREQ = 30;
MAX_ASIP_FREQ = 87;

FREQ_ROUND_POWER = 10;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_RADIO_DIALOG_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDC_ANPRC152_RADIO_DIALOG;

IDC_RT1523G_RADIO_DIALOG_EDIT_ID = IDC_RT1523G_RADIO_DIALOG_EDIT;
IDC_RT1523G_RADIO_DIALOG_ID = IDC_RT1523G_RADIO_DIALOG;

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


tangent_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "key");
tangent_sw_shift = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "shift");
tangent_sw_ctrl = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "ctrl");
tangent_sw_alt = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "alt");

dialog_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "key");
dialog_sw_shift = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "shift");
dialog_sw_ctrl = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "ctrl");
dialog_sw_alt = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "alt");

tangent_lr_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "key");
tangent_lr_shift = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "shift");
tangent_lr_ctrl = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "ctrl");
tangent_lr_alt = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "alt");

dialog_lr_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "key");
dialog_lr_shift = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "shift");
dialog_lr_ctrl = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "ctrl");
dialog_lr_alt = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "alt");

speak_volume_scancode = 15; //getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "key");
speak_volume_shift = 0; //getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "shift");
speak_volume_ctrl = 1; //getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "ctrl");
speak_volume_alt = 0; //getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "alt");

tanget_sw_pressed = false;
tanget_lr_pressed = false;

speak_volume_level = "Normal";

[] spawn {	
	sleep 4;

	haveSWRadio = 
	{
		("ItemRadio" in assignedItems player);
	};
	haveLRRadio = 
	{
		(backpack player == "tf_rt1523g") or ((vehicle player != player) and ((gunner (vehicle player) == player) or (driver (vehicle player) == player) or (commander (vehicle player) == player) or ((vehicle player) turretUnit [0] == player)));		
	};
	currentSWFrequency = 
	{
		(sw_frequencies select sw_active_channel);
	};
	currentLRFrequency = 
	{
		(lr_frequencies select lr_active_channel);
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

	radio_keyDown =
	{
		private["_result", "_request", "_ctrl", "_scancode", "_shift", "_alt"];

		_scancode = _this select 1;		
		if (_this select 2 and _scancode != SHIFTL) then {_shift = 1} else {_shift = 0};
		if (_this select 3 and _scancode != CTRLL) then {_ctrl = 1} else {_ctrl = 0};
		if (_this select 4 and _scancode != ALTL) then {_alt = 1} else {_alt = 0};

		if (alive player) then {
			if (call haveSWRadio) then {
				if (!(tanget_sw_pressed) and (_scancode == tangent_sw_scancode) and (_shift == tangent_sw_shift) and (_ctrl == tangent_sw_ctrl) and (_alt == tangent_sw_alt)) then { 
					_hintText = format["Transmiting SW on <t color='#ffff00'>%1</t>...", call currentSWFrequency];
					hintSilent parseText (_hintText);
					_request = format["TANGENT@PRESSED@%1", call currentSWFrequency];
					_result = "task_force_radio_pipe" callExtension _request;
					tanget_sw_pressed = true;
				};
	
				if ((_scancode == dialog_sw_scancode) and (_shift == dialog_sw_shift) and (_ctrl == dialog_sw_ctrl) and (_alt == dialog_sw_alt)) then {
					if !(dialog) then {
						createDialog "anprc152_radio_dialog";
						call updateSWDialogToChannel;
					}
				};
			};
			if (call haveLRRadio) then {
				if (!(tanget_lr_pressed) and (_scancode == tangent_lr_scancode) and (_shift == tangent_lr_shift) and (_ctrl == tangent_lr_ctrl) and (_alt == tangent_lr_alt)) then { 
					_hintText = format["Transmiting LR on <t color='#ff00ff'>%1</t>...", call currentLRFrequency];
					hintSilent parseText (_hintText);
					_request = format["TANGENT_LR@PRESSED@%1", call currentLRFrequency];
					_result = "task_force_radio_pipe" callExtension _request;
					tanget_lr_pressed = true;
				};
	
				if ((_scancode == dialog_lr_scancode) and (_shift == dialog_lr_shift) and (_ctrl == dialog_lr_ctrl) and (_alt == dialog_lr_alt)) then {
					if !(dialog) then {
						createDialog "rt1523g_radio_dialog";
						call updateLRDialogToChannel;
					}
				};
			};
			if ((_scancode == speak_volume_scancode) and (_shift == speak_volume_shift) and (_ctrl == speak_volume_ctrl) and (_alt == speak_volume_alt)) then {
				if (speak_volume_level == "Whispering") then {
					speak_volume_level = "Normal"
				} else {
					if (speak_volume_level == "Normal") then {
						speak_volume_level = "Yelling";
					} else {
						speak_volume_level = "Whispering";
					}
				};
				_hintText = format["<t color='#f700da'>Voice volume: %1</t>", speak_volume_level];
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
			if ((tanget_sw_pressed) and ((_scancode == tangent_sw_scancode) or (_shift != tangent_sw_shift) or (_ctrl != tangent_sw_ctrl) or (_alt != tangent_sw_alt))) then { 
				hintSilent "";
				_request = format["TANGENT@RELEASED@%1", call currentSWFrequency];
				_result = "task_force_radio_pipe" callExtension _request;	
				tanget_sw_pressed = false;
			};
			if ((tanget_lr_pressed) and ((_scancode == tangent_lr_scancode) or (_shift != tangent_lr_shift) or (_ctrl != tangent_lr_ctrl) or (_alt != tangent_lr_alt))) then { 
				hintSilent "";
				_request = format["TANGENT_LR@RELEASED@%1", call currentLRFrequency];
				_result = "task_force_radio_pipe" callExtension _request;	
				tanget_lr_pressed = false;
			};
		};
	};
	
		
		
	_prev_result = "OK";
	_have_display_46 = false;
	while {true} do {
		if (isMultiplayer) then {
			{		
				if (isPlayer _x) then {
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
					
					_request = format["POS@%1@%2@%3@%4@%5", _xname, _current_x, _current_y, _current_z, _current_rotation_horizontal ];	
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
			_freq = "No_SW_Radio";
			_freq_lr = "No_LR_Radio";
			if (call haveSWRadio) then {
				_freq = call currentSWFrequency;
			};
			if (call haveLRRadio) then {
				_freq_lr = call currentLRFrequency;
			};
			_alive = alive player;
			_nickname = name player;
			_request = format["FREQ@%1@%2@%3@%4@%5", _freq, _freq_lr, _alive, speak_volume_level, _nickname];
			_result = "task_force_radio_pipe" callExtension _request;
		};
		_request = format["VERSION@%1", ADDON_VERSION];
		_result = "task_force_radio_pipe" callExtension _request;

		if !(isNull (findDisplay 46)) then {	
			if !(_have_display_46) then {
				hint "Waiting for 1 second....";
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

