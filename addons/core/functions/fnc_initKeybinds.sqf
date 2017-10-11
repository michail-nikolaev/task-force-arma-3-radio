#include "script_component.hpp"

TF_tangent_sw_scancode = 58;
TF_tangent_sw_modifiers = [false,false,false];

TF_tangent_sw_2_scancode = 0;
TF_tangent_sw_2_modifiers = [false,false,false];

TF_tangent_additional_sw_scancode = 20;
TF_tangent_additional_sw_modifiers = [false,false,false];

TF_dialog_sw_scancode = 25;
TF_dialog_sw_modifiers = [false, true, false];

TF_sw_cycle_next_scancode = 27;
TF_sw_cycle_next_modifiers = [false, true, false];

TF_sw_cycle_prev_scancode = 26;
TF_sw_cycle_prev_modifiers = [false, true, false];

TF_sw_stereo_both_scancode = 200;
TF_sw_stereo_both_modifiers = [false, true, false];

TF_sw_stereo_left_scancode = 203;
TF_sw_stereo_left_modifiers = [false, true, false];

TF_sw_stereo_right_scancode = 205;
TF_sw_stereo_right_modifiers = [false, true, false];

TF_sw_channel_1_scancode = 79;
TF_sw_channel_1_modifiers = [false, false, false];

TF_sw_channel_2_scancode = 80;
TF_sw_channel_2_modifiers = [false, false, false];

TF_sw_channel_3_scancode = 81;
TF_sw_channel_3_modifiers = [false, false, false];

TF_sw_channel_4_scancode = 75;
TF_sw_channel_4_modifiers = [false, false, false];

TF_sw_channel_5_scancode = 76;
TF_sw_channel_5_modifiers = [false, false, false];

TF_sw_channel_6_scancode = 77;
TF_sw_channel_6_modifiers = [false, false, false];

TF_sw_channel_7_scancode = 71;
TF_sw_channel_7_modifiers = [false, false, false];

TF_sw_channel_8_scancode = 72;
TF_sw_channel_8_modifiers = [false, false, false];

TF_tangent_lr_scancode = 58;
TF_tangent_lr_modifiers = [false, true, false];

TF_tangent_lr_2_scancode = 0;
TF_tangent_lr_2_modifiers = [false, false, false];

TF_tangent_additional_lr_scancode = 20;
TF_tangent_additional_lr_modifiers = [false, true, false];

TF_dialog_lr_scancode = 25;
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


