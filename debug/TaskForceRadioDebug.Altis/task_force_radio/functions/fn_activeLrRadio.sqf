/*
 	Name: TFAR_fnc_activeLrRadio
 	
 	Author(s):
		NKey

 	Description:
		Returns the active LR radio.
	
	Parameters:
		Nothing
 	
 	Returns:
		ARRAY: Active LR radio
 	
 	Example:
		_radio = call TFAR_fnc_activeLRRadio;
*/
private ["_radios", "_found"];
_radios = currentUnit call TFAR_fnc_lrRadiosList;
if (isNil "TF_lr_active_radio") then {		
	if (count _radios > 0) then {
		TF_lr_active_radio = _radios select 0;		
	};
} else {	
	_found = _this in _radios;
	if !(_found) then {
		if (count _radios > 0) then {
			if (!(isNil "TF_lr_active_curator_radio" ) and {TF_lr_active_curator_radio in _radios}) then {
				TF_lr_active_radio = TF_lr_active_curator_radio;
			} else {
				TF_lr_active_radio = _radios select 0;		
			};
		} else {
			TF_lr_active_radio = nil;
		};
	};
};
TF_lr_active_radio