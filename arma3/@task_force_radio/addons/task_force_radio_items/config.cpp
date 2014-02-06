class CfgPatches
{
	class task_force_radio_items
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Structures_F_Items_Electronics"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.8.3;
		versionStr = "0.8.3";
		versionAr[] = {0,8,3};
	};
};

class CfgVehicles {
	class Bag_Base
	{
		tf_hasLRradio = 0;
		tf_encryptionCode = "";
		tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
		tf_range = 20000;
	};
	class B_Kitbag_mcamo;
	class B_Kitbag_cbr;
	class B_Kitbag_sgg;
	class tf_rt1523g: B_Kitbag_mcamo
	{
		displayName = "RT-1523G (ASIP)";
		descriptionShort = "RT-1523G (ASIP)";
		picture = "\task_force_radio_items\rt1523g\rt1523g_icon.paa";
		scope = 2;
		maximumLoad = 60;
		mass = 15;		
		tf_hasLRradio = 1;
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialog = "rt1523g_radio_dialog";
	};	
	class tf_anprc155: B_Kitbag_sgg
	{
		displayName = "AN/PRC 155";
		descriptionShort = "AN/PRC 155";
		picture = "\task_force_radio_items\anprc155\155_icon.paa";
		scope = 2;
		maximumLoad = 60;
		mass = 15;
		tf_hasLRradio = 1;
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialog = "anprc155_radio_dialog";
	};	
	class tf_mr3000: B_Kitbag_cbr
	{
		displayName = "MR3000";
		descriptionShort = "MR3000";
		picture = "\task_force_radio_items\mr3000\mr3000_icon.paa";
		scope = 2;
		maximumLoad = 60;
		mass = 15;
		tf_hasLRradio = 1;
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialog = "mr3000_radio_dialog";
	};
	#include "vehicles.hpp"
};
	
#include "radio_ids.hpp"
	
class CfgWeapons
{
	class ItemRadio;
	
	class tf_anprc152: ItemRadio
	{
		displayName = "AN/PRC-152";
		descriptionShort = "AN/PRC-152";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\anprc152\152_icon.paa";
		tf_prototype = 1;		
		tf_range = 3000;
		tf_dialog = "anprc152_radio_dialog";
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";		
	};
	
	class tf_anprc148jem: ItemRadio
	{
		displayName = "AN/PRC-148 JEM";
		descriptionShort = "AN/PRC-148 JEM";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\anprc148jem\148_icon.paa";
		tf_prototype = 1;		
		tf_range = 3000;
		tf_dialog = "anprc148jem_radio_dialog";
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";		
	};
	
	class tf_fadak: ItemRadio
	{
		displayName = "FADAK";
		descriptionShort = "FADAK";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\fadak\fadak_icon.paa";
		tf_prototype = 1;		
		tf_range = 3000;
		tf_dialog = "fadak_radio_dialog";
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";		
	};
	
	TF_RADIO_IDS(tf_anprc152,AN/PRC-152)
	TF_RADIO_IDS(tf_anprc148jem,AN/PRC-148 JEM)
	TF_RADIO_IDS(tf_fadak,FADAK)

};