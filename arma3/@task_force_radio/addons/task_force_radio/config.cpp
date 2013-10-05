class CfgPatches
{
	class task_force_radio
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"Extended_EventHandlers", "A3_UI_F", "task_force_radio_items"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.8.0;
		versionStr = "0.8.0";
		versionAr[] = {0,8,0};
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

class Extended_PostInit_EventHandlers
{
	task_force_radio_Post_Init = "if !(isDedicated) then { call compile preProcessFileLineNumbers '\task_force_radio\init.sqf' }";
};

#include "\userconfig\task_force_radio\radio_keys.hpp"
#include "\task_force_radio\description.h"