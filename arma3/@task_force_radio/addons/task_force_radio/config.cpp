class CfgPatches
{
	class task_force_radio
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = { "CBA_Main", "A3_UI_F", "task_force_radio_items"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.8.3;
		versionStr = "0.8.3";
		versionAr[] = {0,8,3};
	};
};

class CfgMarkers
{
	class hd_objective
	{
		name = "$STR_CFG_MARKERS_dot";
		icon = "\A3\ui_f\data\map\markers\handdrawn\dot_CA.paa";
		color[] = {0,0,0,1};
		size = 32;
		shadow = 1;
		scope = 2;
		markerClass = "draw";
	};
	class hd_dot
	{
		name = "$STR_CFG_MARKERS_FLAG";
		icon = "\A3\ui_f\data\map\markers\handdrawn\objective_CA.paa";
		color[] = {0,0,0,1};
		size = 32;
		shadow = 1;
		scope = 2;
		markerClass = "draw";
	};
};

class CfgFontFamilies
{
	class tf_font_dots
	{
		fonts[] = {
			"\task_force_radio\fonts\dots\dots6",            
			"\task_force_radio\fonts\dots\dots7",            
			"\task_force_radio\fonts\dots\dots8",            
			"\task_force_radio\fonts\dots\dots9",            
			"\task_force_radio\fonts\dots\dots10",           
			"\task_force_radio\fonts\dots\dots11",           
			"\task_force_radio\fonts\dots\dots12",           
			"\task_force_radio\fonts\dots\dots13",
			"\task_force_radio\fonts\dots\dots14",           
			"\task_force_radio\fonts\dots\dots15",           
			"\task_force_radio\fonts\dots\dots16",           
			"\task_force_radio\fonts\dots\dots17",           
			"\task_force_radio\fonts\dots\dots18",           
			"\task_force_radio\fonts\dots\dots19",           
			"\task_force_radio\fonts\dots\dots20",           
			"\task_force_radio\fonts\dots\dots21",           
			"\task_force_radio\fonts\dots\dots22",           
			"\task_force_radio\fonts\dots\dots23",           
			"\task_force_radio\fonts\dots\dots24",           
			"\task_force_radio\fonts\dots\dots25",           
			"\task_force_radio\fonts\dots\dots26",           
			"\task_force_radio\fonts\dots\dots27",           
			"\task_force_radio\fonts\dots\dots28",           
			"\task_force_radio\fonts\dots\dots29",           
			"\task_force_radio\fonts\dots\dots30",           
			"\task_force_radio\fonts\dots\dots31",           
			"\task_force_radio\fonts\dots\dots32",           
			"\task_force_radio\fonts\dots\dots33",           
			"\task_force_radio\fonts\dots\dots34",           
			"\task_force_radio\fonts\dots\dots35",           
			"\task_force_radio\fonts\dots\dots36"
		};

		spaceWidth = 0.7;
		spacing = 0.2;
	};
	class tf_font_segments
	{
		fonts[] = {			
			"\task_force_radio\fonts\segments\segments6",   
			"\task_force_radio\fonts\segments\segments7",   
			"\task_force_radio\fonts\segments\segments8",   
			"\task_force_radio\fonts\segments\segments9",   
			"\task_force_radio\fonts\segments\segments10",  
			"\task_force_radio\fonts\segments\segments11",  
			"\task_force_radio\fonts\segments\segments12",  
			"\task_force_radio\fonts\segments\segments13",  
			"\task_force_radio\fonts\segments\segments14",  
			"\task_force_radio\fonts\segments\segments15",  
			"\task_force_radio\fonts\segments\segments16",  
			"\task_force_radio\fonts\segments\segments17",  
			"\task_force_radio\fonts\segments\segments18",  
			"\task_force_radio\fonts\segments\segments19",  
			"\task_force_radio\fonts\segments\segments20",  
			"\task_force_radio\fonts\segments\segments21",  
			"\task_force_radio\fonts\segments\segments22",  
			"\task_force_radio\fonts\segments\segments23",  
			"\task_force_radio\fonts\segments\segments24",  
			"\task_force_radio\fonts\segments\segments25",  
			"\task_force_radio\fonts\segments\segments26",  
			"\task_force_radio\fonts\segments\segments27",  
			"\task_force_radio\fonts\segments\segments28",  
			"\task_force_radio\fonts\segments\segments29",  
			"\task_force_radio\fonts\segments\segments30",  
			"\task_force_radio\fonts\segments\segments31",  
			"\task_force_radio\fonts\segments\segments32",  
			"\task_force_radio\fonts\segments\segments33",  
			"\task_force_radio\fonts\segments\segments34",  
			"\task_force_radio\fonts\segments\segments35",  
			"\task_force_radio\fonts\segments\segments36"
		};
		
		spaceWidth = 0.8;
		spacing = 0.3;
	};
};

#include "\task_force_radio\CfgFunctions.h"
#include "\userconfig\task_force_radio\radio_keys.hpp"
#include "\task_force_radio\description.h"
#include "\task_force_radio\RscTitles.hpp"