#include "script_component.hpp"
/*
    Name: TFAR_fnc_updateSpeakVolumeUI

    Author(s):
        Dedmen

    Description:
        Updates UI speak volume indicator

    Parameters:
        Nothing

    Returns:
        Nothing

    Example:
        call TFAR_fnc_updateSpeakVolumeUI;
*/

_icon = "";
_display = uiNamespace getVariable [QGVAR(HUDVolumeIndicatorRscDisplay),displayNull];
if (isNull _display) exitWith {};

if (TF_speak_volume_level == "yelling") then {
    _icon = QPATHTOF(ui\tfar_volume_yelling.paa);
} else {
    if (TF_speak_volume_level == "whispering") then {
        _icon = QPATHTOF(ui\tfar_volume_whisper.paa);
    } else {
        _icon = QPATHTOF(ui\tfar_volume_normal.paa);
    }
};

(_display displayCtrl 1112) ctrlSetText _icon;

(_display displayCtrl 1112) ctrlSetFade TFAR_VolumeHudTransparency;
(_display displayCtrl 1112) ctrlCommit 0.5;
