/*
 	Name: TFAR_fnc_updateDDDialog
 	
 	Author(s):
		NKey
 	
 	Description:
		Updates the DD dialog to the channel and depth if switched.
 	
 	Parameters: 
		Nothing
 	
 	Returns:
		Nothing
 	
 	Example:
		call TFAR_fnc_updateDDDialog;
*/

#include "\task_force_radio\define.h"
private ["_depth", "_depthText"];
ctrlSetText [IDC_DIVER_RADIO_EDIT_ID, TF_dd_frequency];
_depth = round (((eyepos TFAR_currentUnit) select 2) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER;
_depthText =  format["%1m", _depth];
ctrlSetText [IDC_DIVER_RADIO_DEPTH_ID, _depthText];