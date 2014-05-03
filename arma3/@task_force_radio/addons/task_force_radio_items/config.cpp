class CfgPatches
{
	class task_force_radio_items
	{
		units[] = {"tfar_ModuleTaskForceRadioEnforceUsage", "tfar_ModuleTaskForceRadio", "tfar_ModuleTaskForceRadioFrequencies"};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = {"A3_Modules_F", "A3_UI_F", "A3_Structures_F_Items_Electronics"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.9.0;
		versionStr = "0.9.0";
		versionAr[] = {0,9,0};
	};
};

class RscStandardDisplay;
class RscControlsGroupNoScrollbars;
class RscHTML;
class RscDisplayMain: RscStandardDisplay {
	onLoad = "[""onLoad"",_this,""RscDisplayMain"",'GUI'] call compile preprocessfilelinenumbers ""A3\ui_f\scripts\initDisplay.sqf"";_uriOffline = ""a3\Ui_f\data\news.html""; _uri = ""http://radio.task-force.ru/feed/index.php?language="" + language; _ctrlHTML = (_this select 0) displayCtrl 12314; _ctrlHTML htmlLoad _uri; _htmlLoaded = ctrlHTMLLoaded _ctrlHTML; if (!_htmlLoaded) then { _ctrlHTML htmlLoad _uriOffline; uinamespace setvariable [""BIS_fnc_guiNewsfeed_disable"",true]; };";
	class controls {
		class News: RscControlsGroupNoScrollbars
		{
			class controls
			{
				class NewsText: RscHTML
				{
					idc = 12314;
				};
			};
		};
	};
};

class CfgFactionClasses
{
	class TFAR
	{
		displayName = "TFAR";
		priority = 10;
		side = 7;
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
		tf_range = 20000;
	};
	class TFAR_Bag_Base: Bag_Base 
	{
		tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
		maximumLoad = 100;
		mass = 15;		
		tf_hasLRradio = 1;
		model = "\task_force_radio_items\models\TFR_BACKPACK";		
	};

	class tf_rt1523g: TFAR_Bag_Base
	{
		displayName = "RT-1523G (ASIP)";
		descriptionShort = "RT-1523G (ASIP)";
		picture = "\task_force_radio_items\rt1523g\rt1523g_icon.paa";					
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_sage_co.paa"};				
		scope = 2;
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialog = "rt1523g_radio_dialog";
		tf_subtype = "digital_lr";
	};	
	class tf_anprc155: TFAR_Bag_Base
	{
		displayName = "AN/PRC 155";
		descriptionShort = "AN/PRC 155";
		picture = "\task_force_radio_items\anprc155\155_icon.paa";
		scope = 2;
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_green_co.paa"};
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialog = "anprc155_radio_dialog";
		tf_subtype = "digital_lr";
	};	
	class tf_mr3000: TFAR_Bag_Base
	{
		displayName = "MR3000";
		descriptionShort = "MR3000";
		picture = "\task_force_radio_items\mr3000\mr3000_icon.paa";
		scope = 2;
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_black_co.paa"};
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialog = "mr3000_radio_dialog";
		tf_subtype = "digital_lr";
	};

	class tf_anarc210: TFAR_Bag_Base
	{
		displayName = "AN/ARC-210";
		descriptionShort = "AN/ARC-210";
		picture = "\task_force_radio_items\anarc210\anarc210_icon.paa";		
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_mcam_co.paa"};
		scope = 2;
		maximumLoad = 20;
		mass = 15;		
		tf_range = 40000;
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialog = "anarc210_radio_dialog";
		tf_subtype = "airborne";
		tf_dialogUpdate = "[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;";
	};

	class tf_anarc164: TFAR_Bag_Base
	{
		displayName = "AN/ARC-164";
		descriptionShort = "AN/ARC-164";
		picture = "\task_force_radio_items\anarc164\anarc164_icon.paa";
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_dpcu_co.paa"};
		scope = 2;
		maximumLoad = 20;
		mass = 15;		
		tf_range = 40000;
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialog = "anarc164_radio_dialog";
		tf_subtype = "airborne";
		tf_dialogUpdate = "[""%1""] call TFAR_fnc_updateLRDialogToChannel;";
	};

	class tf_mr6000l: TFAR_Bag_Base
	{
		displayName = "MR6000L";
		descriptionShort = "MR6000L";
		picture = "\task_force_radio_items\mr6000l\mr6000l_icon.paa";
		scope = 2;
		maximumLoad = 20;
		mass = 15;		
		tf_range = 40000;
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialog = "mr6000l_radio_dialog";
		tf_subtype = "airborne";
		tf_dialogUpdate = "[""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;";
	};

	#include "vehicles.hpp"
	#include "crates.hpp"
	#include "modules.hpp"
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
		tf_range = 5000;
		tf_dialog = "anprc152_radio_dialog";
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
		tf_subtype = "digital";
		tf_parent = "tf_anprc152";
	};
	
	class tf_anprc148jem: ItemRadio
	{
		displayName = "AN/PRC-148 JEM";
		descriptionShort = "AN/PRC-148 JEM";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\anprc148jem\148_icon.paa";
		tf_prototype = 1;
		tf_range = 5000;
		tf_dialog = "anprc148jem_radio_dialog";
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
		tf_subtype = "digital";
		tf_parent = "tf_anprc148jem";
	};
	
	class tf_fadak: ItemRadio
	{
		displayName = "FADAK";
		descriptionShort = "FADAK";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\fadak\fadak_icon.paa";
		tf_prototype = 1;
		tf_range = 5000;
		tf_dialog = "fadak_radio_dialog";
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";	
		tf_subtype = "digital";
		tf_parent = "tf_fadak";
	};

	class tf_anprc154: ItemRadio
	{
		displayName = "AN/PRC-154";
		descriptionShort = "AN/PRC-154";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\anprc154\154_icon.paa";
		tf_prototype = 1;
		tf_range = 2000;
		tf_dialog = "anprc154_radio_dialog";
		tf_encryptionCode = "tf_guer_radio_code";
		tf_dialogUpdate = "";	
		tf_subtype = "digital";
		tf_parent = "tf_anprc154";
	};

	class tf_rf7800str: ItemRadio
	{
		displayName = "RF-7800S-TR";
		descriptionShort = "RF-7800S-TR";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\rf7800str\rf7800str_icon.paa";
		tf_prototype = 1;
		tf_range = 2000;
		tf_dialog = "rf7800str_radio_dialog";
		tf_encryptionCode = "tf_west_radio_code";
		tf_dialogUpdate = "";	
		tf_subtype = "digital";
		tf_parent = "tf_rf7800str";
	};

	class tf_pnr1000a: ItemRadio
	{
		displayName = "PNR-1000A";
		descriptionShort = "PNR-1000A";
		scope = 2;
		model = "\A3\Structures_F\Items\Electronics\PortableLongRangeRadio_F";
		picture = "\task_force_radio_items\pnr1000a\pnr1000a_icon.paa";
		tf_prototype = 1;
		tf_range = 2000;
		tf_dialog = "pnr1000a_radio_dialog";
		tf_encryptionCode = "tf_east_radio_code";
		tf_dialogUpdate = "";	
		tf_subtype = "digital";
		tf_parent = "tf_pnr1000a";
	};
	
	TF_RADIO_IDS(tf_anprc152,AN/PRC-152)
	TF_RADIO_IDS(tf_anprc148jem,AN/PRC-148 JEM)
	TF_RADIO_IDS(tf_fadak,FADAK)
	TF_RADIO_IDS(tf_anprc154,AN/PRC-154)
	TF_RADIO_IDS(tf_rf7800str,RF-7800S-TR)
	TF_RADIO_IDS(tf_pnr1000a,PNR-1000A)

};