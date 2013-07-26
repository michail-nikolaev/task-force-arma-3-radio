
#include "\task_force_radio\define.h"

MIN_SW_FREQ = 30;
MAX_SW_FREQ = 512;

FREQ_ROUND_POWER = 10;

IDC_ANPRC152_RADIO_DIALOG_EDIT_ID = IDC_ANPRC152_RADIO_DIALOG_EDIT;
IDC_ANPRC152_RADIO_DIALOG_ID = IDC_ANPRC152_RADIO_DIALOG;

sw_frequency = str (round (((random (MAX_SW_FREQ - MIN_SW_FREQ)) + MIN_SW_FREQ) * FREQ_ROUND_POWER) / FREQ_ROUND_POWER);

[] spawn {	
	
	radio_keyDown =
	{
		private "_result";
		if (alive player) then {
			// CAPS LOCK
			if (_this select 1 == 58) then { 
				hintSilent "Transmiting...";
				_request = format["TANGENT@PRESSED@%1", sw_frequency];
				_result = "task_force_radio_pipe" callExtension _request;
			};
			// U
			if (_this select 1 == 22) then {			
				if !(dialog) then {
					createDialog "anprc152_radio_dialog";
					ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT, sw_frequency];
				}
			};
		};
	};
	
			
	
	radio_keyUp =
	{
		private "_result";
		if (alive player) then {		
			if (_this select 1 == 58) then { // CAPS LOCK
				hintSilent "";
				_request = format["TANGENT@RELEASED@%1", sw_frequency];
				_result = "task_force_radio_pipe" callExtension _request;	
			};
		};
	};
	
		
		
	_prev_result = "OK";
	_have_display_46 = false;
	while {true} do {
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
			if (isMultiplayer) then {
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
			}
		} forEach allUnits;
		sleep 0.2;
		// send current sw freq
		if (isMultiplayer) then {
			_request = format["SW_FREQ@%1", sw_frequency];
			_result = "task_force_radio_pipe" callExtension _request;
		}

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

