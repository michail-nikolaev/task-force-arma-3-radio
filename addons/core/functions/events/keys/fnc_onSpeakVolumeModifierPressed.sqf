#include "script_component.hpp"

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

params ["_modifierMode"];

private _allowedModes = ["yelling", "whispering"];

if(!alive TFAR_currentUnit || TF_tangent_sw_pressed || TF_tangent_lr_pressed) exitWith {false};
if!(_modifierMode in _allowedModes) exitWith {false};

TF_last_speak_volume_level = TF_speak_volume_level;
TF_last_speak_volume_meters = TF_speak_volume_meters;

TF_speak_volume_level = _modifierMode;
if(_modifierMode == "yelling") then {
    TF_speak_volume_meters = TF_max_voice_volume;
} else {
    TF_speak_volume_meters = TF_min_voice_volume;
};

/*  Tell the plugin that we just changed our volume
    We can't wait for the normal sendFreqInfo interval because the Plugin has to
    know the change before we start transmitting
*/
call TFAR_fnc_sendFrequencyInfo;


private _localName = localize format["STR_voice_%1", _modifierMode];
private _hintText = format[localize "STR_voice_volume", _localName];
if (TFAR_oldVolumeHint) then {
    if (TFAR_volumeModifier_forceSpeech) then {
        [_hintText,format["TANGENT	PRESSED	%1	%2	%3","directSpeechFreq", 0, "directSpeech"],-1] call TFAR_fnc_processTangent;
    } else {
        [parseText (_hintText), -1] call TFAR_fnc_showHint;
    };
} else {
    if (!TFAR_ShowVolumeHUD) then {
        (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true]; //Hidden in the Released handler
    };
    if (TFAR_volumeModifier_forceSpeech) then {
        ["",format["TANGENT	PRESSED	%1	%2	%3","directSpeechFreq", 0, "directSpeech"],0] call TFAR_fnc_processTangent;
    };
};

call TFAR_fnc_updateSpeakVolumeUI;
["OnSpeakVolumeModifierPressed", [TFAR_currentUnit, TF_speak_volume_level, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;

true
