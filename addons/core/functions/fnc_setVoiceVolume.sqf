/*
 	Name: TFAR_fnc_setVoiceVolume
 	
 	Author(s):
		NKey
 	
 	Description:
		Sets the volume for the player's voice in game
 	
 	Parameters: 
	0: NUMBER - Volume : Range (0,TF_max_voice_volume)
 	
 	Returns:
		Nothing
 	
 	Example:
		30 call TFAR_fnc_setVoiceVolume;
 */
#include "script.h"
TF_speak_volume_meters = TF_max_voice_volume min _this;

//							unit, range
["OnSpeakVolume", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
