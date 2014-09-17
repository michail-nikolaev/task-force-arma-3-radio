/*
 	Name: TFAR_fnc_setActiveSwRadio
 	
 	Author(s):
		NKey

 	Description:
		Sets the active SW radio.
	
	Parameters:
		STRING - Radio ID
 	
 	Returns:
		Nothing
 	
 	Example:
		"tf_anprc148jem_1" call TFAR_fnc_setActiveSwRadio;
*/
_old = (call TFAR_fnc_activeSwRadio);
player unassignItem _old;
player assignItem _this;
["OnSWChange", player, [player, _this, _old]] call TFAR_fnc_fireEventHandlers;