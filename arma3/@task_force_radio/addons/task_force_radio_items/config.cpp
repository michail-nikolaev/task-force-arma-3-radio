class CfgPatches
{
	class task_force_radio_items
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.8.0;
		versionStr = "0.8.0";
		versionAr[] = {0,8,0};
	};
};

class CfgVehicles {
	class Bag_Base;
	class tf_rt1523g: Bag_Base
	{
		displayName = "RT-1523G (ASIP)";
		descriptionShort = "RT-1523G (ASIP)";
		picture = "\task_force_radio_items\rt1523g\rt1523g_icon.paa";
		model = "\A3\weapons_f\Ammoboxes\bags\Backpack_Small";
		scope = 2;
		maximumLoad = 30;
		mass = 15;
	};	
};

class CfgWeapons
{
	class ItemRadio;
	class anprc152_1 :  ItemRadio
	{
		displayName = "AN/PRC-152 (1)";
		radio_id = "anprc152_1";
		descriptionShort = "AN/PRC-152 (1)";
		picture = "\task_force_radio_items\anprc152\152_icon.paa";
	};
};