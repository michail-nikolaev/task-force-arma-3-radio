class CfgPatches
{
	class task_force_radio_items
	{
		units[] = {"tfar_ModuleTaskForceRadio", "tfar_ModuleTaskForceRadioFrequencies"};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F", "A3_Structures_F_Items_Electronics"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.8.3;
		versionStr = "0.8.3";
		versionAr[] = {0,8,3};
	};
};

class CfgFontFamilies
{
	class tf_font_dots
	{
		fonts[] = {
			"\task_force_radio_items\fonts\dots\dots6",            
			"\task_force_radio_items\fonts\dots\dots7",            
			"\task_force_radio_items\fonts\dots\dots8",            
			"\task_force_radio_items\fonts\dots\dots9",            
			"\task_force_radio_items\fonts\dots\dots10",           
			"\task_force_radio_items\fonts\dots\dots11",           
			"\task_force_radio_items\fonts\dots\dots12",           
			"\task_force_radio_items\fonts\dots\dots13",
			"\task_force_radio_items\fonts\dots\dots14",           
			"\task_force_radio_items\fonts\dots\dots15",           
			"\task_force_radio_items\fonts\dots\dots16",           
			"\task_force_radio_items\fonts\dots\dots17",           
			"\task_force_radio_items\fonts\dots\dots18",           
			"\task_force_radio_items\fonts\dots\dots19",           
			"\task_force_radio_items\fonts\dots\dots20",           
			"\task_force_radio_items\fonts\dots\dots21",           
			"\task_force_radio_items\fonts\dots\dots22",           
			"\task_force_radio_items\fonts\dots\dots23",           
			"\task_force_radio_items\fonts\dots\dots24",           
			"\task_force_radio_items\fonts\dots\dots25",           
			"\task_force_radio_items\fonts\dots\dots26",           
			"\task_force_radio_items\fonts\dots\dots27",           
			"\task_force_radio_items\fonts\dots\dots28",           
			"\task_force_radio_items\fonts\dots\dots29",           
			"\task_force_radio_items\fonts\dots\dots30",           
			"\task_force_radio_items\fonts\dots\dots31",           
			"\task_force_radio_items\fonts\dots\dots32",           
			"\task_force_radio_items\fonts\dots\dots33",           
			"\task_force_radio_items\fonts\dots\dots34",           
			"\task_force_radio_items\fonts\dots\dots35",           
			"\task_force_radio_items\fonts\dots\dots36"
		};

		spaceWidth = 0.6;
		spacing = 0.15;
	};
	class tf_font_segments
	{
		fonts[] = {			
			"\task_force_radio_items\fonts\segments\segments6",   
			"\task_force_radio_items\fonts\segments\segments7",   
			"\task_force_radio_items\fonts\segments\segments8",   
			"\task_force_radio_items\fonts\segments\segments9",   
			"\task_force_radio_items\fonts\segments\segments10",  
			"\task_force_radio_items\fonts\segments\segments11",  
			"\task_force_radio_items\fonts\segments\segments12",  
			"\task_force_radio_items\fonts\segments\segments13",  
			"\task_force_radio_items\fonts\segments\segments14",  
			"\task_force_radio_items\fonts\segments\segments15",  
			"\task_force_radio_items\fonts\segments\segments16",  
			"\task_force_radio_items\fonts\segments\segments17",  
			"\task_force_radio_items\fonts\segments\segments18",  
			"\task_force_radio_items\fonts\segments\segments19",  
			"\task_force_radio_items\fonts\segments\segments20",  
			"\task_force_radio_items\fonts\segments\segments21",  
			"\task_force_radio_items\fonts\segments\segments22",  
			"\task_force_radio_items\fonts\segments\segments23",  
			"\task_force_radio_items\fonts\segments\segments24",  
			"\task_force_radio_items\fonts\segments\segments25",  
			"\task_force_radio_items\fonts\segments\segments26",  
			"\task_force_radio_items\fonts\segments\segments27",  
			"\task_force_radio_items\fonts\segments\segments28",  
			"\task_force_radio_items\fonts\segments\segments29",  
			"\task_force_radio_items\fonts\segments\segments30",  
			"\task_force_radio_items\fonts\segments\segments31",  
			"\task_force_radio_items\fonts\segments\segments32",  
			"\task_force_radio_items\fonts\segments\segments33",  
			"\task_force_radio_items\fonts\segments\segments34",  
			"\task_force_radio_items\fonts\segments\segments35",  
			"\task_force_radio_items\fonts\segments\segments36"
		};
		
		spaceWidth = 0.8;
		spacing = 0.3;
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
		maximumLoad = 100;
		mass = 15;		
		tf_hasLRradio = 1;
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialog = "rt1523g_radio_dialog";
		tf_subtype = "digital_lr";
	};	
	class tf_anprc155: B_Kitbag_sgg
	{
		displayName = "AN/PRC 155";
		descriptionShort = "AN/PRC 155";
		picture = "\task_force_radio_items\anprc155\155_icon.paa";
		scope = 2;
		maximumLoad = 100;
		mass = 15;
		tf_hasLRradio = 1;
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialog = "anprc155_radio_dialog";
		tf_subtype = "digital_lr";
	};	
	class tf_mr3000: B_Kitbag_cbr
	{
		displayName = "MR3000";
		descriptionShort = "MR3000";
		picture = "\task_force_radio_items\mr3000\mr3000_icon.paa";
		scope = 2;
		maximumLoad = 100;
		mass = 15;
		tf_hasLRradio = 1;
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialog = "mr3000_radio_dialog";
		tf_subtype = "digital_lr";
	};
	#include "vehicles.hpp"
	
