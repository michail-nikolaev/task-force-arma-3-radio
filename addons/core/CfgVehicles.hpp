class CfgVehicles {
    class Logic;
    class Module_F: Logic {
    	class ArgumentsBaseUnits {
    		class Units;
    	};
    	class ModuleDescription {
    		class AnyBrain;
    	};
    };

    class TFAR_ModuleTaskForceRadioEnforceUsage: Module_F {
    	scope = PUBLIC;
    	author = QUOTE(AUTHORS);
    	displayName = "$STR_TFAR_Mod_EnforceUsage";
    	category = "TFAR";

    	function = "TFAR_fnc_initialiseEnforceUsageModule";
    	functionPriority = 1;
    	isGlobal = 1;
    	isTriggerActivated = 0;

    	class Arguments {
    		class TeamLeaderRadio {
    			displayName = "$STR_TFAR_Mod_GiveTLradio";
    			description = "$STR_TFAR_Mod_GiveTLradioTT";
    			typeName = "BOOL";
    			defaultValue = 1;
    		};
    		class RiflemanRadio {
    			displayName = "$STR_TFAR_Mod_GiveRiflemanRadio";
    			description = "$STR_TFAR_Mod_GiveRiflemanRadioTT";
    			typeName = "BOOL";
    			defaultValue = 1;
    		};
    		class terrain_interception_coefficient {
    			displayName = "$STR_TFAR_Mod_TerrainInterceptionCoefficient";
    			description = "$STR_TFAR_Mod_TerrainInterceptionCoefficientTT";
    			typeName = "NUMBER";
    			defaultValue = 7.0;
    		};
    		class radio_channel_name {
    			displayName = "$STR_TFAR_Mod_ChannelName";
    			description = "$STR_TFAR_Mod_ChannelNameTT";
    			typeName = "TEXT";
    			defaultValue = "TaskForceRadio";
    		};
    		class radio_channel_password {
    			displayName = "$STR_TFAR_Mod_ChannelPassword";
    			description = "$STR_TFAR_Mod_ChannelPasswordTT";
    			typeName = "TEXT";
    			defaultValue = "123";
    		};
    		class same_sw_frequencies_for_side {
    			displayName = "$STR_TFAR_Mod_SameSWFrequencies";
    			description = "$STR_TFAR_Mod_SameSWFrequenciesTT";
    			typeName = "BOOL";
    			defaultValue = 0;
    		};
    		class same_lr_frequencies_for_side {
    			displayName = "$STR_TFAR_Mod_SameLrFrequencies";
    			description = "$STR_TFAR_Mod_SameLrFrequenciesTT";
    			typeName = "BOOL";
    			defaultValue = 1;
    		};
            class full_duplex {
    			displayName = "$STR_TFAR_Mod_FullDuplex";
    			description = "$STR_TFAR_Mod_FullDuplexDescription";
    			typeName = "BOOL";
    			defaultValue = 1;
    		};
    	};
    	class ModuleDescription: ModuleDescription {
    		description = "$STR_TFAR_Mod_EnforceUsage_Description";
    	};
    };
    class TFAR_ModuleTaskForceRadio: Module_F {
    	scope = PUBLIC;
    	author = QUOTE(AUTHORS);
    	displayName = "$STR_TFAR_Mod_SideRadio";
    	category = "TFAR";

    	function = "TFAR_fnc_initialiseBaseModule";
    	functionPriority = 2;

    	isGlobal = 1;

    	class Arguments: ArgumentsBaseUnits {
    		class Units: Units {};
    		class Encryption {
    			displayName = "$STR_TFAR_Mod_EncryptionCode";
    			description = "$STR_TFAR_Mod_EncryptionCode";
    			typeName = "TEXT";
    			defaultValue = "DSH&G^G";
    		};
    		class LRradio {
    			displayName = "$STR_TFAR_Mod_LR_Radio";
    			description = "$STR_TFAR_Mod_LR_RadioTT";
    			typeName = "TEXT";
    			defaultValue = "TFAR_rt1523g";
    		};
    		class Radio {
    			displayName = "$STR_TFAR_Mod_PR_Radio";
    			description = "$STR_TFAR_Mod_PR_RadioTT";
    			typeName = "TEXT";
    			defaultValue = "TFAR_anprc154";
    		};
    		class RiflemanRadio {
    			displayName = "$STR_TFAR_Mod_Rifle_Radio";
    			description = "$STR_TFAR_Mod_Rifle_RadioTT";
    			typeName = "TEXT";
    			defaultValue = "TFAR_rf7800str";
    		};
    		class PrFreq {
    			displayName = "$STR_TFAR_Mod_PRFrequency";
    			description = "$STR_TFAR_Mod_PRFrequencyTT";
    			typeName = "TEXT";
    			defaultValue = "[""70.2"",""127.1""]";
    		};
    		class LrFreq {
    			displayName = "$STR_TFAR_Mod_LRFrequency";
    			description = "$STR_TFAR_Mod_LRFrequencyTT";
    			typeName = "TEXT";
    			defaultValue = "[""54.2"",""73.1""]";
    		};
    	};

    	class ModuleDescription: ModuleDescription {
    		description = "$STR_TFAR_Mod_SideRadio_Description";
    		sync[] = {"AnyPerson"};
    	};
    };

    class TFAR_ModuleTaskForceRadioFrequencies: Module_F {
    	scope = PUBLIC;
    	author = QUOTE(AUTHORS);
    	displayName = "$STR_TFAR_Mod_Frequencies";
    	category = "TFAR";

    	function = "TFAR_fnc_initialiseFreqModule";
    	functionPriority = 0; // only for server

    	isGlobal = 1;
    	isTriggerActivated = 1;

    	class Arguments: ArgumentsBaseUnits {
    		class Units: Units {};
    		class PrFreq {
    			displayName = "$STR_TFAR_Mod_PRFrequency";
    			description = "$STR_TFAR_Mod_PRFrequencyTT";
    			typeName = "TEXT";
    			defaultValue = "[""70.2"",""127.1""]";
    		};
    		class LrFreq {
    			displayName = "$STR_TFAR_Mod_LRFrequency";
    			description = "$STR_TFAR_Mod_LRFrequencyTT";
    			typeName = "TEXT";
    			defaultValue = "[""54.2"",""73.1""]";
    		};
    	};

    	class ModuleDescription: ModuleDescription {
    		description = "$STR_TFAR_Mod_Frequencies_Description";
    		sync[] = {"AnyPerson"};
    	};
    };

    //Add radios to vehicles
    class All;
    MACRO_VEC_ISOLATION_LR(AllVehicles,All,0,0);
    MACRO_VEC_ISOLATION_LR(Air,AllVehicles,0.1,1);
    class Land;
    class LandVehicle: Land {
    	tf_range = 30000;
    };
    MACRO_VEC_ISOLATION(Car,LandVehicle,0.1);
    MACRO_VEC_ISOLATION_LR(Tank,LandVehicle,1,1);
    class Helicopter;
    MACRO_VEC_ISOLATION_LR(ParachuteBase,Helicopter,0,0);
    class Helicopter_Base_F;
    MACRO_VEC_ISOLATION(Heli_Attack_02_base_F,Helicopter_Base_F,0.7);
    MACRO_VEC_ISOLATION(Heli_Attack_01_base_F,Helicopter_Base_F,0.7);
    class Helicopter_Base_H;
    MACRO_VEC_ISOLATION(Heli_Light_02_base_F,Helicopter_Base_H,0.7);
    MACRO_VEC_ISOLATION(Heli_Transport_01_base_F,Helicopter_Base_H,0.3);
    MACRO_VEC_ISOLATION(Heli_Transport_02_base_F,Helicopter_Base_H,0.8);

    class Car_F;
    MACRO_VEC_ISOLATION_LR(Wheeled_Apc_F,Car_F,0.6,1);
    MACRO_VEC_ISOLATION_LR(MRAP_01_base_F,Car_F,0.7,1);
    MACRO_VEC_ISOLATION_LR(MRAP_02_base_F,Car_F,0.7,1);
    MACRO_VEC_ISOLATION_LR(MRAP_03_base_F,Car_F,0.7,1);
    class Truck_F;
    MACRO_VEC_ISOLATION_LR(Truck_01_base_F,Truck_F,0.4,1);
    MACRO_VEC_ISOLATION_LR(Truck_02_base_F,Truck_F,0.4,1);
    MACRO_VEC_ISOLATION_LR(Truck_03_base_F,Truck_F,0.4,1);
    class Offroad_01_base_f;
    MACRO_VEC_ISOLATION_LR(Offroad_01_armed_base_F,Offroad_01_base_f,0.25,1);

    class Boat_F;
    MACRO_VEC_ISOLATION_LR(SDV_01_base_F,Boat_F,0.1,1);
    MACRO_VEC_ISOLATION_LR(Boat_Armed_01_base_F,Boat_F,0.1,1);
    class Boat_Civil_01_base_F;
    MACRO_VEC_LR(C_Boat_Civil_01_police_F,Boat_Civil_01_base_F,1);
    MACRO_VEC_LR(C_Boat_Civil_01_rescue_F,Boat_Civil_01_base_F,1);
};
