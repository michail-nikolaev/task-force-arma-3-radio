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
			defaultValue = 1;
		};
		class RiflemanRadio
		{
			displayName = "$STR_TFAR_Mod_GiveRiflemanRadio";
			description = "$STR_TFAR_Mod_GiveRiflemanRadioTT";
			typeName = "BOOL";
			defaultValue = 1;
		};
		
		class terrain_interception_coefficient
		{
			displayName = "$STR_TFAR_Mod_TerrainInterceptionCoefficient";
			description = "$STR_TFAR_Mod_TerrainInterceptionCoefficientTT";
			typeName = "NUMBER";
			defaultValue = 7.0;
		};
		class radio_channel_name
		{
			displayName = "$STR_TFAR_Mod_ChannelName";
			description = "$STR_TFAR_Mod_ChannelNameTT";
			typeName = "TEXT";
			defaultValue = "TaskForceRadio";
		};
		class radio_channel_password
		{
			displayName = "$STR_TFAR_Mod_ChannelPassword";
			description = "$STR_TFAR_Mod_ChannelPasswordTT";
			typeName = "TEXT";
			defaultValue = "123";
		};
		
		class same_sw_frequencies_for_side
		{
			displayName = "$STR_TFAR_Mod_SameSWFrequencies";
			description = "$STR_TFAR_Mod_SameSWFrequenciesTT";
			typeName = "BOOL";
			defaultValue = 0;
		};
		class same_lr_frequencies_for_side
		{
			displayName = "$STR_TFAR_Mod_SameLrFrequencies";
			description = "$STR_TFAR_Mod_SameLrFrequenciesTT";
			typeName = "BOOL";
			defaultValue = 1;
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
			typeName = "TEXT";
			defaultValue = "[""70.2"",""127.1""]";
		};
		class LrFreq
		{
			displayName = "$STR_TFAR_Mod_LRFrequency";
			description = "$STR_TFAR_Mod_LRFrequencyTT";
			typeName = "TEXT";
			defaultValue = "[""54.2"",""73.1""]";
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
	functionPriority = 0; // only for server
	
	isGlobal = 1;
	isTriggerActivated = 1;
	
	class Arguments: ArgumentsBaseUnits
	{
		class Units: Units {};
		class PrFreq
		{
			displayName = "$STR_TFAR_Mod_PRFrequency";
			description = "$STR_TFAR_Mod_PRFrequencyTT";
			typeName = "TEXT";
			defaultValue = "[""70.2"",""127.1""]";
		};
		class LrFreq
		{
			displayName = "$STR_TFAR_Mod_LRFrequency";
			description = "$STR_TFAR_Mod_LRFrequencyTT";
			typeName = "TEXT";
			defaultValue = "[""54.2"",""73.1""]";
		};
	};
	
	class ModuleDescription: ModuleDescription
	{
		description = "$STR_TFAR_Mod_Frequencies_Description";
		sync[] = {"AnyPerson"};
	};
};