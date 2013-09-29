#include "\task_force_radio\define.h"



/* #Tykiko
$[
	1.063,
	["anprc152_radio_dialog",[["0","0","1","1"],"0.001","0.001","GUI_GRID"],0,1,0],
	[1200,"",[1,"task_force_radio\anprc152\152.paa",["0.0543875 * safezoneW + safezoneX","0.0265282 * safezoneH + safezoneY","0.143438 * safezoneW","0.901041 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1400,"",[1,"",["0.114312 * safezoneW + safezoneX","0.387795 * safezoneH + safezoneY","0.0653438 * safezoneW","0.043352 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[1,"",["0.156387 * safezoneW + safezoneX","0.462598 * safezoneH + safezoneY","0.0159375 * safezoneW","0.0182758 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"",[1,"",["0.156706 * safezoneW + safezoneX","0.49235 * safezoneH + safezoneY","0.0172125 * safezoneW","0.020826 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1602,"",[1,"",["0.106662 * safezoneW + safezoneX","0.553978 * safezoneH + safezoneY","0.0172125 * safezoneW","0.020826 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1603,"",[1,"",["0.131844 * safezoneW + safezoneX","0.553978 * safezoneH + safezoneY","0.01785 * safezoneW","0.0204009 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1401,"",[1,"",["0.0744687 * safezoneW + safezoneX","0.38737 * safezoneH + safezoneY","0.0398438 * safezoneW","0.042927 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1604,"",[1,"",["0.157344 * safezoneW + safezoneX","0.526776 * safezoneH + safezoneY","0.0162563 * safezoneW","0.0191259 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Increase volume","-1"],[]],
	[1605,"",[1,"",["0.157025 * safezoneW + safezoneX","0.553553 * safezoneH + safezoneY","0.0159375 * safezoneW","0.0195509 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Decrease volume","-1"],[]]
]
*/





///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////
class RscBackPicture
{
	access = 0;
	type = 0;
	idc = -1;
	style = 48;
	colorBackground[] = 
	{
		0,
		0,
		0,
		0
	};
	colorText[] = 
	{
		1,
		1,
		1,
		1
	};
	font = "TahomaB";
	sizeEx = 0;
	lineSpacing = 0;
	text = "";
	fixedWidth = 0;
	shadow = 0;
	x = 0;
	y = 0;
	w = 0.2;
	h = 0.15;
};
class RscEditLCD
{
	access = 0;
	type = 2;
	x = 0;
	y = 0;
	h = 0.04;
	w = 0.2;
	colorBackground[] = 
	{
		0,
		0,
		0,
		1
	};
	colorText[] = 
	{
		0,
		0,
		0,
		1
	};
	colorDisabled[] = 
	{
		1,
		1,
		1,
		0.25
	};
	colorSelection[] = 
	{
		"(profilenamespace getvariable ['GUI_BCG_RGB_R',0.69])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_G',0.75])",
		"(profilenamespace getvariable ['GUI_BCG_RGB_B',0.5])",
		1
	};
	autocomplete = "";
	text = "";
	size = 0.2;
	style = "0x00 + 0x40 + 0x200";
	font = "puristalight"; 
	shadow = 2;
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2)";
};
class HiddenButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {
			0, 0, 0, 0
	};
	colorDisabled[] = {
			0, 0, 0, 0
	};
	colorBackground[] = {
			0, 0, 0, 0
	};
	colorBackgroundDisabled[] = {
			0, 0, 0, 0
	};
	colorBackgroundActive[] = {
			0, 0, 0, 0
	};
	colorFocused[] = {
			0, 0, 0, 0
	};
	colorShadow[] = {
			0, 0, 0, 0
	};
	colorBorder[] = {
			0, 0, 0, 0
	};

	soundEnter[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundEnter",
		0.09,
		1
	};
	soundPush[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundPush",
		0.09,
		1
	};
	soundClick[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundClick",
		0.09,
		1
	};
	soundEscape[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundEscape",
		0.09,
		1
	};
	style = 2;
	x = 0;
	y = 0;
	w = 0.095589;
	h = 0.039216;
	shadow = 2;
	font = "PuristaMedium";
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	offsetX = 0.003;
	offsetY = 0.003;
	offsetPressedX = 0.002;
	offsetPressedY = 0.002;
	borderSize = 0;
};


