/*
 	Name: TFAR_fnc_onSpeakVolumeModifierPressed
 	
 	Author(s):
		ACyprus
 	
 	Description:
		Transiently changes the volume for the player's voice in game to either Yelling or Whisper
 	
 	Parameters: 
		0: STRING - Volume level : VALUES ("yelling" or "whispering")
 	
 	Returns:
		BOOLEAN - Whether or not the event was handled
 	
 	Example:
		["yelling"] call TFAR_fnc_onSpeakVolumeModifierPressed;
*/
private ["_modifierMode", "_allowedModes", "_localName", "_hintText"];

_modifierMode = _this select 0;
_allowedModes = ["yelling", "whispering"];

if(!alive TFAR_currentUnit || TF_tangent_sw_pressed || TF_tangent_lr_pressed || TF_tangent_dd_pressed) exitWith {false};
if!(_modifierMode in _allowedModes) exitWith {false};

TF_last_speak_volume_level = TF_speak_volume_level;
TF_last_speak_volume_meters = TF_speak_volume_meters;

TF_speak_volume_level = _modifierMode;
if(_modifierMode == "yelling") then {
	TF_speak_volume_meters = TF_max_voice_volume;
} else {
	TF_speak_volume_meters = TF_min_voice_volume;
};

_localName = localize format["STR_voice_%1", _modifierMode];
_hintText = format[localize "STR_voice_volume", _localName];
[parseText (_hintText), -1] call TFAR_fnc_showHint;

["OnSpeakVolumeModifierPressed", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_level, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
	
true