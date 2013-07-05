class CfgPatches
{
	class task_force_radio
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"Extended_EventHandlers"};
	};
};

class Extended_PostInit_EventHandlers
{
	task_force_radio_Post_Init = "task_force_radio_Post_Init_Init_Var = [] execVM ""\task_force_radio\init.sqf""";
};
