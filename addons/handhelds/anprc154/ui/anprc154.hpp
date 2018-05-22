/* #Ligena
$[
    1.063,
    ["anprc154",[["0","0","1","1"],"0.0025","0.004","GUI_GRID"],0,1,1],
    [1200,"background",[1,"task_force_radio\anprc154\anprc154.paa",["0.0377135 * safezoneW + safezoneX","-0.682247 * safezoneH + safezoneY","0.246984 * safezoneW","1.6863 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1602,"prev_channel",[1,"",["0.127203 * safezoneW + safezoneX","0.5869 * safezoneH + safezoneY","0.0273146 * safezoneW","0.0549882 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Previous channel","-1"],[]],
    [1603,"next_channel",[1,"",["0.127203 * safezoneW + safezoneX","0.5011 * safezoneH + safezoneY","0.0278437 * safezoneW","0.0528 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Next channel","-1"],[]],
    [1604,"increase_volume",[1,"",["0.180828 * safezoneW + safezoneX","0.5011 * safezoneH + safezoneY","0.02783 * safezoneW","0.0505892 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Increase volume","-1"],[]],
    [1605,"decrease_volume",[1,"",["0.180299 * safezoneW + safezoneX","0.593489 * safezoneH + safezoneY","0.0262969 * safezoneW","0.0484 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Decrease volume","-1"],[]],
    [1606,"stereo",[1,"",["0.132359 * safezoneW + safezoneX","0.6628 * safezoneH + safezoneY","0.0309222 * safezoneW","0.0395915 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Stereo settings","-1"],[]],
    [1600,"reset_channel",[1,"",["0.157109 * safezoneW + safezoneX","0.5528 * safezoneH + safezoneY","0.0190781 * safezoneW","0.0374 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Increase volume","-1"],[]],
    [1601,"reset_channel_alt",[1,"",["0.132875 * safezoneW + safezoneX","0.7849 * safezoneH + safezoneY","0.0262838 * safezoneW","0.0428908 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Increase volume","-1"],[]],
    [1607,"speakers",[1,"",["0.115019 * safezoneW + safezoneX","0.186567 * safezoneH + safezoneY","0.0324844 * safezoneW","0.1089 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1201,"microdagr_background",[1,"task_force_radio\microdagr\microdagr.paa",["0.217953 * safezoneW + safezoneX","-0.1611 * safezoneH + safezoneY","0.551203 * safezoneW","1.1484 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1400,"channel_edit",[1,"CH1",["0.437609 * safezoneW + safezoneX","0.3504 * safezoneH + safezoneY","0.0381562 * safezoneW","0.0528 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1401,"edit",[1,"448.9",["0.476281 * safezoneW + safezoneX","0.3504 * safezoneH + safezoneY","0.0613594 * safezoneW","0.0528 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1608,"clear",[1,"CLEAR",["0.435547 * safezoneW + safezoneX","0.4329 * safezoneH + safezoneY","0.0402187 * safezoneW","0.0517 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
    [1609,"enter",[1,"SET",["0.498453 * safezoneW + safezoneX","0.4318 * safezoneH + safezoneY","0.04125 * safezoneW","0.055 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/



class anprc154_radio_dialog
{
    idd = IDD_ANPRC152_RADIO_DIALOG;
    movingEnable = 1;
    controlsBackground[] = { };
    objects[] = { };
    onUnload = "['OnRadioOpen', [player, TF_sw_dialog_radio, false, 'anprc154_radio_dialog', false]] call TFAR_fnc_fireEventHandlers;";
    onLoad = QUOTE(if (sunOrMoon < 0.2) then {((_this select 0) displayCtrl TF_IDD_BACKGROUND) ctrlSetText 'PATHTOF(anprc154\ui\anprc154_n.paa)';((_this select 0) displayCtrl IDC_MICRODAGR_BACKGROUND) ctrlSetText 'PATHTOF(microdagr\ui\microdagr_n.paa)';};_this call TFAR_fnc_updateProgrammatorDialog;);
    controls[]=
    {
    	background,
    	prev_channel,
    	next_channel,
    	increase_volume,
    	decrease_volume,
    	stereo,
    	reset_channel,
    	reset_channel_alt,
    	speakers,
    	microdagr_background,
    	channel_edit,
    	edit,
    	clear,
    	enter
    };
    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT START (by Kavinsky, v1.063, #Piwoto)
    ////////////////////////////////////////////////////////

    class background: RscBackPicture
    {
    	idc = IDC_ANPRC154_BACKGROUND;
    	text = QPATHTOF(anprc154\ui\anprc154.paa);
    	x = 0.0377135 * safezoneW + safezoneX;
    	y = -0.682247 * safezoneH + safezoneY;
    	w = 0.246984 * safezoneW;
    	h = 1.6863 * safezoneH;
    	moving = 1;
    };
    class prev_channel: HiddenButton
    {
    	idc = IDC_ANPRC154_PREV_CHANNEL;
    	x = 0.127203 * safezoneW + safezoneX;
    	y = 0.5869 * safezoneH + safezoneY;
    	w = 0.0273146 * safezoneW;
    	h = 0.0549882 * safezoneH;
    	tooltip = ECSTRING(core,previous_channel);
    	action = "[0, false] call TFAR_fnc_setChannelViaDialog;";
    };
    class next_channel: HiddenButton
    {
    	idc = IDC_ANPRC154_NEXT_CHANNEL;
    	x = 0.127203 * safezoneW + safezoneX;
    	y = 0.5011 * safezoneH + safezoneY;
    	w = 0.0278437 * safezoneW;
    	h = 0.0528 * safezoneH;
    	tooltip = ECSTRING(core,next_channel);
    	action = "[1, false] call TFAR_fnc_setChannelViaDialog;";
    };
    class increase_volume: HiddenButton
    {
    	idc = IDC_ANPRC154_INCREASE_VOLUME;
    	x = 0.180828 * safezoneW + safezoneX;
    	y = 0.5011 * safezoneH + safezoneY;
    	w = 0.02783 * safezoneW;
    	h = 0.0505892 * safezoneH;
    	tooltip = ECSTRING(core,increase_volume);
    	action = "[1, false] call TFAR_fnc_setVolumeViaDialog;";
    };
    class decrease_volume: HiddenButton
    {
    	idc = IDC_ANPRC154_DECREASE_VOLUME;
    	x = 0.180299 * safezoneW + safezoneX;
    	y = 0.593489 * safezoneH + safezoneY;
    	w = 0.0262969 * safezoneW;
    	h = 0.0484 * safezoneH;
    	tooltip = ECSTRING(core,decrease_volume);
    	action = "[0, false] call TFAR_fnc_setVolumeViaDialog;";
    };
    class stereo: HiddenButton
    {
    	idc = IDC_ANPRC154_STEREO;
    	x = 0.132359 * safezoneW + safezoneX;
    	y = 0.6628 * safezoneH + safezoneY;
    	w = 0.0309222 * safezoneW;
    	h = 0.0395915 * safezoneH;
    	action = QUOTE([ARR_2(TF_sw_dialog_radio, ((TF_sw_dialog_radio call TFAR_fnc_getCurrentSwStereo) + 1) mod TFAR_MAX_STEREO)] call TFAR_fnc_setSwStereo;[TF_sw_dialog_radio] call TFAR_fnc_showRadioVolume;);
    	tooltip = ECSTRING(core,stereo_settings);

    };
    class reset_channel: HiddenButton
    {
    	idc = IDC_ANPRC154_RESET_CHANNEL;
    	x = 0.157109 * safezoneW + safezoneX;
    	y = 0.5528 * safezoneH + safezoneY;
    	w = 0.0190781 * safezoneW;
    	h = 0.0374 * safezoneH;
    	tooltip = ECSTRING(core,radio_channel_1);
    	action = "[TF_sw_dialog_radio, 0] call TFAR_fnc_setSwChannel; call TFAR_fnc_updateSWDialogToChannel;[TF_sw_dialog_radio, false] call TFAR_fnc_showRadioInfo;";
    };
    class reset_channel_alt: HiddenButton
    {
    	idc = IDC_ANPRC154_RESET_CHANNEL_ALT;
    	x = 0.132875 * safezoneW + safezoneX;
    	y = 0.7849 * safezoneH + safezoneY;
    	w = 0.0262838 * safezoneW;
    	h = 0.0428908 * safezoneH;
    	tooltip = ECSTRING(core,radio_channel_1);
    	action = "[TF_sw_dialog_radio, 0] call TFAR_fnc_setSwChannel; call TFAR_fnc_updateSWDialogToChannel;[TF_sw_dialog_radio, false] call TFAR_fnc_showRadioInfo;";
    };
    class speakers: HiddenRotator
    {
    	idc = IDC_ANPRC154_SPEAKERS;
    	x = 0.115019 * safezoneW + safezoneX;
    	y = 0.186567 * safezoneH + safezoneY;
    	w = 0.0324844 * safezoneW;
    	h = 0.1089 * safezoneH;
    	tooltip = ECSTRING(core,speakers_settings_true);
    	action = "playSound 'TFAR_rotatorPush';[TF_sw_dialog_radio] call TFAR_fnc_setSwSpeakers;[TF_sw_dialog_radio] call TFAR_fnc_showRadioSpeakers;";
    };
    class microdagr_background: RscBackPicture
    {
    	idc = IDC_MICRODAGR_BACKGROUND;
    	text = QPATHTOF(microdagr\ui\microdagr.paa);
    	x = 0.217953 * safezoneW + safezoneX;
    	y = -0.1611 * safezoneH + safezoneY;
    	w = 0.551203 * safezoneW;
    	h = 1.1484 * safezoneH;
    	moving = 1;
    };
    class channel_edit: RscEditLCD
    {
    	idc = IDC_MICRODAGR_CHANNEL_EDIT;
    	text = "CH1";
    	x = 0.437609 * safezoneW + safezoneX;
    	y = 0.3504 * safezoneH + safezoneY;
    	w = 0.0381562 * safezoneW;
    	h = 0.0528 * safezoneH;
    	moving = 1;
    	font = "TFAR_font_dots";
    	shadow = 2;
    	canModify = 0;
    	tooltip = ECSTRING(core,current_channel);
    };
    class edit: RscEditLCD
    {
    	idc = IDC_MICRODAGR_EDIT;
    	text = "";
    	x = 0.476281 * safezoneW + safezoneX;
    	y = 0.3504 * safezoneH + safezoneY;
    	w = 0.0613594 * safezoneW;
    	h = 0.0528 * safezoneH;
    	moving = 1;
    	font = "TFAR_font_dots";
    	shadow = 2;
    	canModify = 1;
    	tooltip = ECSTRING(core,current_freq);
    };
    class clear: HiddenButton
    {
    	idc = IDC_MICRODAGR_CLEAR;
    	text = "CLR";
    	x = 0.435547 * safezoneW + safezoneX;
    	y = 0.4329 * safezoneH + safezoneY;
    	w = 0.0402187 * safezoneW;
    	h = 0.0517 * safezoneH;
    	tooltip = ECSTRING(core,clear_frequency);
    	font = "TFAR_font_dots";
    	shadow = 2;
    	action = QUOTE(ctrlSetText [ARR_2(IDC_MICRODAGR_EDIT, '')];ctrlSetFocus ((findDisplay IDD_ANPRC152_RADIO_DIALOG) displayCtrl IDC_MICRODAGR_EDIT););
    };
    class enter: HiddenButton
    {
    	idc = IDC_MICRODAGR_ENTER;
    	text = "ENT";
    	x = 0.498453 * safezoneW + safezoneX;
    	y = 0.4318 * safezoneH + safezoneY;
    	w = 0.04125 * safezoneW;
    	h = 0.055 * safezoneH;
    	tooltip = ECSTRING(core,set_frequency);
    	font = "TFAR_font_dots";
    	shadow = 2;
		onButtonClick = QUOTE([((ctrlParent (_this select 0))) displayCtrl IDC_MICRODAGR_EDIT] call TFAR_handhelds_fnc_onButtonClick_Enter;);
		action = "";
    };

    ////////////////////////////////////////////////////////
    // GUI EDITOR OUTPUT END
    ////////////////////////////////////////////////////////
};
