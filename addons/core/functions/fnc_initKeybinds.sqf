#include "script_component.hpp"

/*
  Name: TFAR_fnc_initKeybinds

  Author: NKey, Garth de Wet (L-H), Dedmen
  initializes the CBA-Keybinds

  Arguments:
  None

  Return Value:
  None

  Example:
  call TFAR_fnc_initKeybinds;

  Public: No
*/
#include "\a3\editor_f\Data\Scripts\dikCodes.h"
#define LOCALIZE_CHANNEL(x,y) y call _fnc_localize##x##Channel

TF_tangent_sw_scancode = DIK_CAPSLOCK;
TF_tangent_sw_modifiers = [false, false, false];

TF_tangent_additional_sw_scancode = DIK_T;
TF_tangent_additional_sw_modifiers = [false, false, false];

TF_dialog_sw_scancode = DIK_P;
TF_dialog_sw_modifiers = [false, true, false];

TF_sw_cycle_next_scancode = 27;
TF_sw_cycle_next_modifiers = [false, true, false];

TF_sw_cycle_prev_scancode = 26;
TF_sw_cycle_prev_modifiers = [false, true, false];

TF_sw_stereo_both_scancode = DIK_UP;//Arrow up
TF_sw_stereo_both_modifiers = [false, true, false];

TF_sw_stereo_left_scancode = DIK_LEFT;//Arrow left
TF_sw_stereo_left_modifiers = [false, true, false];

TF_sw_stereo_right_scancode = DIK_RIGHT;//Arrow right
TF_sw_stereo_right_modifiers = [false, true, false];

TF_sw_channel_1_scancode = 79;//Num 1
TF_sw_channel_1_modifiers = [false, false, false];

TF_sw_channel_2_scancode = 80;//Num 2
TF_sw_channel_2_modifiers = [false, false, false];

TF_sw_channel_3_scancode = 81;//Num 3
TF_sw_channel_3_modifiers = [false, false, false];

TF_sw_channel_4_scancode = 75;//Num 4
TF_sw_channel_4_modifiers = [false, false, false];

TF_sw_channel_5_scancode = 76;//Num 5
TF_sw_channel_5_modifiers = [false, false, false];

TF_sw_channel_6_scancode = 77;//Num 6
TF_sw_channel_6_modifiers = [false, false, false];

TF_sw_channel_7_scancode = 71;//Num 7
TF_sw_channel_7_modifiers = [false, false, false];

TF_sw_channel_8_scancode = 72;//Num 8
TF_sw_channel_8_modifiers = [false, false, false];

TF_tangent_lr_scancode = DIK_CAPSLOCK;
TF_tangent_lr_modifiers = [false, true, false]; //ctrl,shift,alt

TF_tangent_additional_lr_scancode = DIK_T;
TF_tangent_additional_lr_modifiers = [false, true, false]; //shift,ctrl,alt

TF_dialog_lr_scancode = DIK_P;
TF_dialog_lr_modifiers = [false, false, true];

TF_lr_cycle_next_scancode = 27;
TF_lr_cycle_next_modifiers = [false, true, true];

TF_lr_cycle_prev_scancode = 26;
TF_lr_cycle_prev_modifiers = [false, true, true];

TF_lr_stereo_both_scancode = 200;
TF_lr_stereo_both_modifiers = [false, false, true];

TF_lr_stereo_left_scancode = 203;
TF_lr_stereo_left_modifiers = [false, false, true];

TF_lr_stereo_right_scancode = 205;
TF_lr_stereo_right_modifiers = [false, false, true];

TF_lr_channel_1_scancode = 79;
TF_lr_channel_1_modifiers = [false, true, false];

TF_lr_channel_2_scancode = 80;
TF_lr_channel_2_modifiers = [false, true, false];

TF_lr_channel_3_scancode = 81;
TF_lr_channel_3_modifiers = [false, true, false];

TF_lr_channel_4_scancode = 75;
TF_lr_channel_4_modifiers = [false, true, false];

TF_lr_channel_5_scancode = 76;
TF_lr_channel_5_modifiers = [false, true, false];

TF_lr_channel_6_scancode = 77;
TF_lr_channel_6_modifiers = [false, true, false];

TF_lr_channel_7_scancode = 71;
TF_lr_channel_7_modifiers = [false, true, false];

TF_lr_channel_8_scancode = 72;
TF_lr_channel_8_modifiers = [false, true, false];

TF_lr_channel_9_scancode = 73;
TF_lr_channel_9_modifiers = [false, true, false];