class anprc152_radio_dialog 
{
	idd = IDC_ANPRC152_RADIO_DIALOG;
	movingEnable = 1;
	controlsBackground[] = { };
	objects[] = { };
	controls[]=
{
	background,
	enter,
	edit,
	channel_edit,
	clear,
	prev_channel,
	next_channel,
	increase_volume,
	decrease_volume	
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by [TF]Nkey, v1.062, #Gicyfo)
////////////////////////////////////////////////////////

class background: RscBackPicture
{
	idc = IDC_ANPRC152_RADIO_DIALOG_BACKGROUND;
	text = "\task_force_radio\anprc152\152.paa";
	x = 0.0543875 * safezoneW + safezoneX;
	y = 0.0265282 * safezoneH + safezoneY;
	w = 0.143438 * safezoneW;
	h = 0.901041 * safezoneH;
	moving = 1;
};
class edit: RscEditLCD
{
	moving = 1;
	idc = IDC_ANPRC152_RADIO_DIALOG_EDIT;
	x = 0.114312 * safezoneW + safezoneX;
	y = 0.387795 * safezoneH + safezoneY;
	w = 0.0653438 * safezoneW;
	h = 0.043352 * safezoneH;
	tooltip = $STR_current_freq;
	canModify = 1;
};
class channel_edit: RscEditLCD
{
	moving = 1;
	idc = IDC_ANPRC152_RADIO_DIALOG_CHANNEL_EDIT;
	x = 0.0744687 * safezoneW + safezoneX;
	y = 0.38737 * safezoneH + safezoneY;
	w = 0.0398438 * safezoneW;
	h = 0.042927 * safezoneH;
	tooltip = $STR_current_channel;
	canModify = 0;
};
class enter: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_ENTER;
	x = 0.156706 * safezoneW + safezoneX;
	y = 0.49235 * safezoneH + safezoneY;
	w = 0.0172125 * safezoneW;
	h = 0.020826 * safezoneH;
	tooltip = $STR_set_frequency;
	action = "_f = parseNumber(ctrlText IDC_ANPRC152_RADIO_DIALOG_EDIT_ID);  if ((_f > MIN_SW_FREQ) and (_f < MAX_SW_FREQ)) then {sw_frequencies set[sw_active_channel, str (round (_f * FREQ_ROUND_POWER) / FREQ_ROUND_POWER)]; hintSilent '';} else {hint formatText [localize 'STR_incorrect_frequency', MIN_SW_FREQ, MAX_SW_FREQ]}; call updateSWDialogToChannel;";
};
class clear: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_CLEAR;
	x = 0.156387 * safezoneW + safezoneX;
	y = 0.462598 * safezoneH + safezoneY;
	w = 0.0159375 * safezoneW;
	h = 0.0182758 * safezoneH;
	tooltip = $STR_clear_frequency
	action = "ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT_ID, '']; ctrlSetFocus ((findDisplay IDC_ANPRC152_RADIO_DIALOG_ID) displayCtrl IDC_ANPRC152_RADIO_DIALOG_EDIT_ID);";
};
class next_channel: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_NEXT;
	x = 0.106662 * safezoneW + safezoneX;
	y = 0.553978 * safezoneH + safezoneY;
	w = 0.0172125 * safezoneW;
	h = 0.020826 * safezoneH;
	tooltip = $STR_previous_channel;
	action = "sw_active_channel = (sw_active_channel - 1 + MAX_CHANNELS) mod MAX_CHANNELS; call updateSWDialogToChannel;"
};
class prev_channel: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_PREV;
	x = 0.131844 * safezoneW + safezoneX;
	y = 0.553978 * safezoneH + safezoneY;
	w = 0.01785 * safezoneW;
	h = 0.0204009 * safezoneH;
	tooltip = $STR_next_channel;
	action = "sw_active_channel = (sw_active_channel + 1) mod MAX_CHANNELS; call updateSWDialogToChannel;"
};
class increase_volume: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_RSCBUTTON_INCREASE;
	x = 0.157344 * safezoneW + safezoneX;
	y = 0.526776 * safezoneH + safezoneY;
	w = 0.0162563 * safezoneW;
	h = 0.0191259 * safezoneH;
	action = "sw_volume_level = (sw_volume_level + 1) mod MAX_SW_VOLUME; hint formatText [localize 'STR_radio_volume', ((sw_volume_level + 1) * 10)];"
	tooltip = $STR_increase_volume;
};
class decrease_volume: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_RSCBUTTON_DECREASE;
	x = 0.157025 * safezoneW + safezoneX;
	y = 0.553553 * safezoneH + safezoneY;
	w = 0.0159375 * safezoneW;
	h = 0.0195509 * safezoneH;
	action = "sw_volume_level = (sw_volume_level - 1 + MAX_SW_VOLUME) mod MAX_SW_VOLUME; hint formatText [localize 'STR_radio_volume', ((sw_volume_level + 1) * 10)];"
	tooltip = $STR_decrease_volume;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////	

};


