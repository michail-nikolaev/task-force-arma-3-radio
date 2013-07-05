sleep 3;
[] spawn {
	while {true} do {
		current_eyepos = eyepos player;
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
		else{
			current_rotation_horizontal = round acos(current_look_at_y / current_hyp_horizontal);
		};
		while{current_rotation_horizontal < 0} do {
			current_rotation_horizontal = current_rotation_horizontal + 360;
		};

	

	
		hintSilent (formatText["%1, %2 ,%3, %4", current_x, current_y, current_z, current_rotation_horizontal ]);
		sleep 0.2
	}
}
