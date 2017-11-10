#include "script_component.hpp"

if (alive TFAR_currentUnit) then {
    private _localName = LSTRING(voice_normal);
    if (TF_speak_volume_level == "Whispering") then {
        TF_speak_volume_level = "normal";
        TF_speak_volume_meters = TFAR_VOLUME_NORMAL;
        _localName = LSTRING(voice_normal);
    } else {
        if (TF_speak_volume_level == "Normal") then {
            TF_speak_volume_level = "yelling";
            TF_speak_volume_meters = TFAR_VOLUME_YELLING;
            _localName = LSTRING(voice_yelling);
        } else {
            TF_speak_volume_level = "whispering";
            TF_speak_volume_meters = TFAR_VOLUME_WHISPERING;
            _localName = LSTRING(voice_whispering);
        }
    };

    if (TFAR_oldVolumeHint) then {
        private _hintText = format[localize LSTRING(voice_volume), localize _localName];
        [parseText (_hintText), 5] call TFAR_fnc_showHint;
    } else {
        if (!TFAR_ShowVolumeHUD) then {
            (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];
            TFAR_volumeIndicatorFlashIndex = TFAR_volumeIndicatorFlashIndex+1;
            [{
                if (TFAR_volumeIndicatorFlashIndex == _this select 0) then {
                    (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
                };
            }, [TFAR_volumeIndicatorFlashIndex], 5] call CBA_fnc_waitAndExecute;
        };
    };
    call TFAR_fnc_updateSpeakVolumeUI;

    //							unit, range
    ["OnSpeakVolume", [TFAR_currentUnit, TF_speak_volume_meters]] call TFAR_fnc_fireEventHandlers;
};
true
