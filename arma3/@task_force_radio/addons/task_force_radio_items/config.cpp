class CfgPatches
{
	class task_force_radio_items
	{
		units[] = {"tfar_ModuleTaskForceRadioEnforceUsage", "tfar_ModuleTaskForceRadio", "tfar_ModuleTaskForceRadioFrequencies"};
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

class CfgFactionClasses
{
	class TFAR
	{
		displayName = "TFAR";
		priority = 10;
		side = 7;
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
	class tfar_ModuleTaskForceRadioEnforceUsage: Module_F
	{
		scope = 2;
		author = "Task Force Arrowhead Radio";
		displayName = "TFAR - Enforce Usage";
		category = "TFAR";
		
		function = "TFAR_fnc_initialiseEnforceUsageModule";
		functionPriority = 1;
		isGlobal = 1;
		isTriggerActivated = 0;
		
		class Arguments
		{
			class TeamLeaderRadio
			{
				displayName = "Give team leaders a long range radio";
				description = "Give each team leader the appropriate long range radio";
				typeName = "BOOL";
			};
		};
		
		class ModuleDescription: ModuleDescription
		{
			description = "Enforces usage of TFAR in mission.";
		};
	};
	class tfar_ModuleTaskForceRadio: Module_F
	{
		scope = 2;
		author = "Task Force Arrowhead Radio";
		displayName = "TFAR - Side Radio";
		category = "TFAR";
		
		function = "TFAR_fnc_initialiseBaseModule";
		functionPriority = 2;
		
		isGlobal = 1;
		
		class Arguments: ArgumentsBaseUnits
		{
			class Units: Units {};
			class Encryption
			{
				displayName = "Encryption Code";
				description = "Encryption Code";
				typeName = "TEXT";
				defaultValue = "DSH&G^G";
			};
			class LRradio
			{
				displayName = "LR Radio";
				description = "LR radio";
				typeName = "TEXT";
				defaultValue = "tf_rt1523g";
			};
			class Radio
			{
				displayName = "PR Radio";
				description = "Personal radio";
				typeName = "TEXT";
				defaultValue = "tf_anprc152";
			};
			class PrFreq
			{
				displayName = "PR Freq.";
				description = "PR default frequency";
				typeName = "NUMBER";
				defaultValue = 70.2;
			};
			class LrFreq
			{
				displayName = "LR Freq.";
				description = "LR default frequency";
				typeName = "NUMBER";
				defaultValue = 57.2;
			};
		};
		
		class ModuleDescription: ModuleDescription
		{
			description = "Allows setting of default radios, encryption and frequencies for synced side.";
			sync[] = {"AnyPerson"};
		};
	};
	
	class tfar_ModuleTaskForceRadioFrequencies: Module_F
	{
		scope = 2;
		author = "Task Force Arrowhead Radio";
		displayName = "TFAR - Frequencies";
		category = "TFAR";
		
		function = "TFAR_fnc_initialiseFreqModule";
		functionPriority = 3;
		
		isGlobal = 1;
		isTriggerActivated = 1;
		
		class Arguments: ArgumentsBaseUnits
		{
			class Units: Units {};
			class PrFreq
			{
				displayName = "PR Freq.";
				description = "PR default frequency";
				typeName = "NUMBER";
				defaultValue = 70.2;
			};
			class LrFreq
			{
				displayName = "LR Freq.";
				description = "LR default frequency";
				typeName = "NUMBER";
				defaultValue = 57.2;
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