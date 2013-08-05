#include "\task_force_radio\define.h"

// [] call BIS_fnc_GUIeditor;


/* #Zafamy
$[
	1.062,
	["anprc152_radio_dialog",[["0","0","1","1"],"0.001","0.001","GUI_GRID"],0,1,0],
	[1200,"",[1,"\task_force_radio\anprc152\152.paa",["0.0543875 * safezoneW + safezoneX","0.0265282 * safezoneH + safezoneY","0.143438 * safezoneW","0.901041 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1400,"",[1,"",["0.075425 * safezoneW + safezoneX","0.384395 * safezoneH + safezoneY","0.105506 * safezoneW","0.0471772 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1600,"",[1,"",["0.156387 * safezoneW + safezoneX","0.462598 * safezoneH + safezoneY","0.0159375 * safezoneW","0.0182758 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1601,"",[1,"",["0.156706 * safezoneW + safezoneX","0.49235 * safezoneH + safezoneY","0.0172125 * safezoneW","0.020826 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/



///////////////////////////////////////////////////////////////////////////
/// Base Classes
///////////////////////////////////////////////////////////////////////////
class CfgFontFamilies {
	class VTN_LCD  {
		fonts[] = {"\task_force_radio\fonts\vtn_lcd26","\task_force_radio\fonts\vtn_lcd46"};
		spaceWidth = 0.900000;
		spacing = 0.250000;
	};
};
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
	font = "VTN_LCD";
	shadow = 2;
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1)";
	canModify = 1;
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
	clear
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
	text = sw_frequency;
	x = 0.075425 * safezoneW + safezoneX;
	y = 0.384395 * safezoneH + safezoneY;
	w = 0.105506 * safezoneW;
	h = 0.0471772 * safezoneH;
};
class enter: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_ENTER;
	x = 0.156706 * safezoneW + safezoneX;
	y = 0.49235 * safezoneH + safezoneY;
	w = 0.0172125 * safezoneW;
	h = 0.020826 * safezoneH;
	action = "_f = parseNumber(ctrlText IDC_ANPRC152_RADIO_DIALOG_EDIT_ID);  if ((_f > MIN_SW_FREQ) and (_f < MAX_SW_FREQ)) then {sw_frequency = str (round (_f * FREQ_ROUND_POWER) / FREQ_ROUND_POWER); hintSilent '';} else {hint 'Incorrect frequency value'}; ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT_ID, sw_frequency];";
};
class clear: HiddenButton
{
	idc = IDC_ANPRC152_RADIO_DIALOG_CLEAR;
	x = 0.156387 * safezoneW + safezoneX;
	y = 0.462598 * safezoneH + safezoneY;
	w = 0.0159375 * safezoneW;
	h = 0.0182758 * safezoneH;
	action = "ctrlSetText [IDC_ANPRC152_RADIO_DIALOG_EDIT_ID, '']; ctrlSetFocus ((findDisplay IDC_ANPRC152_RADIO_DIALOG_ID) displayCtrl IDC_ANPRC152_RADIO_DIALOG_EDIT_ID);";
};
////////////////////////////////////////////////////////
// GUI EDITOR OUTPUT END
////////////////////////////////////////////////////////	

};






