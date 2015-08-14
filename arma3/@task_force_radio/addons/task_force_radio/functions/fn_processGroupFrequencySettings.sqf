/*
 	Name: TFAR_fnc_processGroupFrequencySettings
 	
 	Author(s):
		NKey

 	Description:
		Sets frequency settings for groups.
	
	Parameters:
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_processGroupFrequencySettings;
*/
private ["_group_freq"];
if (isNil "tf_same_sw_frequencies_for_side") then {
<<<<<<< HEAD
	if (!isNil "tf_same_sw_frequencies_for_side_server") then {
		tf_same_sw_frequencies_for_side = tf_same_sw_frequencies_for_side_server;
	}else{
		tf_same_sw_frequencies_for_side = false;
	};
};
if (isNil "tf_same_lr_frequencies_for_side") then {
	if (!isNil "tf_same_lr_frequencies_for_side_server") then {
		tf_same_lr_frequencies_for_side = tf_same_lr_frequencies_for_side_server;
	}else{
		tf_same_lr_frequencies_for_side = true;
	};
};
if (isNil "tf_same_dd_frequencies_for_side") then {
	if (!isNil "tf_same_dd_frequencies_for_side_server") then {
		tf_same_dd_frequencies_for_side = tf_same_dd_frequencies_for_side_server;
	}else{
		tf_same_dd_frequencies_for_side = true;
	};
=======
	tf_same_sw_frequencies_for_side = false;
};
if (isNil "tf_same_lr_frequencies_for_side") then {
	tf_same_lr_frequencies_for_side = true;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
if (isNil "tf_freq_west") then {
	tf_freq_west = call TFAR_fnc_generateSwSettings;
};
<<<<<<< HEAD
if (isNil "tf_freq_east") then {
	TF_freq_east = call TFAR_fnc_generateSwSettings;
=======
if (isNil "ft_freq_east") then {
	if (isNil "tf_freq_east") then {
		TF_freq_east = call TFAR_fnc_generateSwSettings;
	};
}
else
{
	TF_freq_east =	ft_freq_east;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
if (isNil "tf_freq_guer") then {
	tf_freq_guer = call TFAR_fnc_generateSwSettings;
};

if (isNil "tf_freq_west_lr") then {
	tf_freq_west_lr = call TFAR_fnc_generateLrSettings;
};
<<<<<<< HEAD
if (isNil "tf_freq_east_lr") then {
	TF_freq_east_lr = call TFAR_fnc_generateLrSettings;
=======
if (isNil "ft_freq_east_lr") then {
	if (isNil "tf_freq_east_lr") then {
		TF_freq_east_lr = call TFAR_fnc_generateLrSettings;
	};
}
else
{
	TF_freq_east_lr =	ft_freq_east_lr;
};
if (isNil "tf_freq_guer") then {
	tf_freq_guer = call TFAR_fnc_generateSwSettings;
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
};
if (isNil "tf_freq_guer_lr") then {
	tf_freq_guer_lr = call TFAR_fnc_generateLrSettings;
};
<<<<<<< HEAD
if (isNil "tf_freq_west_dd") then {
	tf_freq_west_dd = call TFAR_fnc_generateDDFreq;
};
if (isNil "tf_freq_east_dd") then {
	TF_freq_east_dd = call TFAR_fnc_generateDDFreq;
};
if (isNil "tf_freq_guer_dd") then {
	tf_freq_guer_dd = call TFAR_fnc_generateDDFreq;
};
=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086

{
	_group_freq = _x getVariable "tf_sw_frequency";
	if (isNil "_group_freq") then {
		if !(tf_same_sw_frequencies_for_side) then {
			_x setVariable ["tf_sw_frequency", call TFAR_fnc_generateSwSettings, true];
		} else {
			switch (side _x) do {
				case west: {
					_x setVariable ["tf_sw_frequency", tf_freq_west, true];
				};
				case east: {
					_x setVariable ["tf_sw_frequency", tf_freq_east, true];
				};
				default {
					_x setVariable ["tf_sw_frequency", tf_freq_guer, true];
				};
			};
		};
	};
<<<<<<< HEAD
	_group_freq = _x getVariable "tf_dd_frequency";
	if (isNil "_group_freq") then {
		if !(tf_same_dd_frequencies_for_side) then {
			_x setVariable ["tf_dd_frequency", call TFAR_fnc_generateDDFreq, true];
		} else {
			switch (side _x) do {
				case west: {
					_x setVariable ["tf_dd_frequency", tf_freq_west_dd, true];
				};
				case east: {
					_x setVariable ["tf_dd_frequency", tf_freq_east_dd, true];
				};
				default {
					_x setVariable ["tf_dd_frequency", tf_freq_guer_dd, true];
				};
			};
		};
	};
=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	_group_freq = _x getVariable "tf_lr_frequency";
	if (isNil "_group_freq") then {
		if !(tf_same_lr_frequencies_for_side) then {
			_x setVariable ["tf_lr_frequency", call TFAR_fnc_generateLrSettings, true];
		} else {
			switch (side _x) do {
				case west: {
					_x setVariable ["tf_lr_frequency", tf_freq_west_lr, true];
				};
				case east: {
					_x setVariable ["tf_lr_frequency", tf_freq_east_lr, true];
				};
				default {
					_x setVariable ["tf_lr_frequency", tf_freq_guer_lr, true];
				};
			};
		};
	};
<<<<<<< HEAD
	true;
=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
} count allGroups;
