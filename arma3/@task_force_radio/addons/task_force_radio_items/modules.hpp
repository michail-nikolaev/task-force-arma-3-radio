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