_swCH1 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","1"];
_swCH2 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","2"];
_swCH3 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","3"];
_swCH4 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","4"];
_swCH5 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","5"];
_swCH6 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","6"];
_swCH7 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","7"];
_swCH8 = format ["%1 %2",localize "STR_TFAR_key_SW_Channe","8"];
["TFAR","SWChannel1",[_swCH1,_swCH1],{[0] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_1_scancode, TF_sw_channel_1_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel2",[_swCH2,_swCH2],{[1] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_2_scancode, TF_sw_channel_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel3",[_swCH3,_swCH3],{[2] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_3_scancode, TF_sw_channel_3_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel4",[_swCH4,_swCH4],{[3] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_4_scancode, TF_sw_channel_4_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel5",[_swCH5,_swCH5],{[4] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_5_scancode, TF_sw_channel_5_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel6",[_swCH6,_swCH6],{[5] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_6_scancode, TF_sw_channel_6_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel7",[_swCH7,_swCH7],{[6] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_7_scancode, TF_sw_channel_7_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel8",[_swCH8,_swCH8],{[7] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_8_scancode, TF_sw_channel_8_modifiers],false] call cba_fnc_addKeybind;


_lrCH1 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","1"];
_lrCH2 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","2"];
_lrCH3 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","3"];
_lrCH4 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","4"];
_lrCH5 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","5"];
_lrCH6 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","6"];
_lrCH7 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","7"];
_lrCH8 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","8"];
_lrCH9 = format ["%1 %2",localize "STR_TFAR_key_LR_Channe","9"];
["TFAR","LRChannel1",[_lrCH1,_lrCH1],{[0] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_1_scancode, TF_lr_channel_1_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel2",[_lrCH2,_lrCH2],{[1] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_2_scancode, TF_lr_channel_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel3",[_lrCH3,_lrCH3],{[2] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_3_scancode, TF_lr_channel_3_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel4",[_lrCH4,_lrCH4],{[3] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_4_scancode, TF_lr_channel_4_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel5",[_lrCH5,_lrCH5],{[4] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_5_scancode, TF_lr_channel_5_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel6",[_lrCH6,_lrCH6],{[5] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_6_scancode, TF_lr_channel_6_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel7",[_lrCH7,_lrCH7],{[6] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_7_scancode, TF_lr_channel_7_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel8",[_lrCH8,_lrCH8],{[7] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_8_scancode, TF_lr_channel_8_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel9",[_lrCH9,_lrCH9],{[8] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_9_scancode, TF_lr_channel_9_modifiers],false] call cba_fnc_addKeybind;


["TFAR","ChangeSpeakingVolume",["STR_TFAR_key_ChangeSpeechVolume","STR_TFAR_key_ChangeSpeechVolume"],{call TFAR_fnc_onSpeakVolumeChangePressed},{true},[TF_speak_volume_scancode, TF_speak_volume_modifiers],false] call cba_fnc_addKeybind;

["TFAR", "YellingModifier", ["STR_TFAR_key_YellingModifier", "STR_TFAR_key_YellingModifier"], {["yelling"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_yelling_scancode, TF_speak_volume_modifier_yelling_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "WhisperingModifier", ["STR_TFAR_key_WhisperingModifier", "STR_TFAR_key_WhisperingModifier"], {["whispering"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_whispering_scancode, TF_speak_volume_modifier_whispering_modifiers], false] call cba_fnc_addKeybind;

["TFAR","CycleSWRadios",["STR_TFAR_key_CycleRightSWRadios","STR_TFAR_key_CycleRightSWRadios"],{true},{["next"] call TFAR_fnc_processSWCycleKeys},[TF_sw_cycle_next_scancode, TF_sw_cycle_next_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleSWRadios",["STR_TFAR_key_CycleLeftSWRadios","STR_TFAR_key_CycleLeftSWRadios"],{true},{["prev"] call TFAR_fnc_processSWCycleKeys},[TF_sw_cycle_prev_scancode, TF_sw_cycle_prev_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleLRRadios",["STR_TFAR_key_CycleRightLRRadios","STR_TFAR_key_CycleRightLRRadios"],{true},{["next"] call TFAR_fnc_processLRCycleKeys},[TF_lr_cycle_next_scancode, TF_lr_cycle_next_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleLRRadios",["STR_TFAR_key_CycleLeftLRRadios","STR_TFAR_key_CycleLeftLRRadios"],{true},{["prev"] call TFAR_fnc_processLRCycleKeys},[TF_lr_cycle_prev_scancode, TF_lr_cycle_prev_modifiers],false] call cba_fnc_addKeybind;


["TFAR","SWStereoBoth",    ["STR_TFAR_key_SWStereo_Both","STR_TFAR_key_SWStereo_Both"],{[0] call TFAR_fnc_processSWStereoKeys},    {true},[TF_sw_stereo_both_scancode, TF_sw_stereo_both_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWStereoLeft",    ["STR_TFAR_key_SWStereo_Left","STR_TFAR_key_SWStereo_Left"],{[1] call TFAR_fnc_processSWStereoKeys},    {true},[TF_sw_stereo_left_scancode, TF_sw_stereo_left_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWStereoRight",["STR_TFAR_key_SWStereo_Right","STR_TFAR_key_SWStereo_Right"],{[2] call TFAR_fnc_processSWStereoKeys},{true},[TF_sw_stereo_right_scancode,TF_sw_stereo_right_modifiers],false] call cba_fnc_addKeybind;


["TFAR","LRStereoBoth",    ["STR_TFAR_key_LRStereo_Both","STR_TFAR_key_LRStereo_Both"],{[0] call TFAR_fnc_processLRStereoKeys},    {true},[TF_lr_stereo_both_scancode, TF_lr_stereo_both_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRStereoLeft",    ["STR_TFAR_key_LRStereo_Left","STR_TFAR_key_LRStereo_Left"],{[1] call TFAR_fnc_processLRStereoKeys},    {true},[TF_lr_stereo_left_scancode, TF_lr_stereo_left_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRStereoRight",    ["STR_TFAR_key_LRStereo_Right","STR_TFAR_key_LRStereo_Right"],{[2] call TFAR_fnc_processLRStereoKeys},{true},[TF_lr_stereo_right_scancode,TF_lr_stereo_right_modifiers],false] call cba_fnc_addKeybind;


["TFAR","SWTransmit",["STR_TFAR_key_SWTransmit","STR_TFAR_key_SWTransmit"],{call TFAR_fnc_onSwTangentPressed},{call TFAR_fnc_onSwTangentReleased},[TF_tangent_sw_scancode, TF_tangent_sw_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWTransmitAlt",["STR_TFAR_key_SWTransmitAlt","STR_TFAR_key_SWTransmitAlt"],{call TFAR_fnc_onSwTangentPressed},{call TFAR_fnc_onSwTangentReleased},[TF_tangent_sw_2_scancode, TF_tangent_sw_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWTransmitAdditional",["STR_TFAR_key_SWTransmitAdditional","STR_TFAR_key_SWTransmitAdditional"],{call TFAR_fnc_onAdditionalSwTangentPressed},{call TFAR_fnc_onAdditionalSwTangentReleased},[TF_tangent_additional_sw_scancode, TF_tangent_additional_sw_modifiers],false] call cba_fnc_addKeybind;

["TFAR","LRTransmit",["STR_TFAR_key_LRTransmit","STR_TFAR_key_LRTransmit"],{call TFAR_fnc_onLRTangentPressed},{call TFAR_fnc_onLRTangentReleased},[TF_tangent_lr_scancode, TF_tangent_lr_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRTransmitAlt",["STR_TFAR_key_LRTransmitAlt","STR_TFAR_key_LRTransmitAlt"],{call TFAR_fnc_onLRTangentPressed},{call TFAR_fnc_onLRTangentReleased},[TF_tangent_lr_2_scancode, TF_tangent_lr_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRTransmitAdditional",["STR_TFAR_key_LRTransmitAdditional","STR_TFAR_key_LRTransmitAdditional"],{call TFAR_fnc_onAdditionalLRTangentPressed},{call TFAR_fnc_onAdditionalLRTangentReleased},[TF_tangent_additional_lr_scancode, TF_tangent_additional_lr_modifiers],false] call cba_fnc_addKeybind;


["TFAR","LowerHeadset",["STR_TFAR_key_LowerHeadset","STR_TFAR_key_LowerHeadset"],{},{true call TFAR_fnc_setHeadsetLowered;},[0, [false, false, false]],false] call cba_fnc_addKeybind;
["TFAR","RaiseHeadset",["STR_TFAR_key_RaiseHeadset","STR_TFAR_key_RaiseHeadset"],{},{false call TFAR_fnc_setHeadsetLowered;},[0, [false, false, false]],false] call cba_fnc_addKeybind;
