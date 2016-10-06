#include "script_component.hpp"

/*
    Name: TFAR_fnc_onSpeakVolumeModifierReleased

    Author(s):
        ACyprus

    Description:
        Restores any transient volume changes for the player's voice in game

    Parameters:
        NONE

    Returns:
        BOOLEAN - Whether or not the event was handled

    Example:
        call TFAR_fnc_onSpeakVolumeModifierReleased;
*/
TF_speak_volume_level = TF_last_speak_volume_level;
TF_speak_volume_meters = TF_last_speak_volume_meters;


if (TF_volumeModifier_forceSpeech) then {
    ["",format["TANGENT	RELEASED	%1	%2	%3","directSpeechFreq", 0, "directSpeech"],0] call TFAR_fnc_ProcessTangent;
} else {
    call TFAR_fnc_HideHint;
};

["OnSpeakVolumeModifierReleased", TFAR_currentUnit, [TFAR_currentUnit, TF_speak_volume_level, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;

true