	class Logic;
	class Module_F: Logic
	{
		class ArgumentsBaseUnits
		{
			class Units;
		};
		class ModuleDescription
		{
			class AnyBrain;
		};
	};
	class tfar_ModuleTaskForceRadio: Module_F
	{
		scope = 2;
		author = "Task Force Arrowhead Radio";
		displayName = "TFAR - Radios";
		category = "Intel";
		
		function = "TFAR_fnc_initialiseBaseModule";
		functionPriority = 1;
		
		isGlobal = 1;
		//isDisposable = 1;
		
		class Arguments: ArgumentsBaseUnits
		{
			class Units: Units {};
			class WestEncryption
			{
				displayName = "West Encryption";
				description = "West's Encryption";
				typeName = "TEXT";
				defaultValue = "_blufor";
			};
			class WestLRradio
			{
				displayName = "West LR";
				description = "West's LR radio";
				typeName = "TEXT";
				defaultValue = "tf_rt1523g";
			};
			class WestRadio
			{
				displayName = "West PR";
				description = "West's personal radio";
				typeName = "TEXT";
				defaultValue = "tf_anprc152";
			};
			class EastEncryption
			{
				displayName = "East Encryption";
				description = "East's Encryption";
				typeName = "TEXT";
				defaultValue = "_opfor";
			};
			class EastLRradio
			{
				displayName = "East LR";
				description = "East's LR radio";
				typeName = "TEXT";
				defaultValue = "tf_mr3000";
			};
			class EastRadio
			{
				displayName = "East PR";
				description = "East's personal radio";
				typeName = "TEXT";
				defaultValue = "tf_fadak";
			};
			class GuerEncryption
			{
				displayName = "Guer Encryption";
				description = "Resistance's Encryption";
				typeName = "TEXT";
				defaultValue = "_independent";
			};
			class GuerLRradio
			{
				displayName = "Guer LR";
				description = "Resistance's LR radio";
				typeName = "TEXT";
				defaultValue = "tf_anprc155";
			};
			class GuerRadio
			{
				displayName = "Guer PR";
				description = "Resistance's personal radio";
				typeName = "TEXT";
				defaultValue = "tf_anprc148jem";
			};
		};
		
		class ModuleDescription: ModuleDescription
		{
			description = "Allows setting of default radios and encryption for sides.";
			sync[] = {};
		};
	};
	
	class tfar_ModuleTaskForceRadioFrequencies: Module_F
	{
		scope = 2;
		author = "Task Force Arrowhead Radio";
		displayName = "TFAR - Frequencies";
		category = "Intel";
		
		function = "TFAR_fnc_initialiseFreqModule";
		functionPriority = 1;
		
		isGlobal = 1;
		//isDisposable = 1;
		isTriggerActivated = 1;
		
		class Arguments: ArgumentsBaseUnits
		{
			class Units: Units {};
			class WestFreq
			{
				displayName = "West SW Freq.";
				description = "West's SW default frequency";
				typeName = "NUMBER";
				defaultValue = 70.2;
			};
			class WestLrFreq
			{
				displayName = "West LR Freq.";
				description = "West's LR default frequency";
				typeName = "NUMBER";
				defaultValue = 57.2;
			};
			class EastFreq
			{
				displayName = "East SW Freq.";
				description = "East's SW default frequency";
				typeName = "NUMBER";
				defaultValue = 83.8;
			};
			class EastLrFreq
			{
				displayName = "East LR Freq.";
				description = "East's LR default frequency";
				typeName = "NUMBER";
				defaultValue = 48.5;
			};
			class GuerFreq
			{
				displayName = "Guer SW Freq.";
				description = "Resistance's SW default frequency";
				typeName = "NUMBER";
				defaultValue = 62.5;
			};
			class GuerLrFreq
			{
				displayName = "Guer LR Freq.";
				description = "Resistance's LR default frequency";
				typeName = "NUMBER";
				defaultValue = 59.4;
			};
		};
		
		class ModuleDescription: ModuleDescription
		{
			description = "Allows setting of default frequencies for sides.";
			sync[] = {"AnyPerson"};
		};
	};
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
		tf_subtype = "digital";
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
		tf_subtype = "digital";
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
		tf_subtype = "digital";
	};

	class tf_anprc154: ItemRadio
	{
		displayName = "AN/PRC-154";
		descriptionShort = "AN/PRC-154";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\anprc154\154_icon.paa";
		tf_prototype = 1;
		tf_range = 1500;
		tf_dialog = "anprc154_radio_dialog";
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialogUpdate = "";	
		tf_subtype = "digital";
	};

	class tf_rf7800str: ItemRadio
	{
		displayName = "RF-7800S-TR";
		descriptionShort = "RF-7800S-TR";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\rf7800str\rf7800str_icon.paa";
		tf_prototype = 1;
		tf_range = 1500;
		tf_dialog = "rf7800str_radio_dialog";
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialogUpdate = "";	
		tf_subtype = "digital";
	};
	
	TF_RADIO_IDS(tf_anprc152,AN/PRC-152)
	TF_RADIO_IDS(tf_anprc148jem,AN/PRC-148 JEM)
	TF_RADIO_IDS(tf_fadak,FADAK)
	TF_RADIO_IDS(tf_anprc154,AN/PRC-154)
	TF_RADIO_IDS(tf_rf7800str,RF-7800S-TR)

};