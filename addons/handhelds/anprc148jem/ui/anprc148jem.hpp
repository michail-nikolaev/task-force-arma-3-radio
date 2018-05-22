/* #Refubu
$[
    1.063,
    ["anprc148jem",[["0","0","1","1"],"0.0025","0.004","GUI_GRID"],0,1,1],
    [1200,"",[1,"task_force_radio\anprc148jem\148.paa",["0.0447031 * safezoneW + safezoneX","-1.0488 * safezoneH + safezoneY","0.302156 * safezoneW","2.0537 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1600,"enter",[1,"",["0.204031 * safezoneW + safezoneX","0.5352 * safezoneH + safezoneY","0.0275625 * safezoneW","0.0266059 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Set frequency","-1"],[]],
    [1601,"clear",[1,"",["0.204031 * safezoneW + safezoneX","0.5011 * safezoneH + safezoneY","0.0249375 * safezoneW","0.0280062 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Clear frequency","-1"],[]],
    [1400,"edit",[1,"188.8",["0.163812 * safezoneW + safezoneX","0.4021 * safezoneH + safezoneY","0.0634219 * safezoneW","0.0682 * safezoneH"],[0,0,0,1],[0,0,0,1],[0,0,0,1],"Current frequency","-1"],[]],
    [1401,"channel_edit",[1,"C3",["0.134422 * safezoneW + safezoneX","0.402215 * safezoneH + safezoneY","0.0304219 * safezoneW","0.0682 * safezoneH"],[0,0,0,1],[0,0,0,1],[0,0,0,1],"Current channel","-1"],[]],
    [1602,"prev_channel",[1,"",["0.131328 * safezoneW + safezoneX","0.5319 * safezoneH + safezoneY","0.023625 * safezoneW","0.0280062 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Previous channel","-1"],[]],
    [1603,"next_channel",[1,"",["0.168453 * safezoneW + safezoneX","0.5341 * safezoneH + safezoneY","0.0249375 * safezoneW","0.0280062 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Next channel","-1"],[]],
    [1604,"additional",[1,"",["0.168969 * safezoneW + safezoneX","0.5011 * safezoneH + safezoneY","0.0242813 * safezoneW","0.0294066 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Increase volume","-1"],[]],
    [1605,"speakers",[1,"",["0.132359 * safezoneW + safezoneX","0.5022 * safezoneH + safezoneY","0.0269063 * safezoneW","0.0266059 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Decrease volume","-1"],[]],
    [1606,"stereo",[1,"",["0.128234 * safezoneW + safezoneX","0.5726 * safezoneH + safezoneY","0.0201094 * safezoneW","0.0363 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Stereo settings","-1"],[]],
    [1607,"volume_Switch",[1,"",["0.191656 * safezoneW + safezoneX","0.1139 * safezoneH + safezoneY","0.045375 * safezoneW","0.0539 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1608,"channel_Switch",[1,"",["0.11225 * safezoneW + safezoneX","0.1458 * safezoneH + safezoneY","0.0293906 * safezoneW","0.0407 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/




class anprc148jem_radio_dialog
{
    idd = IDD_ANPRC148JEM_RADIO_DIALOG;
    movingEnable = 1;
    controlsBackground[] = { };
    objects[] = { };
    onUnload = "['OnRadioOpen', [player, TF_sw_dialog_radio, false, 'anprc148jem_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
    onLoad = QUOTE(if (sunOrMoon < 0.2) then {((_this select 0) displayCtrl TF_IDD_BACKGROUND) ctrlSetText 'PATHTOF(anprc148jem\ui\148_n.paa)';};);
    controls[]=
{
    background,
    enter,
    clear,
    edit,
    channel_edit,
    prev_channel,
    next_channel,
    additional,
    speakers,
    stereo,
    volume_Switch,
    channel_Switch
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by [TF]Nkey, v1.063, #Horegy)
////////////////////////////////////////////////////////

class background: RscBackPicture
{
    idc = IDC_ANPRC148JEM_BACKGROUND;
    text = QPATHTOF(anprc148jem\ui\148.paa);
    x = 0.0447031 * safezoneW + safezoneX;
    y = -1.0488 * safezoneH + safezoneY;
    w = 0.302156 * safezoneW;
    h = 2.0537 * safezoneH;
    moving = 1;
};
class enter: HiddenButton
{
    idc = IDC_ANPRC148JEM_ENTER;
    x = 0.204031 * safezoneW + safezoneX;
    y = 0.5352 * safezoneH + safezoneY;
    w = 0.0275625 * safezoneW;
    h = 0.0266059 * safezoneH;
    tooltip = ECSTRING(core,set_frequency);
    onButtonClick = QUOTE([((ctrlParent (_this select 0))) displayCtrl IDC_ANPRC148JEM_EDIT] call TFAR_handhelds_fnc_onButtonClick_Enter;);
    action = "";
};
class clear: HiddenButton
{
    idc = IDC_ANPRC148JEM_CLEAR;
    x = 0.204031 * safezoneW + safezoneX;
    y = 0.5011 * safezoneH + safezoneY;
    w = 0.0249375 * safezoneW;
    h = 0.0280062 * safezoneH;
    tooltip = ECSTRING(core,clear_frequency);
    action = QUOTE(ctrlSetText [ARR_2(IDC_ANPRC148JEM_EDIT, '')];ctrlSetFocus ((findDisplay IDD_ANPRC148JEM_RADIO_DIALOG) displayCtrl IDC_ANPRC148JEM_EDIT););
};
class edit: RscEditLCD
{
    idc = IDC_ANPRC148JEM_EDIT;
    x = 0.163812 * safezoneW + safezoneX;
    y = 0.4021 * safezoneH + safezoneY;
    w = 0.0634219 * safezoneW;
    h = 0.0682 * safezoneH;
    font = "TFAR_font_dots";
    shadow = 2;
    tooltip = ECSTRING(core,current_freq);
    canModify = 1;
    moving = 1;
};
class channel_edit: RscEditLCD
{
    idc = IDC_ANPRC148JEM_CHANNEL_EDIT;
    x = 0.134422 * safezoneW + safezoneX;
    y = 0.402215 * safezoneH + safezoneY;
    w = 0.0304219 * safezoneW;
    h = 0.0682 * safezoneH;
    font = "TFAR_font_dots";
    shadow = 2;
    tooltip = ECSTRING(core,current_channel);
    canModify = 0;
    moving = 1;
};
class prev_channel: HiddenButton
{
    idc = IDC_ANPRC148JEM_PREV_CHANNEL;
    x = 0.131328 * safezoneW + safezoneX;
    y = 0.5319 * safezoneH + safezoneY;
    w = 0.023625 * safezoneW;
    h = 0.0280062 * safezoneH;
    tooltip = ECSTRING(core,previous_channel);
    action = "[0, false] call TFAR_fnc_setChannelViaDialog;";
};
class next_channel: HiddenButton
{
    idc = IDC_ANPRC148JEM_NEXT_CHANNEL;
    x = 0.168453 * safezoneW + safezoneX;
    y = 0.5341 * safezoneH + safezoneY;
    w = 0.0249375 * safezoneW;
    h = 0.0280062 * safezoneH;
    tooltip = ECSTRING(core,next_channel);
    action = "[1, false] call TFAR_fnc_setChannelViaDialog;";
};
class additional: HiddenButton
{
    idc = IDC_ANPRC148JEM_INCREASE_VOLUME;
    x = 0.168969 * safezoneW + safezoneX;
    y = 0.5011 * safezoneH + safezoneY;
    w = 0.0242813 * safezoneW;
    h = 0.0294066 * safezoneH;
    tooltip = ECSTRING(core,set_additional);
    action = "[TF_sw_dialog_radio, TF_sw_dialog_radio call TFAR_fnc_getSwChannel] call TFAR_fnc_setAdditionalSwChannel; call TFAR_fnc_updateSWDialogToChannel; [TF_sw_dialog_radio, false] call TFAR_fnc_showRadioInfo;";
};
class speakers: HiddenButton
{
    idc = IDC_ANPRC148JEM_DECREASE_VOLUME;
    x = 0.132359 * safezoneW + safezoneX;
    y = 0.5022 * safezoneH + safezoneY;
    w = 0.0269063 * safezoneW;
    h = 0.0266059 * safezoneH;
    tooltip = ECSTRING(core,speakers_settings_true);
    action = "[TF_sw_dialog_radio] call TFAR_fnc_setSwSpeakers;[TF_sw_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
};
class stereo: HiddenButton
{
    idc = IDC_ANPRC148JEM_STEREO;
    x = 0.128234 * safezoneW + safezoneX;
    y = 0.5726 * safezoneH + safezoneY;
    w = 0.0201094 * safezoneW;
    h = 0.0363 * safezoneH;
    action = QUOTE([ARR_2(TF_sw_dialog_radio, ((TF_sw_dialog_radio call TFAR_fnc_getCurrentSwStereo) + 1) mod TFAR_MAX_STEREO)] call TFAR_fnc_setSwStereo;[TF_sw_dialog_radio] call TFAR_fnc_showRadioVolume;);
    tooltip = ECSTRING(core,stereo_settings);
};
class volume_Switch: HiddenRotator
{
    idc = IDC_ANPRC148JEM_ADDITIONAL;
    x = 0.191656 * safezoneW + safezoneX;
    y = 0.1139 * safezoneH + safezoneY;
    w = 0.045375 * safezoneW;
    h = 0.0539 * safezoneH;
    tooltip = ECSTRING(core,rotator_volume);
    onMouseButtonDown = "[_this select 1, false] call TFAR_fnc_setVolumeViaDialog;";
};
class channel_Switch: HiddenRotator
{
    idc = IDC_ANPRC148JEM_SPEAKERS;
    x = 0.11225 * safezoneW + safezoneX;
    y = 0.1458 * safezoneH + safezoneY;
    w = 0.0293906 * safezoneW;
    h = 0.0407 * safezoneH;
    tooltip = ECSTRING(core,rotator_channel);
    onMouseButtonDown ="[_this select 1, false] call TFAR_fnc_setChannelViaDialog;";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
};
