#include "\task_force_radio\define.h"
private ["_depth", "_depthText"];
ctrlSetText [IDC_DIVER_RADIO_EDIT_ID, TF_dd_frequency];
_depth = round (((eyepos player) select 2) * TF_FREQ_ROUND_POWER) / TF_FREQ_ROUND_POWER;
_depthText =  format["%1m", _depth];
ctrlSetText [IDC_DIVER_RADIO_DEPTH_ID, _depthText];