TF_speak_volume_scancode = 15;
TF_speak_volume_modifiers = [false, true, false];

TF_speak_volume_modifier_yelling_scancode = 0;
TF_speak_volume_modifier_yelling_modifiers = [false, false, false];

TF_speak_volume_modifier_whispering_scancode = 0;
TF_speak_volume_modifier_whispering_modifiers = [false, false, false];

private _fnc_localizeSWChannel = {
  private _str = format ["%1 %2", localize LSTRING(key_SW_Channel), _this];
  [_str, _str]
};
["TFAR", "SWChannel1", LOCALIZE_CHANNEL(SW,1), {[0] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_1_scancode, TF_sw_channel_1_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel2", LOCALIZE_CHANNEL(SW,2), {[1] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_2_scancode, TF_sw_channel_2_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel3", LOCALIZE_CHANNEL(SW,3), {[2] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_3_scancode, TF_sw_channel_3_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel4", LOCALIZE_CHANNEL(SW,4), {[3] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_4_scancode, TF_sw_channel_4_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel5", LOCALIZE_CHANNEL(SW,5), {[4] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_5_scancode, TF_sw_channel_5_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel6", LOCALIZE_CHANNEL(SW,6), {[5] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_6_scancode, TF_sw_channel_6_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel7", LOCALIZE_CHANNEL(SW,7), {[6] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_7_scancode, TF_sw_channel_7_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWChannel8", LOCALIZE_CHANNEL(SW,8), {[7] call TFAR_fnc_processSWChannelKeys}, {true}, [TF_sw_channel_8_scancode, TF_sw_channel_8_modifiers], false] call cba_fnc_addKeybind;

private _fnc_localizeLRChannel = {
  private _str = format ["%1 %2", localize LSTRING(key_LR_Channel), _this];
  [_str, _str]
};
["TFAR", "LRChannel1", LOCALIZE_CHANNEL(LR,1), {[0] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_1_scancode, TF_lr_channel_1_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel2", LOCALIZE_CHANNEL(LR,2), {[1] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_2_scancode, TF_lr_channel_2_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel3", LOCALIZE_CHANNEL(LR,3), {[2] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_3_scancode, TF_lr_channel_3_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel4", LOCALIZE_CHANNEL(LR,4), {[3] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_4_scancode, TF_lr_channel_4_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel5", LOCALIZE_CHANNEL(LR,5), {[4] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_5_scancode, TF_lr_channel_5_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel6", LOCALIZE_CHANNEL(LR,6), {[5] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_6_scancode, TF_lr_channel_6_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel7", LOCALIZE_CHANNEL(LR,7), {[6] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_7_scancode, TF_lr_channel_7_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel8", LOCALIZE_CHANNEL(LR,8), {[7] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_8_scancode, TF_lr_channel_8_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRChannel9", LOCALIZE_CHANNEL(LR,9), {[8] call TFAR_fnc_processLRChannelKeys}, {true}, [TF_lr_channel_9_scancode, TF_lr_channel_9_modifiers], false] call cba_fnc_addKeybind;


["TFAR","ChangeSpeakingVolume", [localize LSTRING(key_ChangeSpeechVolume), localize LSTRING(key_ChangeSpeechVolume)], {call TFAR_fnc_onSpeakVolumeChangePressed}, {true}, [TF_speak_volume_scancode, TF_speak_volume_modifiers], false] call cba_fnc_addKeybind;

["TFAR", "YellingModifier", [localize LSTRING(key_YellingModifier), localize LSTRING(key_YellingModifier)], {["yelling"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_yelling_scancode, TF_speak_volume_modifier_yelling_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "WhisperingModifier", [localize LSTRING(key_WhisperingModifier), localize LSTRING(key_WhisperingModifier)], {["whispering"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_whispering_scancode, TF_speak_volume_modifier_whispering_modifiers], false] call cba_fnc_addKeybind;

["TFAR", "CycleSRRadiosNext", [localize LSTRING(key_CycleNextSRRadios), localize LSTRING(key_CycleNextSRRadios)], {true}, {["next"] call TFAR_fnc_processSWCycleKeys}, [TF_sw_cycle_next_scancode, TF_sw_cycle_next_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "CycleSRRadiosPrev", [localize LSTRING(key_CyclePrevSRRadios), localize LSTRING(key_CyclePrevSRRadios)], {true}, {["prev"] call TFAR_fnc_processSWCycleKeys}, [TF_sw_cycle_prev_scancode, TF_sw_cycle_prev_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "CycleLRRadiosNext", [localize LSTRING(key_CycleNextLRRadios), localize LSTRING(key_CycleNextLRRadios)], {true}, {["next"] call TFAR_fnc_processLRCycleKeys}, [TF_lr_cycle_next_scancode, TF_lr_cycle_next_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "CycleLRRadiosPrev", [localize LSTRING(key_CyclePrevLRRadios), localize LSTRING(key_CyclePrevLRRadios)], {true}, {["prev"] call TFAR_fnc_processLRCycleKeys}, [TF_lr_cycle_prev_scancode, TF_lr_cycle_prev_modifiers], false] call cba_fnc_addKeybind;


["TFAR", "SWStereoBoth", [localize LSTRING(key_SWStereo_Both), localize LSTRING(key_SWStereo_Both)], {[0] call TFAR_fnc_processSWStereoKeys}, {true}, [TF_sw_stereo_both_scancode, TF_sw_stereo_both_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWStereoLeft", [localize LSTRING(key_SWStereo_Left), localize LSTRING(key_SWStereo_Left)], {[1] call TFAR_fnc_processSWStereoKeys}, {true}, [TF_sw_stereo_left_scancode, TF_sw_stereo_left_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWStereoRight", [localize LSTRING(key_SWStereo_Right), localize LSTRING(key_SWStereo_Right)], {[2] call TFAR_fnc_processSWStereoKeys}, {true}, [TF_sw_stereo_right_scancode, TF_sw_stereo_right_modifiers], false] call cba_fnc_addKeybind;


["TFAR", "LRStereoBoth", [localize LSTRING(key_LRStereo_Both), localize LSTRING(key_LRStereo_Both)], {[0] call TFAR_fnc_processLRStereoKeys}, {true}, [TF_lr_stereo_both_scancode, TF_lr_stereo_both_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRStereoLeft", [localize LSTRING(key_LRStereo_Left), localize LSTRING(key_LRStereo_Left)], {[1] call TFAR_fnc_processLRStereoKeys}, {true}, [TF_lr_stereo_left_scancode, TF_lr_stereo_left_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRStereoRight", [localize LSTRING(key_LRStereo_Right), localize LSTRING(key_LRStereo_Right)], {[2] call TFAR_fnc_processLRStereoKeys}, {true}, [TF_lr_stereo_right_scancode, TF_lr_stereo_right_modifiers], false] call cba_fnc_addKeybind;


["TFAR", "SWTransmit", [localize LSTRING(key_SWTransmit), localize LSTRING(key_SWTransmit)], {call TFAR_fnc_onSwTangentPressed}, {call TFAR_fnc_onSwTangentReleased}, [TF_tangent_sw_scancode, TF_tangent_sw_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "SWTransmitAdditional", [localize LSTRING(key_SWTransmitAdditional), localize LSTRING(key_SWTransmitAdditional)], {call TFAR_fnc_onAdditionalSwTangentPressed}, {call TFAR_fnc_onAdditionalSwTangentReleased}, [TF_tangent_additional_sw_scancode, TF_tangent_additional_sw_modifiers], false] call cba_fnc_addKeybind;

["TFAR", "LRTransmit", [localize LSTRING(key_LRTransmit), localize LSTRING(key_LRTransmit)], {call TFAR_fnc_onLRTangentPressed}, {call TFAR_fnc_onLRTangentReleased}, [TF_tangent_lr_scancode, TF_tangent_lr_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "LRTransmitAdditional", [localize LSTRING(key_LRTransmitAdditional), localize LSTRING(key_LRTransmitAdditional)], {call TFAR_fnc_onAdditionalLRTangentPressed}, {call TFAR_fnc_onAdditionalLRTangentReleased}, [TF_tangent_additional_lr_scancode, TF_tangent_additional_lr_modifiers], false] call cba_fnc_addKeybind;


["TFAR", "ToggleHeadset", [localize LSTRING(key_RaiseLowerHeadset), localize LSTRING(key_RaiseLowerHeadset)], {}, {!(missionNamespace getVariable [QGVAR(isHeadsetLowered), false]) call TFAR_fnc_setHeadsetLowered;}, [0, [false, false, false]], false] call cba_fnc_addKeybind;

["TFAR", "TSDebugLog", ["TS Debug Log", "Makes TS collect debug info into one folder"], {}, {
    "task_force_radio_pipe" callExtension "collectDebugInfo~";
    systemChat "I logged stuff! Look in TS for path";
    hint "I logged stuff! Look in TS for path";
},[0, [false, false, false]], false] call cba_fnc_addKeybind;
