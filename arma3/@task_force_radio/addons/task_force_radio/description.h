#include "define.h"

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
		0
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
	size = "0.2 * (0.7 / (getResolution select 5))";	
	style = "0x00 + 0x40 + 0x200";
	font = "tf_font_segments"; 
	shadow = 1;
	sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.2) * (0.7 / (getResolution select 5))";};
class HiddenButton
{
	access = 0;
	type = 1;
	text = "";
	colorText[] = {
			0, 0, 0, 1
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
		"\task_force_radio\sounds\softPush",
		0.5,
		1
	};
	soundClick[] = 
	{
		"\task_force_radio\sounds\softClick",
		0.5,
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
class HiddenRotator:HiddenButton{
	soundPush[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundEscape",
		0.5,
		1
	};
	soundClick[] = 
	{
		"\A3\ui_f\data\sound\RscButton\soundEscape",
		0.5,
		1
	};
};
class HiddenFlip:HiddenButton{
	soundPush[] = 
	{
		"task_force_radio\sounds\switchPush",
		0.5,
		1
	};
	soundClick[] = 
	{
		"task_force_radio\sounds\switchClick",
		0.5,
		1
	};
};


#include "\task_force_radio\anprc152\anprc152.ext"
#include "\task_force_radio\anprc148jem\anprc148jem.ext"
#include "\task_force_radio\rt1523g\rt1523g.ext"
#include "\task_force_radio\anprc155\anprc155.ext"
#include "\task_force_radio\fadak\fadak.ext"
#include "\task_force_radio\diver_radio\diver_radio.ext"
#include "\task_force_radio\mr3000\mr3000.ext"
#include "\task_force_radio\anprc154\anprc154.ext"
#include "\task_force_radio\rf7800str\rf7800str.ext"
#include "\task_force_radio\pnr1000a\pnr1000a.ext"
#include "\task_force_radio\anarc210\anarc210.ext"
#include "\task_force_radio\anarc164\anarc164.ext"
#include "\task_force_radio\mr6000l\mr6000l.ext"
#include "\task_force_radio\bussole\bussole.ext"