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

TF_tangent_additional_lr_scancode = 21;
TF_tangent_additional_lr_modifiers = [false, false, false];

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

["TFAR","SWChannel1",["SW Channel 1","SW Channel 1"],{[0] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_1_scancode, TF_sw_channel_1_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel2",["SW Channel 2","SW Channel 2"],{[1] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_2_scancode, TF_sw_channel_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel3",["SW Channel 3","SW Channel 3"],{[2] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_3_scancode, TF_sw_channel_3_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel4",["SW Channel 4","SW Channel 4"],{[3] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_4_scancode, TF_sw_channel_4_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel5",["SW Channel 5","SW Channel 5"],{[4] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_5_scancode, TF_sw_channel_5_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel6",["SW Channel 6","SW Channel 6"],{[5] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_6_scancode, TF_sw_channel_6_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel7",["SW Channel 7","SW Channel 7"],{[6] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_7_scancode, TF_sw_channel_7_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWChannel8",["SW Channel 8","SW Channel 8"],{[7] call TFAR_fnc_processSWChannelKeys},{true},[TF_sw_channel_8_scancode, TF_sw_channel_8_modifiers],false] call cba_fnc_addKeybind;


["TFAR","LRChannel1",["LR Channel 1","LR Channel 1"],{[0] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_1_scancode, TF_lr_channel_1_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel2",["LR Channel 2","LR Channel 2"],{[1] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_2_scancode, TF_lr_channel_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel3",["LR Channel 3","LR Channel 3"],{[2] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_3_scancode, TF_lr_channel_3_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel4",["LR Channel 4","LR Channel 4"],{[3] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_4_scancode, TF_lr_channel_4_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel5",["LR Channel 5","LR Channel 5"],{[4] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_5_scancode, TF_lr_channel_5_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel6",["LR Channel 6","LR Channel 6"],{[5] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_6_scancode, TF_lr_channel_6_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel7",["LR Channel 7","LR Channel 7"],{[6] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_7_scancode, TF_lr_channel_7_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel8",["LR Channel 8","LR Channel 8"],{[7] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_8_scancode, TF_lr_channel_8_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRChannel9",["LR Channel 9","LR Channel 9"],{[8] call TFAR_fnc_processLRChannelKeys},{true},[TF_lr_channel_9_scancode, TF_lr_channel_9_modifiers],false] call cba_fnc_addKeybind;


["TFAR","ChangeSpeakingVolume",["Change Speaking Volume","Change Speaking Volume"],{call TFAR_fnc_onSpeakVolumeChangePressed},{true},[TF_speak_volume_scancode, TF_speak_volume_modifiers],false] call cba_fnc_addKeybind;

["TFAR", "YellingModifier", ["Yelling Modifier", "Yelling Modifier"], {["yelling"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_yelling_scancode, TF_speak_volume_modifier_yelling_modifiers], false] call cba_fnc_addKeybind;
["TFAR", "WhisperingModifier", ["Whispering Modifier", "Whispering Modifier"], {["whispering"] call TFAR_fnc_onSpeakVolumeModifierPressed}, {call TFAR_fnc_onSpeakVolumeModifierReleased}, [TF_speak_volume_modifier_whispering_scancode, TF_speak_volume_modifier_whispering_modifiers], false] call cba_fnc_addKeybind;

["TFAR","CycleSWRadios",["Cycle >> SW Radios","Cycle >> SW Radios"],{true},{["next"] call TFAR_fnc_processSWCycleKeys},[TF_sw_cycle_next_scancode, TF_sw_cycle_next_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleSWRadios",["Cycle << SW Radios","Cycle << SW Radios"],{true},{["prev"] call TFAR_fnc_processSWCycleKeys},[TF_sw_cycle_prev_scancode, TF_sw_cycle_prev_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleLRRadios",["Cycle >> LR Radios","Cycle >> LR Radios"],{true},{["next"] call TFAR_fnc_processLRCycleKeys},[TF_lr_cycle_next_scancode, TF_lr_cycle_next_modifiers],false] call cba_fnc_addKeybind;
["TFAR","CycleLRRadios",["Cycle << LR Radios","Cycle << LR Radios"],{true},{["prev"] call TFAR_fnc_processLRCycleKeys},[TF_lr_cycle_prev_scancode, TF_lr_cycle_prev_modifiers],false] call cba_fnc_addKeybind;


["TFAR","SWStereoBoth",    ["SW Stereo: Both","SW Stereo: Both"],{[0] call TFAR_fnc_processSWStereoKeys},    {true},[TF_sw_stereo_both_scancode, TF_sw_stereo_both_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWStereoLeft",    ["SW Stereo: Left","SW Stereo: Left"],{[1] call TFAR_fnc_processSWStereoKeys},    {true},[TF_sw_stereo_left_scancode, TF_sw_stereo_left_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWStereoRight",["SW Stereo: Right","SW Stereo: Right"],{[2] call TFAR_fnc_processSWStereoKeys},{true},[TF_sw_stereo_right_scancode,TF_sw_stereo_right_modifiers],false] call cba_fnc_addKeybind;


["TFAR","LRStereoBoth",    ["LR Stereo: Both","LR Stereo: Both"],{[0] call TFAR_fnc_processLRStereoKeys},    {true},[TF_lr_stereo_both_scancode, TF_lr_stereo_both_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRStereoLeft",    ["LR Stereo: Left","LR Stereo: Left"],{[1] call TFAR_fnc_processLRStereoKeys},    {true},[TF_lr_stereo_left_scancode, TF_lr_stereo_left_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRStereoRight",    ["LR Stereo: Right","LR Stereo: Right"],{[2] call TFAR_fnc_processLRStereoKeys},{true},[TF_lr_stereo_right_scancode,TF_lr_stereo_right_modifiers],false] call cba_fnc_addKeybind;


["TFAR","SWTransmit",["SW Transmit","SW Transmit"],{call TFAR_fnc_onSwTangentPressed},{call TFAR_fnc_onSwTangentReleased},[TF_tangent_sw_scancode, TF_tangent_sw_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWTransmitAlt",["SW Transmit Alt","SW Transmit Alt"],{call TFAR_fnc_onSwTangentPressed},{call TFAR_fnc_onSwTangentReleased},[TF_tangent_sw_2_scancode, TF_tangent_sw_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","SWTransmitAdditional",["SW Transmit Additional","SW Transmit Additional"],{call TFAR_fnc_onAdditionalSwTangentPressed},{call TFAR_fnc_onAdditionalSwTangentReleased},[TF_tangent_additional_sw_scancode, TF_tangent_additional_sw_modifiers],false] call cba_fnc_addKeybind;

["TFAR","LRTransmit",["LR Transmit","LR Transmit"],{call TFAR_fnc_onLRTangentPressed},{call TFAR_fnc_onLRTangentReleased},[TF_tangent_lr_scancode, TF_tangent_lr_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRTransmitAlt",["LR Transmit Alt","LR Transmit Alt"],{call TFAR_fnc_onLRTangentPressed},{call TFAR_fnc_onLRTangentReleased},[TF_tangent_lr_2_scancode, TF_tangent_lr_2_modifiers],false] call cba_fnc_addKeybind;
["TFAR","LRTransmitAdditional",["LR Transmit Additional","LR Transmit Additional"],{call TFAR_fnc_onAdditionalLRTangentPressed},{call TFAR_fnc_onAdditionalLRTangentReleased},[TF_tangent_additional_lr_scancode, TF_tangent_additional_lr_modifiers],false] call cba_fnc_addKeybind;
