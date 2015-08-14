/*
 	Name: TFAR_fnc_setActiveLrRadio
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the active LR radio to the passed radio
 	
 	Parameters:
		ARRAY:
			0: OBJECT - Radio
			1: STRING - Radio ID
 	
 	Returns:
		Nothing
 	
 	Example:
		TF_lr_dialog_radio call TFAR_fnc_setActiveLrRadio;
*/
private "_old";
_old = TF_lr_active_radio;
TF_lr_active_radio = _this;
if (TFAR_currentUnit == player) then {
	TF_lr_active_curator_radio = _this;
};
["OnLRChange", TFAR_currentUnit, [TFAR_currentUnit, TF_lr_active_radio, _old]] call TFAR_fnc_fireEventHandlers;