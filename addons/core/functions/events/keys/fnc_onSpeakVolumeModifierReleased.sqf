#include "script_component.hpp"

/*
 * Name: TFAR_fnc_onSpeakVolumeModifierReleased
 *
 * Author: ACyprus
 * Restores any transient volume changes for the player's voice in game
 *
 * Arguments:
 * None
 *
 * Return Value:
 * Whether or not the event was handled <BOOL>
 *
 * Example:
 * call TFAR_fnc_onSpeakVolumeModifierReleased;
 *
 * Public: No
 */

TF_speak_volume_level = TF_last_speak_volume_level;
TF_speak_volume_meters = TF_last_speak_volume_meters;

/*  Tell the plugin that we just changed our volume
    We can't wait for the normal sendFreqInfo interval because the Plugin has to
    know the change before we start transmitting
*/
call TFAR_fnc_sendFrequencyInfo;

if (TFAR_oldVolumeHint) then {
    if (TFAR_volumeModifier_forceSpeech) then {
        ["",format["TANGENT	RELEASED	%1	%2	%3","directSpeechFreq", 0, "directSpeech"],0] call TFAR_fnc_processTangent;
    } else {
        call TFAR_fnc_hideHint;
    };
} else {
    call TFAR_fnc_hideHint;
    if (!TFAR_ShowVolumeHUD) then {
        (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
    };
    if (TFAR_volumeModifier_forceSpeech) then {
        ["",format["TANGENT	RELEASED	%1	%2	%3","directSpeechFreq", 0, "directSpeech"],0] call TFAR_fnc_processTangent;
    };
};

call TFAR_fnc_updateSpeakVolumeUI;
["OnSpeakVolumeModifierReleased", [TFAR_currentUnit, TF_speak_volume_level, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;

true
