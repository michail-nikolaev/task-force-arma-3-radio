#include "script_component.hpp"

if ((TF_tangent_dd_pressed) and {alive TFAR_currentUnit}) then {
    ["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, "DD", 2, false, false]] call TFAR_fnc_fireEventHandlers;
    _dis_freq = "";
    if(tf_radio_show_freq) then {
        _dis_freq = TF_dd_frequency;
    } else {
        _dis_freq = "==Hidden==";
    };
    [format[localize "STR_transmit_end", "DD", "1", _dis_freq], format["TANGENT_DD	RELEASED	%1	0	dd", _dis_freq]] call TFAR_fnc_ProcessTangent;
    TF_tangent_dd_pressed = false;
    //						unit, radio, radioType, additional, buttonDown
    ["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, "DD", 2, false, false]] call TFAR_fnc_fireEventHandlers;
};
true
