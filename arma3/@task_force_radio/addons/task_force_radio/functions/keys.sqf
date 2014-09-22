TF_tangent_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "key");
TF_tangent_sw_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw"  >> "alt") == 1];
	
TF_tangent_sw_2_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw_2"  >> "key");
TF_tangent_sw_2_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw_2"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw_2"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_sw_2"  >> "alt") == 1];
		
TF_tangent_additional_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_sw"  >> "key");
TF_tangent_additional_sw_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_sw"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_sw"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_sw"  >> "alt") == 1];

TF_dialog_sw_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "key");
TF_dialog_sw_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "dialog_sw"  >> "alt") == 1];

TF_sw_cycle_next_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_next"  >> "key");
TF_sw_cycle_next_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_next"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_next"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_next"  >> "alt") == 1];

TF_sw_cycle_prev_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_prev"  >> "key");
TF_sw_cycle_prev_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_prev"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_prev"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_cycle_prev"  >> "alt") == 1];

TF_sw_stereo_both_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_both"  >> "key");
TF_sw_stereo_both_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_both"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_both"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_both"  >> "alt") == 1];

TF_sw_stereo_left_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_left"  >> "key");
TF_sw_stereo_left_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_left"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_left"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_left"  >> "alt") == 1];
	
TF_sw_stereo_right_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_right"  >> "key");
TF_sw_stereo_right_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_right"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_right"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_stereo_right"  >> "alt") == 1];
	
TF_sw_channel_1_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_1"  >> "key");
TF_sw_channel_1_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_1"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_1"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_1"  >> "alt") == 1];

TF_sw_channel_2_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_2"  >> "key");
TF_sw_channel_2_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_2"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_2"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_2"  >> "alt") == 1];

TF_sw_channel_3_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_3"  >> "key");
TF_sw_channel_3_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_3"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_3"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_3"  >> "alt") == 1];

TF_sw_channel_4_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_4"  >> "key");
TF_sw_channel_4_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_4"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_4"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_4"  >> "alt") == 1];

TF_sw_channel_5_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_5"  >> "key");
TF_sw_channel_5_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_5"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_5"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_5"  >> "alt") == 1];

TF_sw_channel_6_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_6"  >> "key");
TF_sw_channel_6_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_6"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_6"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_6"  >> "alt") == 1];

TF_sw_channel_7_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_7"  >> "key");
TF_sw_channel_7_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_7"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_7"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_7"  >> "alt") == 1];

TF_sw_channel_8_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_8"  >> "key");
TF_sw_channel_8_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_8"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_8"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "sw_channel_8"  >> "alt") == 1];


TF_tangent_lr_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "key");
TF_tangent_lr_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr"  >> "alt") == 1];
	
TF_tangent_lr_2_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr_2"  >> "key");
TF_tangent_lr_2_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr_2"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr_2"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_lr_2"  >> "alt") == 1];
	
TF_tangent_additional_lr_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_lr"  >> "key");
TF_tangent_additional_lr_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_lr"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_lr"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_additional_lr"  >> "alt") == 1];

TF_dialog_lr_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "key");
TF_dialog_lr_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "dialog_lr"  >> "alt") == 1];

TF_lr_cycle_next_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_next"  >> "key");
TF_lr_cycle_next_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_next"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_next"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_next"  >> "alt") == 1];

TF_lr_cycle_prev_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_prev"  >> "key");
TF_lr_cycle_prev_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_prev"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_prev"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_cycle_prev"  >> "alt") == 1];
	
TF_lr_stereo_both_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_both"  >> "key");
TF_lr_stereo_both_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_both"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_both"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_both"  >> "alt") == 1];

TF_lr_stereo_left_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_left"  >> "key");
TF_lr_stereo_left_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_left"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_left"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_left"  >> "alt") == 1];

TF_lr_stereo_right_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_right"  >> "key");
TF_lr_stereo_right_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_right"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_right"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_stereo_right"  >> "alt") == 1];
	
TF_lr_channel_1_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_1"  >> "key");
TF_lr_channel_1_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_1"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_1"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_1"  >> "alt") == 1];

TF_lr_channel_2_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_2"  >> "key");
TF_lr_channel_2_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_2"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_2"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_2"  >> "alt") == 1];

TF_lr_channel_3_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_3"  >> "key");
TF_lr_channel_3_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_3"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_3"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_3"  >> "alt") == 1];

TF_lr_channel_4_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_4"  >> "key");
TF_lr_channel_4_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_4"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_4"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_4"  >> "alt") == 1];

TF_lr_channel_5_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_5"  >> "key");
TF_lr_channel_5_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_5"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_5"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_5"  >> "alt") == 1];

TF_lr_channel_6_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_6"  >> "key");
TF_lr_channel_6_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_6"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_6"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_6"  >> "alt") == 1];

TF_lr_channel_7_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_7"  >> "key");
TF_lr_channel_7_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_7"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_7"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_7"  >> "alt") == 1];

TF_lr_channel_8_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_8"  >> "key");
TF_lr_channel_8_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_8"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_8"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_8"  >> "alt") == 1];

TF_lr_channel_9_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_9"  >> "key");
TF_lr_channel_9_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_9"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_9"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "lr_channel_9"  >> "alt") == 1];


TF_tangent_dd_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd"  >> "key");
TF_tangent_dd_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd"  >> "alt") == 1];
	
TF_tangent_dd_2_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd_2"  >> "key");
TF_tangent_dd_2_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd_2"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd_2"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "tanget_dd_2"  >> "alt") == 1];

TF_dialog_dd_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "dialog_dd"  >> "key");
TF_dialog_dd_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "dialog_dd"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "dialog_dd"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "dialog_dd"  >> "alt") == 1];

TF_speak_volume_scancode = getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "key");
TF_speak_volume_modifiers = [getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "shift") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "ctrl") == 1,
	getNumber (configFile >> "task_force_radio_keys" >>  "speak_volume"  >> "alt") == 1];