/* #Bebaca
$[
	1.063,
	["rt1523g",[["0","0","1","1"],"0.001","0.001","GUI_GRID"],0,1,0],
	[1200,"",[1,"task_force_radio\rt1523g\rt1523g.paa",["0.0935937 * safezoneW + safezoneX","0.159984 * safezoneH + safezoneY","0.502031 * safezoneW","0.612028 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1400,"",[1,"12.6",["0.356562 * safezoneW + safezoneX","0.363994 * safezoneH + safezoneY","0.0796875 * safezoneW","0.0510023 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","2"],[]],
	[1600,"",[1,"",["0.263806 * safezoneW + safezoneX","0.623256 * safezoneH + safezoneY","0.036975 * safezoneW","0.0403769 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"",[1,"",["0.400869 * safezoneW + safezoneX","0.470249 * safezoneH + safezoneY","0.0357 * safezoneW","0.0378267 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1401,"",[1,"",["0.266037 * safezoneW + safezoneX","0.363994 * safezoneH + safezoneY","0.0870188 * safezoneW","0.0510023 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1602,"",[1,"",["0.266994 * safezoneW + safezoneX","0.472799 * safezoneH + safezoneY","0.0306 * safezoneW","0.0378267 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1603,"",[1,"",["0.310344 * safezoneW + safezoneX","0.474499 * safezoneH + safezoneY","0.0334688 * safezoneW","0.0365517 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1604,"",[1,"",["0.356881 * safezoneW + safezoneX","0.475774 * safezoneH + safezoneY","0.031875 * safezoneW","0.0340016 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1605,"",[1,"",["0.266356 * safezoneW + safezoneX","0.525076 * safezoneH + safezoneY","0.0306 * safezoneW","0.0314514 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1606,"",[1,"",["0.310344 * safezoneW + safezoneX","0.525076 * safezoneH + safezoneY","0.0328313 * safezoneW","0.0340016 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1607,"",[1,"",["0.357519 * safezoneW + safezoneX","0.525076 * safezoneH + safezoneY","0.0306 * safezoneW","0.0340016 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1608,"",[1,"",["0.266356 * safezoneW + safezoneX","0.574378 * safezoneH + safezoneY","0.0312375 * safezoneW","0.0340016 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1609,"",[1,"",["0.311938 * safezoneW + safezoneX","0.575653 * safezoneH + safezoneY","0.0312375 * safezoneW","0.0327265 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1610,"",[1,"",["0.358156 * safezoneW + safezoneX","0.574378 * safezoneH + safezoneY","0.0312375 * safezoneW","0.0340016 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1611,"",[1,"",["0.4031 * safezoneW + safezoneX","0.576079 * safezoneH + safezoneY","0.0312375 * safezoneW","0.0327265 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Increase volume","-1"],[]],
	[1612,"",[1,"",["0.4031 * safezoneW + safezoneX","0.628356 * safezoneH + safezoneY","0.0302813 * safezoneW","0.0323015 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Decrease volume","-1"],[]]
]
*/





