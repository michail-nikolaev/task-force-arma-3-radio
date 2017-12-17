/* #Mytuxy
$[
    1.063,
    ["fadak",[["0","0","1","1"],"0.0025","0.004","GUI_GRID"],0,1,1],
    [1200,"background",[1,"task_force_radio\fadak\fadak.paa",["0.0142813 * safezoneW + safezoneX","-0.1314 * safezoneH + safezoneY","0.332062 * safezoneW","1.1198 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1600,"enter",[1,"",["0.196812 * safezoneW + safezoneX","0.577 * safezoneH + safezoneY","0.0170625 * safezoneW","0.0252056 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1601,"clear",[1,"",["0.196812 * safezoneW + safezoneX","0.6078 * safezoneH + safezoneY","0.0150938 * safezoneW","0.0280062 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1602,"additional",[1,"",["0.196297 * safezoneW + safezoneX","0.643 * safezoneH + safezoneY","0.0164063 * safezoneW","0.0238053 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1604,"increase_volume",[1,"",["0.176187 * safezoneW + safezoneX","0.6738 * safezoneH + safezoneY","0.0164063 * safezoneW","0.0252056 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1605,"decrease_volume",[1,"",["0.137 * safezoneW + safezoneX","0.6727 * safezoneH + safezoneY","0.0164063 * safezoneW","0.0252056 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1400,"edit",[1,"444.8",["0.162781 * safezoneW + safezoneX","0.401 * safezoneH + safezoneY","0.0505312 * safezoneW","0.0539 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1401,"channel_edit",[1,"C8",["0.140094 * safezoneW + safezoneX","0.401 * safezoneH + safezoneY","0.0257812 * safezoneW","0.0539 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1606,"stereo",[1,"",["0.157625 * safezoneW + safezoneX","0.6738 * safezoneH + safezoneY","0.0164063 * safezoneW","0.0252056 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1607,"channel_switch",[1,"",["0.167937 * safezoneW + safezoneX","0.2624 * safezoneH + safezoneY","0.0236227 * safezoneW","0.0518116 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],ELSTRING(core,set_additional),"-1"],[]],
    [1608,"speakers",[1,"",["0.156078 * safezoneW + safezoneX","0.61 * safezoneH + safezoneY","0.0175312 * safezoneW","0.0319 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/





class fadak_radio_dialog
{
    idd = IDD_FADAK_RADIO_DIALOG;
    movingEnable = 1;
    controlsBackground[] = { };
    objects[] = { };
    onUnload = "['OnRadioOpen', [player, TF_sw_dialog_radio, false, 'fadak_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
    onLoad = QUOTE(if (sunOrMoon < 0.2) then {((_this select 0) displayCtrl TF_IDD_BACKGROUND) ctrlSetText 'PATHTOF(fadak\ui\fadak_n.paa)';};);
controls[]=
{
    background,
    enter,
    clear,
    channel_switch,
    increase_volume,
    decrease_volume,
    edit,
    channel_edit,
    stereo,
    additional,
    speakers
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by [TF]Nkey, v1.063, #Xyjiti)
////////////////////////////////////////////////////////

class background: RscBackPicture
{
    idc = IDC_FADAK_BACKGROUND;
    text = QPATHTOF(fadak\ui\fadak.paa);
    x = 0.0142813 * safezoneW + safezoneX;
    y = -0.1314 * safezoneH + safezoneY;
    w = 0.332062 * safezoneW;
    h = 1.1198 * safezoneH;
    moving = 1;
};
class enter: HiddenButton
{
    idc = IDC_FADAK_ENTER_FADAK;
    x = 0.196812 * safezoneW + safezoneX;
    y = 0.577 * safezoneH + safezoneY;
    w = 0.0170625 * safezoneW;
    h = 0.0252056 * safezoneH;
    tooltip = ECSTRING(core,set_frequency);
    onButtonClick = QUOTE([((ctrlParent (_this select 0))) displayCtrl IDC_FADAK_EDIT] call TFAR_handhelds_fnc_onButtonClick_Enter;);
    action = "";
};
class clear: HiddenButton
{
    idc = IDC_FADAK_CLEAR;
    x = 0.196812 * safezoneW + safezoneX;
    y = 0.6078 * safezoneH + safezoneY;
    w = 0.0150938 * safezoneW;
    h = 0.0280062 * safezoneH;
    tooltip = ECSTRING(core,clear_frequency);
    action = QUOTE(ctrlSetText [ARR_2(IDC_FADAK_EDIT, '')];ctrlSetFocus ((findDisplay IDD_FADAK_RADIO_DIALOG) displayCtrl IDC_FADAK_EDIT););
};
class additional: HiddenButton
{
    idc = IDC_FADAK_ADDITIONAL;
    x = 0.196297 * safezoneW + safezoneX;
    y = 0.643 * safezoneH + safezoneY;
    w = 0.0164063 * safezoneW;
    h = 0.0238053 * safezoneH;
    tooltip = ECSTRING(core,set_additional);
    action = "[TF_sw_dialog_radio, TF_sw_dialog_radio call TFAR_fnc_getSwChannel] call TFAR_fnc_setAdditionalSwChannel; call TFAR_fnc_updateSWDialogToChannel; [TF_sw_dialog_radio, false] call TFAR_fnc_showRadioInfo;";
};
class previous_channel: HiddenButton
{
    idc = IDC_FADAK_PREVIOUS_CHANNEL;
    x = 0.196297 * safezoneW + safezoneX;
    y = 0.6749 * safezoneH + safezoneY;
    w = 0.0150938 * safezoneW;
    h = 0.022405 * safezoneH;
    tooltip = ECSTRING(core,previous_channel);
    action = "[0, false] call TFAR_fnc_setChannelViaDialog;";
};
class increase_volume: HiddenButton
{
    idc = IDC_FADAK_INCREASE_VOLUME;
    x = 0.176187 * safezoneW + safezoneX;
    y = 0.6738 * safezoneH + safezoneY;
    w = 0.0164063 * safezoneW;
    h = 0.0252056 * safezoneH;
    action = "[1, false] call TFAR_fnc_setVolumeViaDialog;";
    tooltip = ECSTRING(core,increase_volume);
};
class decrease_volume: HiddenButton
{
    idc = IDC_FADAK_DECREASE_VOLUME;
    x = 0.137 * safezoneW + safezoneX;
    y = 0.6727 * safezoneH + safezoneY;
    w = 0.0164063 * safezoneW;
    h = 0.0252056 * safezoneH;
    action = "[0, false] call TFAR_fnc_setVolumeViaDialog;";
    tooltip = ECSTRING(core,decrease_volume);
};
class edit: RscEditLCD
{
    idc = IDC_FADAK_EDIT;
    x = 0.162781 * safezoneW + safezoneX;
    y = 0.401 * safezoneH + safezoneY;
    w = 0.0505312 * safezoneW;
    h = 0.0539 * safezoneH;
    font = "TFAR_font_segments";
    shadow = 1;
    tooltip = ECSTRING(core,current_freq);
    canModify = 1;
};
class channel_edit: RscEditLCD
{
    idc = IDC_FADAK_CHANNEL_EDIT;
    x = 0.140094 * safezoneW + safezoneX;
    y = 0.401 * safezoneH + safezoneY;
    w = 0.0257812 * safezoneW;
    h = 0.0539 * safezoneH;
    font = "TFAR_font_segments";
    shadow = 1;
    tooltip = ECSTRING(core,current_channel);
    canModify = 0;
};
class stereo: HiddenButton
{
    idc = IDC_FADAK_STEREO;
    x = 0.157625 * safezoneW + safezoneX;
    y = 0.6738 * safezoneH + safezoneY;
    w = 0.0164063 * safezoneW;
    h = 0.0252056 * safezoneH;
    action = QUOTE([ARR_2(TF_sw_dialog_radio, ((TF_sw_dialog_radio call TFAR_fnc_getCurrentSwStereo) + 1) mod TFAR_MAX_STEREO)] call TFAR_fnc_setSwStereo;[TF_sw_dialog_radio] call TFAR_fnc_showRadioVolume;);
    tooltip = ECSTRING(core,stereo_settings);
};
class channel_switch: HiddenRotator
{
    idc = IDC_FADAK_NEXT_CHANNEL;
    x = 0.167937 * safezoneW + safezoneX;
    y = 0.2624 * safezoneH + safezoneY;
    w = 0.0236227 * safezoneW;
    h = 0.0518116 * safezoneH;
    tooltip = ECSTRING(core,rotator_channel);
    onMouseButtonDown ="[_this select 1, false] call TFAR_fnc_setChannelViaDialog;";
};
class speakers: HiddenButton
{
    idc = IDC_FADAK_SPEAKERS;
    x = 0.156078 * safezoneW + safezoneX;
    y = 0.61 * safezoneH + safezoneY;
    w = 0.0175312 * safezoneW;
    h = 0.0319 * safezoneH;
    tooltip = ECSTRING(core,speakers_settings_true);
    action = "[TF_sw_dialog_radio] call TFAR_fnc_setSwSpeakers;[TF_sw_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
};
