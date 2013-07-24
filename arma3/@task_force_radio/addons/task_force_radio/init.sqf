[] spawn {	
	
	radio_keyDown =
	{
		private "_result";
		if (alive player) then {
			if (_this select 1 == 58) then {
				hintSilent "Transmiting...";
				_result = "task_force_radio_pipe" callExtension "TANGENT@PRESSED";
			};
		};
	};
	
			
	
	radio_keyUp =
	{
		private "_result";
		if (alive player) then {		
			if (_this select 1 == 58) then {
				hintSilent "";
				_result = "task_force_radio_pipe" callExtension "TANGENT@RELEASED";	
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
}