class rt1523g_radio_dialog 
{
	idd = IDC_RT1523G_RADIO_DIALOG;
	movingEnable = 1;
	controlsBackground[] = { };
	objects[] = { };
	controls[]=
{
	rt1523g_background,
	rt1523g_enter,
	rt1523g_edit,
	rt1523g_channel_edit,
	rt1523g_clear,
	rt1523g_channel01,
	rt1523g_channel02,
	rt1523g_channel03,
	rt1523g_channel04,
	rt1523g_channel05,
	rt1523g_channel06,
	rt1523g_channel07,
	rt1523g_channel08,
	rt1523g_channel09,
	rt1523g_increase_volume,
	rt1523g_decrease_volume
};

////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by [TF]Nkey, v1.062, #Wetyli)
////////////////////////////////////////////////////////

class rt1523g_background: RscBackPicture
{
	idc = IDC_RT1523G_RADIO_DIALOG_BACKGROUND;
	text = "\task_force_radio\rt1523g\rt1523g.paa";
	x = 0.0935937 * safezoneW + safezoneX;
	y = 0.159984 * safezoneH + safezoneY;
	w = 0.502031 * safezoneW;
	h = 0.612028 * safezoneH;
	moving = 1;
};
class rt1523g_edit: RscEditLCD
{
	moving = 1;
	idc = IDC_RT1523G_RADIO_DIALOG_EDIT;
	x = 0.356562 * safezoneW + safezoneX;
	y = 0.363994 * safezoneH + safezoneY;
	w = 0.0796875 * safezoneW;
	h = 0.0510023 * safezoneH;
	tooltip = $STR_current_freq;
	canModify = 1;
};
class rt1523g_channel_edit: RscEditLCD
{
	moving = 1;
	idc = IDC_RT1523G_RADIO_DIALOG_CHANNEL_EDIT;
	x = 0.266037 * safezoneW + safezoneX;
	y = 0.363994 * safezoneH + safezoneY;
	w = 0.0870188 * safezoneW;
	h = 0.0510023 * safezoneH;
	tooltip = $STR_current_channel;
	canModify = 0;
};
class rt1523g_clear: HiddenButton
{
	idc = IDC_RT1523G_RADIO_DIALOG_CLEAR;
	x = 0.263806 * safezoneW + safezoneX;
	y = 0.623256 * safezoneH + safezoneY;
	w = 0.036975 * safezoneW;
	h = 0.0403769 * safezoneH;
	tooltip = $STR_clear_frequency
	action = "ctrlSetText [IDC_RT1523G_RADIO_DIALOG_EDIT_ID, '']; ctrlSetFocus ((findDisplay IDC_RT1523G_RADIO_DIALOG_ID) displayCtrl IDC_RT1523G_RADIO_DIALOG_EDIT_ID);";
};
class rt1523g_enter: HiddenButton
{
	idc = IDC_RT1523G_RADIO_DIALOG_ENTER;
	x = 0.400869 * safezoneW + safezoneX;
	y = 0.470249 * safezoneH + safezoneY;
	w = 0.0357 * safezoneW;
	h = 0.0378267 * safezoneH;
	tooltip = $STR_set_frequency;
	action = "_f = parseNumber(ctrlText IDC_RT1523G_RADIO_DIALOG_EDIT_ID);  if ((_f > MIN_ASIP_FREQ) and (_f < MAX_ASIP_FREQ)) then {lr_frequencies set[lr_active_channel, str (round (_f * FREQ_ROUND_POWER) / FREQ_ROUND_POWER)]; hintSilent '';} else {hint formatText [localize 'STR_incorrect_frequency', MIN_ASIP_FREQ, MAX_ASIP_FREQ]}; call updateLRDialogToChannel;";
};
class rt1523g_channel01: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_01;
	x = 0.266994 * safezoneW + safezoneX;
	y = 0.472799 * safezoneH + safezoneY;
	w = 0.0306 * safezoneW;
	h = 0.0378267 * safezoneH;
	action = "lr_active_channel = 0; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_1;
};
class rt1523g_channel02: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_02;
	x = 0.310344 * safezoneW + safezoneX;
	y = 0.474499 * safezoneH + safezoneY;
	w = 0.0334688 * safezoneW;
	h = 0.0365517 * safezoneH;
	action = "lr_active_channel = 1; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_2;
};
class rt1523g_channel03: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_03;
	x = 0.356881 * safezoneW + safezoneX;
	y = 0.475774 * safezoneH + safezoneY;
	w = 0.031875 * safezoneW;
	h = 0.0340016 * safezoneH;
	action = "lr_active_channel = 2; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_3;
};
class rt1523g_channel04: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_04;
	x = 0.266356 * safezoneW + safezoneX;
	y = 0.525076 * safezoneH + safezoneY;
	w = 0.0306 * safezoneW;
	h = 0.0314514 * safezoneH;
	action = "lr_active_channel = 3; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_4;
};
class rt1523g_channel05: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_05;
	x = 0.310344 * safezoneW + safezoneX;
	y = 0.525076 * safezoneH + safezoneY;
	w = 0.0328313 * safezoneW;
	h = 0.0340016 * safezoneH;
	action = "lr_active_channel = 4; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_5;
};
class rt1523g_channel06: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_06;
	x = 0.357519 * safezoneW + safezoneX;
	y = 0.525076 * safezoneH + safezoneY;
	w = 0.0306 * safezoneW;
	h = 0.0340016 * safezoneH;
	action = "lr_active_channel = 5; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_6;
};
class rt1523g_channel07: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_07;
	x = 0.266356 * safezoneW + safezoneX;
	y = 0.574378 * safezoneH + safezoneY;
	w = 0.0312375 * safezoneW;
	h = 0.0340016 * safezoneH;
	action = "lr_active_channel = 6; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_7;
};
class rt1523g_channel08: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_08;
	x = 0.311938 * safezoneW + safezoneX;
	y = 0.575653 * safezoneH + safezoneY;
	w = 0.0312375 * safezoneW;
	h = 0.0327265 * safezoneH;
	action = "lr_active_channel = 7; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_8;
};
class rt1523g_channel09: HiddenButton
{
	idc = IDC_RT1523G_CHANNEL_09;
	x = 0.358156 * safezoneW + safezoneX;
	y = 0.574378 * safezoneH + safezoneY;
	w = 0.0312375 * safezoneW;
	h = 0.0340016 * safezoneH;
	action = "lr_active_channel = 8; call updateLRDialogToChannel;"
	tooltip = $STR_radio_channel_9;
};
class rt1523g_increase_volume: HiddenButton
{
	idc = IDC_RT1523G_RADIO_DIALOG_INCREASE_VOLUME;
	x = 0.4031 * safezoneW + safezoneX;
	y = 0.576079 * safezoneH + safezoneY;
	w = 0.0312375 * safezoneW;
	h = 0.0327265 * safezoneH;
	action = "lr_volume_level = (lr_volume_level + 1) mod MAX_LR_VOLUME; hint formatText [localize 'STR_radio_volume', ((lr_volume_level + 1) * 10)];"
	tooltip = $STR_increase_volume;
};
class rt1523g_decrease_volume: HiddenButton
{
	idc = IDC_RT1523G_RADIO_DIALOG_DECREASE_VOLUME;
	x = 0.4031 * safezoneW + safezoneX;
	y = 0.628356 * safezoneH + safezoneY;
	w = 0.0302813 * safezoneW;
	h = 0.0323015 * safezoneH;
	action = "lr_volume_level = (lr_volume_level - 1 + MAX_LR_VOLUME) mod MAX_LR_VOLUME; hint formatText [localize 'STR_radio_volume', ((lr_volume_level + 1) * 10)];"
	tooltip = $STR_decrease_volume;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
};


