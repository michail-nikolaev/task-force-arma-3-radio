#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setVoiceVolume
 *
 * Author: NKey
 * Sets the volume for the player's voice in game
 *
 * Arguments:
 * Volume - Range (0,TF_max_voice_volume) <NUMBER>
 *
 * Return Value:
 * None
 *
 * Example:
 * 30 call TFAR_fnc_setVoiceVolume;
 *
 * Public: Yes
 */

TF_speak_volume_meters = TF_max_voice_volume min _this;

//							unit, range
["OnSpeakVolume", [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
