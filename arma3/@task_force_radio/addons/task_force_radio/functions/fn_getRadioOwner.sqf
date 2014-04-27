/*
 	Name: TFAR_fnc_getRadioOwner
 	
 	Author(s):
		L-H
 	
 	Description:
		Gets the owner of a SW radio.
 	
 	Parameters:
		STRING - radio classname
 	
 	Returns:
		Nothing
 	
 	Example:
		_owner = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioOwner;
*/
#include "script.h"

((_this call TFAR_fnc_getSwSettings) select RADIO_OWNER)