disableSerialization;
#include "\task_force_radio\define.h"
#define SHIFTL 42
#define CTRLL 29
#define ALTL 56

MIN_SW_FREQ = 30;
MAX_SW_FREQ = 512;


FREQ_ROUND_POWER = 10;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_RADIO_DIALOG_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDC_ANPRC152_RADIO_DIALOG;

sw_frequency = str (round (((random (MAX_SW_FREQ - MIN_SW_FREQ)) + MIN_SW_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER);

tangent_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "key");
tangent_sw_shift = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "shift");
tangent_sw_ctrl = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "ctrl");
tangent_sw_alt = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "alt");

dialog_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "key");
dialog_sw_shift = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "shift");
dialog_sw_ctrl = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "ctrl");
dialog_sw_alt = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "alt");

tanget_sw_pressed = false;

[] spawn {	
	
	radio_keyDown =
	{
		private["_result", "_request", "_ctrl", "_scancode", "_shift", "_alt"];

		_scancode = _this select 1;		
		if (_this select 2 and _scancode != SHIFTL) then {_shift = 1} else {_shift = 0};
		if (_this select 3 and _scancode != CTRLL) then {_ctrl = 1} else {_ctrl = 0};
		if (_this select 4 and _scancode != ALTL) then {_alt = 1} else {_alt = 0};

		if (alive player) then {

			if (!(tanget_sw_pressed) and (_scancode == tangent_sw_scancode) and (_shift == tangent_sw_shift) and (_ctrl == tangent_sw_ctrl) and (_alt == tangent_sw_alt)) then { 
				_hintText = format["Transmiting on <t color='#ffff00'>%1</t>...", sw_frequency];
				hintSilent parseText (_hintText);
				_request = format["TANGENT@PRESSED@%1", sw_frequency];
				_result = "task_force_radio_pipe" callExtension _request;
				tanget_sw_pressed = true;
			};

			if ((_scancode == dialog_sw_scancode) and (_shift == dialog_sw_shift) and (_ctrl == dialog_sw_ctrl) and (_alt == dialog_sw_alt)) then {
				if !(dialog) then {
					createDialog "anprc152_radio_dialog";
					ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT, sw_frequency];
				}
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
			if ((tanget_sw_pressed) and ((_scancode != tangent_sw_scancode) or (_shift != tangent_sw_shift) or (_ctrl != tangent_sw_ctrl) or (_alt != tangent_sw_alt))) then { 
				hintSilent "";
				_request = format["TANGENT@RELEASED@%1", sw_frequency];
				_result = "task_force_radio_pipe" callExtension _request;	
				tanget_sw_pressed = false;
			};
		};
	};
	
		
		
	_prev_result = "OK";
	_have_display_46 = false;
	while {true} do {
		if (isMultiplayer) then {
			{			
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
			} forEach allUnits;
		};
		sleep 0.2;
		// send current sw freq
		if (isMultiplayer) then {
			_request = format["SW_FREQ@%1", sw_frequency];
			_result = "task_force_radio_pipe" callExtension _request;
		} else {
			_result = "task_force_radio_pipe" callExtension "PING";
		};

		if !(isNull (findDisplay 46)) then {
			if !(_have_display_46) then {
				hint "Waiting for 1 second....";
				sleep 1;
				_keyUpCallback = (findDisplay 46) displayAddEventHandler ["keyUp", "_this call radio_keyUp"];
				_keyDownCallback = (findDisplay 46) displayAddEventHandler ["keyDown", "_this call radio_keyDown"];
				hintSilent "";
			};
			_have_display_46 = true;
		} else {
			_have_display_46 = false;
		};
	}
};