/* #Cumiwo
$[
	1.063,
	["diver_radio",[["0","0","1","1"],"0.0025","0.004","GUI_GRID"],0,1,0],
	[1200,"",[1,"task_force_radio\diver_radio\diver_radio.paa",["0.189219 * safezoneW + safezoneX","0.227987 * safezoneH + safezoneY","0.239063 * safezoneW","0.44202 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[1,"",["0.324688 * safezoneW + safezoneX","0.534002 * safezoneH + safezoneY","0.031875 * safezoneW","0.042502 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Set frequency","-1"],[]],
	[1601,"",[1,"",["0.254562 * safezoneW + safezoneX","0.537402 * safezoneH + safezoneY","0.0334687 * safezoneW","0.044202 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Clear frequency","-1"],[]],
	[1400,"",[1,"32.7",["0.274484 * safezoneW + safezoneX","0.394595 * safezoneH + safezoneY","0.0613594 * safezoneW","0.0833038 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Current frequency","-1"],[]],
	[1602,"",[1,"",["0.412344 * safezoneW + safezoneX","0.423497 * safezoneH + safezoneY","0.0119531 * safezoneW","0.0561026 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Volume level","-1"],[]],
	[1401,"",[1,"24",["0.253766 * safezoneW + safezoneX","0.488099 * safezoneH + safezoneY","0.0574531 * safezoneW","0.0391018 * safezoneH"],[0,0,0,1],[-1,-1,-1,-1],[-1,-1,-1,-1],"Current depth","-1"],[]]
]
*/


