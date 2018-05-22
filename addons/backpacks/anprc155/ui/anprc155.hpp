/* #Mibypo
$[
    1.063,
    ["anprc155",[["0","0","1","1"],"0.0025","0.004","GUI_GRID"],0,1,1],
    [1200,"background",[1,"task_force_radio\anprc155\155.paa",["0.0869844 * safezoneW + safezoneX","-0.1182 * safezoneH + safezoneY","0.634594 * safezoneW","1.10205 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1400,"channel_edit",[1,"CH:3",["0.337578 * safezoneW + safezoneX","0.3416 * safezoneH + safezoneY","0.0485625 * safezoneW","0.0658147 * safezoneH"],[0,0,0,1],[0,0,0,1],[0,0,0,1],"Current channel","-1"],[]],
    [1401,"edit",[1,"88.8",["0.374187 * safezoneW + safezoneX","0.3416 * safezoneH + safezoneY","0.0427969 * safezoneW","0.066 * safezoneH"],[0,0,0,1],[0,0,0,1],[0,0,0,1],"Current frequency","-1"],[]],
    [1600,"enter",[1,"",["0.4175 * safezoneW + safezoneX","0.5066 * safezoneH + safezoneY","0.0185625 * safezoneW","0.0209 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Set frequency","-1"],[]],
    [1601,"clear",[1,"",["0.408781 * safezoneW + safezoneX","0.473394 * safezoneH + safezoneY","0.0180469 * safezoneW","0.0286 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Clear frequency","-1"],[]],
    [1602,"prev_channel",[1,"",["0.362844 * safezoneW + safezoneX","0.537808 * safezoneH + safezoneY","0.02625 * safezoneW","0.0294066 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Previous channel","-1"],[]],
    [1603,"next_channel",[1,"",["0.362844 * safezoneW + safezoneX","0.470593 * safezoneH + safezoneY","0.0249375 * safezoneW","0.0280062 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1604,"volume_Switch",[1,"",["0.224656 * safezoneW + safezoneX","0.2987 * safezoneH + safezoneY","0.0458906 * safezoneW","0.0836 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Change volume","-1"],[]],
    [1605,"stereo",[1,"",["0.324687 * safezoneW + safezoneX","0.5363 * safezoneH + safezoneY","0.0180469 * safezoneW","0.0275 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1606,"additional",[1,"",["0.315406 * safezoneW + safezoneX","0.5055 * safezoneH + safezoneY","0.0190781 * safezoneW","0.0275 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1607,"speakers",[1,"",["0.408219 * safezoneW + safezoneX","0.5374 * safezoneH + safezoneY","0.0190781 * safezoneW","0.0242 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/

class anprc155_radio_dialog
{
    idd = IDD_ANPRC155_RADIO_DIALOG;
    movingEnable = 1;
    controlsBackground[] = { };
    objects[] = { };
    onUnload = "['OnRadioOpen', [player, TF_lr_dialog_radio, true, 'anprc155_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
    onLoad = QUOTE(if(sunOrMoon < 0.2) then {((_this select 0) displayCtrl TF_IDD_BACKGROUND) ctrlSetText 'PATHTOF(anprc155\ui\155_n.paa)';};);
controls[]=
{
    background,
    enter,
    channel_edit,
    edit,
    clear,
    prev_channel,
    next_channel,
    volume_Switch,
    stereo,
    additional,
    speakers
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by [TF]Nkey, v1.063, #Telovy)
////////////////////////////////////////////////////////

class background: RscBackPicture
{
    idc = IDC_ANPRC155_BACKGROUND;
    text = QPATHTOF(anprc155\ui\155.paa);
    x = 0.0869844 * safezoneW + safezoneX;
    y = -0.1182 * safezoneH + safezoneY;
    w = 0.634594 * safezoneW;
    h = 1.10205 * safezoneH;
    moving = 1;
};
class channel_edit: RscEditLCD
{
    idc = IDC_ANPRC155_CHANNEL_EDIT;
    x = 0.337578 * safezoneW + safezoneX;
    y = 0.3416 * safezoneH + safezoneY;
    w = 0.0485625 * safezoneW;
    h = 0.0658147 * safezoneH;
    font = "TFAR_font_segments";
    tooltip = ECSTRING(core,current_channel);
    moving = 1;
    canModify = 0;
};
class edit: RscEditLCD
{
    idc = IDC_ANPRC155_EDIT;
    x = 0.374187 * safezoneW + safezoneX;
    y = 0.3416 * safezoneH + safezoneY;
    w = 0.0427969 * safezoneW;
    h = 0.066 * safezoneH;
    font = "TFAR_font_segments";
    tooltip = ECSTRING(core,current_freq);
    moving = 1;
    canModify = 1;
};
class enter: HiddenButton
{
    idc = IDC_ANPRC155_ENTER;
    x = 0.4175 * safezoneW + safezoneX;
    y = 0.5066 * safezoneH + safezoneY;
    w = 0.0185625 * safezoneW;
    h = 0.0209 * safezoneH;
    tooltip = ECSTRING(core,set_frequency);
    onButtonClick = QUOTE([((ctrlParent (_this select 0))) displayCtrl IDC_ANPRC155_EDIT] call TFAR_handhelds_fnc_onButtonClick_Enter;);
    action = "";
};
class clear: HiddenButton
{
    idc = IDC_ANPRC155_CLEAR;
    x = 0.408781 * safezoneW + safezoneX;
    y = 0.473394 * safezoneH + safezoneY;
    w = 0.0180469 * safezoneW;
    h = 0.0286 * safezoneH;
    tooltip = ECSTRING(core,clear_frequency);
    action = QUOTE(ctrlSetText [ARR_2(IDC_ANPRC155_EDIT, '')];ctrlSetFocus ((findDisplay IDD_ANPRC155_RADIO_DIALOG) displayCtrl IDC_ANPRC155_EDIT););
};
class prev_channel: HiddenButton
{
    idc = IDC_ANPRC155_PREV_CHANNEL;
    x = 0.362844 * safezoneW + safezoneX;
    y = 0.537808 * safezoneH + safezoneY;
    w = 0.02625 * safezoneW;
    h = 0.0294066 * safezoneH;
    tooltip = ECSTRING(core,previous_channel);
    action = "[0, true] call TFAR_fnc_setChannelViaDialog;";
};
class next_channel: HiddenButton
{
    idc = IDC_ANPRC155_NEXT_CHANNEL;
    x = 0.362844 * safezoneW + safezoneX;
    y = 0.470593 * safezoneH + safezoneY;
    w = 0.0249375 * safezoneW;
    h = 0.0280062 * safezoneH;
    tooltip = ECSTRING(core,next_channel);
    action = "[1, true] call TFAR_fnc_setChannelViaDialog;";
};
class volume_Switch: HiddenRotator
{
    idc = IDC_ANPRC155_INCREASE_VOLUME;
    x = 0.224656 * safezoneW + safezoneX;
    y = 0.2987 * safezoneH + safezoneY;
    w = 0.0458906 * safezoneW;
    h = 0.0836 * safezoneH;
    tooltip = ECSTRING(core,rotator_volume);
    onMouseButtonDown = "[_this select 1, true] call TFAR_fnc_setVolumeViaDialog;";
};
class stereo: HiddenButton
{
    idc = IDC_ANPRC155_STEREO;
    x = 0.324687 * safezoneW + safezoneX;
    y = 0.5363 * safezoneH + safezoneY;
    w = 0.0180469 * safezoneW;
    h = 0.0275 * safezoneH;
    action = QUOTE([ARR_2(TF_lr_dialog_radio, ((TF_lr_dialog_radio call TFAR_fnc_getCurrentLrStereo) + 1) mod TFAR_MAX_STEREO)] call TFAR_fnc_setLrStereo;[TF_lr_dialog_radio] call TFAR_fnc_showRadioVolume;);
    tooltip = ECSTRING(core,stereo_settings);
};
class additional: HiddenButton
{
    idc = IDC_ANPRC155_ADDITIONAL;
    x = 0.315406 * safezoneW + safezoneX;
    y = 0.5055 * safezoneH + safezoneY;
    w = 0.0190781 * safezoneW;
    h = 0.0275 * safezoneH;
    tooltip = ECSTRING(core,set_additional);
    action = "[TF_lr_dialog_radio,TF_lr_dialog_radio call TFAR_fnc_getLrChannel] call TFAR_fnc_setAdditionalLrChannel; call TFAR_fnc_updateLRDialogToChannel; [TF_lr_dialog_radio, true] call TFAR_fnc_showRadioInfo;";
};
class speakers: HiddenButton
{
    idc = IDC_ANPRC155_SPEAKERS;
    x = 0.408219 * safezoneW + safezoneX;
    y = 0.5374 * safezoneH + safezoneY;
    w = 0.0190781 * safezoneW;
    h = 0.0242 * safezoneH;
    tooltip = ECSTRING(core,speakers_settings_true);
    action = "TF_lr_dialog_radio call TFAR_fnc_setLrSpeakers;[TF_lr_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
};
