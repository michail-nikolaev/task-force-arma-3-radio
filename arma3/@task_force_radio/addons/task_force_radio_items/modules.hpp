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
	displayName = "$STR_TFAR_Mod_EnforceUsage";
	category = "TFAR";
	
	function = "TFAR_fnc_initialiseEnforceUsageModule";
	functionPriority = 1;
	isGlobal = 1;
	isTriggerActivated = 0;
	
	class Arguments
	{
		class TeamLeaderRadio
		{
			displayName = "$STR_TFAR_Mod_GiveTLradio";
			description = "$STR_TFAR_Mod_GiveTLradioTT";
			typeName = "BOOL";
		};
		class RiflemanRadio
		{
			displayName = "$STR_TFAR_Mod_GiveRiflemanRadio";
			description = "$STR_TFAR_Mod_GiveRiflemanRadioTT";
			typeName = "BOOL";
		};
	};
	
	class ModuleDescription: ModuleDescription
	{
		description = "$STR_TFAR_Mod_EnforceUsage_Description";
	};
};
class tfar_ModuleTaskForceRadio: Module_F
{
	scope = 2;
	author = "Task Force Arrowhead Radio";
	displayName = "$STR_TFAR_Mod_SideRadio";
	category = "TFAR";
	
	function = "TFAR_fnc_initialiseBaseModule";
	functionPriority = 2;
	
	isGlobal = 1;
	
	class Arguments: ArgumentsBaseUnits
	{
		class Units: Units {};
		class Encryption
		{
			displayName = "$STR_TFAR_Mod_EncryptionCode";
			description = "$STR_TFAR_Mod_EncryptionCode";
			typeName = "TEXT";
			defaultValue = "DSH&G^G";
		};
		class LRradio
		{
			displayName = "$STR_TFAR_Mod_LR_Radio";
			description = "$STR_TFAR_Mod_LR_RadioTT";
			typeName = "TEXT";
			defaultValue = "tf_rt1523g";
		};
		class Radio
		{
			displayName = "$STR_TFAR_Mod_PR_Radio";
			description = "$STR_TFAR_Mod_PR_RadioTT";
			typeName = "TEXT";
			defaultValue = "tf_anprc152";
		};
		class RiflemanRadio
		{
			displayName = "$STR_TFAR_Mod_Rifle_Radio";
			description = "$STR_TFAR_Mod_Rifle_RadioTT";
			typeName = "TEXT";
			defaultValue = "tf_rf7800str";
		};
		class PrFreq
		{
			displayName = "$STR_TFAR_Mod_PRFrequency";
			description = "$STR_TFAR_Mod_PRFrequencyTT";
			typeName = "NUMBER";
			defaultValue = 70.2;
		};
		class LrFreq
		{
			displayName = "$STR_TFAR_Mod_LRFrequency";
			description = "$STR_TFAR_Mod_LRFrequencyTT";
			typeName = "NUMBER";
			defaultValue = 57.2;
		};
	};
	
	class ModuleDescription: ModuleDescription
	{
		description = "$STR_TFAR_Mod_SideRadio_Description";
		sync[] = {"AnyPerson"};
	};
};

class tfar_ModuleTaskForceRadioFrequencies: Module_F
{
	scope = 2;
	author = "Task Force Arrowhead Radio";
	displayName = "$STR_TFAR_Mod_Frequencies";
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
			displayName = "$STR_TFAR_Mod_PRFrequency";
			description = "$STR_TFAR_Mod_PRFrequencyTT";
			typeName = "NUMBER";
			defaultValue = 70.2;
		};
		class LrFreq
		{
			displayName = "$STR_TFAR_Mod_LRFrequency";
			description = "$STR_TFAR_Mod_LRFrequencyTT";
			typeName = "NUMBER";
			defaultValue = 57.2;
		};
	};
	
	class ModuleDescription: ModuleDescription
	{
		description = "$STR_TFAR_Mod_Frequencies_Description";
		sync[] = {"AnyPerson"};
	};
};