class diver_radio_dialog 
{
	idd = IDC_DIVER_RADIO_DIALOG;
	movingEnable = 1;
	controlsBackground[] = { };
	objects[] = { };
	controls[]=
{
	diver_background,
	diver_enter,
	diver_edit,
	diver_depth_edit,
	diver_clear,
	increase_volume
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT START (by [TF]Nkey, v1.063, #Nipifi)
////////////////////////////////////////////////////////

class diver_background: RscBackPicture
{
	idc = IDC_DIVER_RADIO_BACKGROUND;
	text = "\task_force_radio\diver_radio\diver_radio.paa";
	x = 0.189219 * safezoneW + safezoneX;
	y = 0.227987 * safezoneH + safezoneY;
	w = 0.239063 * safezoneW;
	h = 0.44202 * safezoneH;
	moving = 1;
};
class diver_enter: HiddenButton
{
	idc = IDC_DIVER_RADIO_ENTER;
	x = 0.324688 * safezoneW + safezoneX;
	y = 0.534002 * safezoneH + safezoneY;
	w = 0.031875 * safezoneW;
	h = 0.042502 * safezoneH;
	tooltip = $STR_set_frequency;
	action = "_f = parseNumber(ctrlText IDC_DIVER_RADIO_EDIT_ID);  if ((_f > MIN_DD_FREQ) and (_f < MAX_DD_FREQ)) then {dd_frequency = str (round (_f * FREQ_ROUND_POWER) / FREQ_ROUND_POWER); hintSilent '';} else {hint formatText [localize 'STR_incorrect_frequency', MIN_DD_FREQ, MAX_DD_FREQ]}; call updateDDDialog;";
};
class diver_clear: HiddenButton
{
	idc = IDC_DIVER_RADIO_CLEAR;
	x = 0.254562 * safezoneW + safezoneX;
	y = 0.537402 * safezoneH + safezoneY;
	w = 0.0334687 * safezoneW;
	h = 0.044202 * safezoneH;
	action = "ctrlSetText [IDC_DIVER_RADIO_EDIT_ID, '']; ctrlSetFocus ((findDisplay IDC_DIDER_RADIO_DIALOG_ID) displayCtrl IDC_DIVER_RADIO_EDIT_ID);";
	tooltip = $STR_clear_frequency;
};
class diver_edit: RscEditLCD
{
	idc = IDC_DIVER_RADIO_EDIT;
	text = "32.7"; //--- ToDo: Localize;
	x = 0.274484 * safezoneW + safezoneX;
	y = 0.394595 * safezoneH + safezoneY;
	w = 0.0613594 * safezoneW;
	h = 0.0833038 * safezoneH;
	moving = 1;
	canModify = 1;
	tooltip = $STR_current_freq;
};
class increase_volume: HiddenButton
{
	idc = IDC_DIVER_RADIO_VOLUME;
	x = 0.412344 * safezoneW + safezoneX;
	y = 0.423497 * safezoneH + safezoneY;
	w = 0.0119531 * safezoneW;
	h = 0.0561026 * safezoneH;
	action = "dd_volume_level = (dd_volume_level + 1) mod MAX_DD_VOLUME; hint formatText [localize 'STR_radio_volume', ((dd_volume_level + 1) * 10)];"
	tooltip = $STR_volume;
};
class diver_depth_edit: RscEditLCD
{
	idc = IDC_DIVER_RADIO_DEPTH;
	text = "24m"; //--- ToDo: Localize;
	x = 0.253766 * safezoneW + safezoneX;
	y = 0.488099 * safezoneH + safezoneY;
	w = 0.0574531 * safezoneW;
	h = 0.0391018 * safezoneH;
	moving = 1;
	canModify = 0;
	tooltip = $STR_depth;
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////
};





