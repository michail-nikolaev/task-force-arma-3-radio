[] spawn {
	
	
		radio_keyDown =
		{
			if (alive player) then {
				if (_this select 1 == 58) then {
					hintSilent "Transmiting...";
					taskForceCallResult = "task_force_radio_pipe" callExtension "TANGENT@PRESSED";
				};
			};
		};
		
				
		
		radio_keyUp =
		{
			if (alive player) then {		
				if (_this select 1 == 58) then {
					hintSilent "";
					taskForceCallResult = "task_force_radio_pipe" callExtension "TANGENT@RELEASED";	
				};		
			};
		};
		
 		
			
		prevTaskForceRadioResult = "OK";
		taskForceDisplay46 = false;
		while {true} do {
			if !(isNull (findDisplay 46)) then {
				if !(taskForceDisplay46) then {
					hint "Waiting for 1 second....";
					sleep 1;
					keyUpCallback = (findDisplay 46) displayAddEventHandler ["keyUp", "_this call radio_keyUp"];
					keyDownCallback = (findDisplay 46) displayAddEventHandler ["keyDown", "_this call radio_keyDown"];
					hintSilent "";
				};
				taskForceDisplay46 = true;
			} else {
				taskForceDisplay46 = false;
			};

			{
				current_eyepos = eyepos _x;
				xname = name _x;
				current_x = (current_eyepos select 0);
				current_y = (current_eyepos select 1);
				current_z = (current_eyepos select 2);
		
				current_look_at = screenToWorld [0.5,0.5];
				current_look_at_x = (current_look_at select 0) - current_x;
				current_look_at_y = (current_look_at select 1) - current_y;
				current_look_at_z = (current_look_at select 2) - current_z;
		
				current_rotation_horizontal = 0;
				current_hyp_horizontal = sqrt(current_look_at_x * current_look_at_x + current_look_at_y * current_look_at_y);
		
				if (current_look_at_x < 0) then {
					current_rotation_horizontal = round -acos(current_look_at_y / current_hyp_horizontal);
				}
				else
				{
					current_rotation_horizontal = round acos(current_look_at_y / current_hyp_horizontal);
				};
				while{current_rotation_horizontal < 0} do {
					current_rotation_horizontal = current_rotation_horizontal + 360;
				};
				request = format["POS@%1@%2@%3@%4@%5", xname, current_x, current_y, current_z, current_rotation_horizontal ];	
				taskForceRadioResult = "task_force_radio_pipe" callExtension request;
				if (taskForceRadioResult != "OK") then 
				{
					hintSilent taskForceRadioResult;			
				} else {
					if (prevTaskForceRadioResult != "OK") then {
						hintSilent "";
					}
				};
				prevTaskForceRadioResult = taskForceRadioResult;
			} forEach allUnits;
			sleep 0.2
		}
}
