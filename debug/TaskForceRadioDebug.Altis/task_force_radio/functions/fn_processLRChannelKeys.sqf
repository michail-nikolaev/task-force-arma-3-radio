/*
 	Name: TFAR_fnc_processLRChannelKeys
 	
 	Author(s):
		NKey

 	Description:
		Switches the active LR radio to the passed channel.
	
	Parameters:
		0: NUMBER - Channel : Range (0,8)
 	
 	Returns:
		BOOLEAN - If the event was handled by this function.
 	
 	Example:
		Called by CBA.
*/
private ["_lr_channel_number","_hintText","_result","_active_lr"];
_lr_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveLRRadio) and {alive TFAR_currentUnit}) then {
	_active_lr = call TFAR_fnc_activeLrRadio;
	[_active_lr select 0, _active_lr select 1, _lr_channel_number] call TFAR_fnc_setLrChannel;
	
	[_active_lr, true] call TFAR_fnc_ShowRadioInfo;
	if (dialog) then {
		call compile ([_active_lr select 0, "tf_dialogUpdate"] call TFAR_fnc_getLrRadioProperty);
	};
	_result = true;
};
_result