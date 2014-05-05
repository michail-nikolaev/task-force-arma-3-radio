class CfgPatches
{
	class task_force_radio
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = { "CBA_Main", "task_force_radio_items"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.9.1;
		versionStr = "0.9.1";
		versionAr[] = {0,9,1};
	};
};

#include "\task_force_radio\CfgFunctions.h"
#include "\userconfig\task_force_radio\radio_keys.hpp"
#include "\task_force_radio\description.h"
#include "\task_force_radio\RscTitles.hpp"