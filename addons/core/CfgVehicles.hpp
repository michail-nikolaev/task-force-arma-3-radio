class CfgVehicles {

    class Module_F;
    class TFAR_ModuleTaskForceRadioEnforceUsage: Module_F {
        scope = 1;
        author = ECSTRING(core,AUTHORS);
        displayName = ECSTRING(CORE,DEPRECATED);
        category = ECSTRING(CORE,CATEGORY);
        function = "";
        functionPriority = 0;
        isGlobal = 0;
    };
    class TFAR_ModuleTaskForceRadio: TFAR_ModuleTaskForceRadioEnforceUsage {};
    class TFAR_ModuleTaskForceRadioFrequencies: TFAR_ModuleTaskForceRadioEnforceUsage {};

    class VirtualMan_F;
    class VirtualCurator_F : VirtualMan_F {
        class Attributes {
            class TFAR_freq_sr {
                displayName = ECSTRING(settings,DefaultRadioFrequencies_SR);
                tooltip = ECSTRING(settings,DefaultRadioFrequencies_SR_desc);
                property = "TFAR_freq_sr";
                control = "EditArray";
                expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_CHANNELS,TFAR_MAX_SW_FREQ,TFAR_MIN_SW_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                defaultValue = "[]";
                unique = 0;
                condition = "1";
            };
            class TFAR_freq_lr {
                displayName = ECSTRING(core,DefaultRadioFrequencies_LR);
                tooltip = ECSTRING(core,DefaultRadioFrequencies_LR_desc);
                property = "TFAR_freq_lr";
                control = "EditArray";
                expression = QUOTE(if !(_value isEqualTo []) then {_value=[ARR_5(str _value,TFAR_MAX_LR_CHANNELS,TFAR_MAX_ASIP_FREQ,TFAR_MIN_ASIP_FREQ,TFAR_FREQ_ROUND_POWER)] call DFUNC(parseFrequenciesInput);_this setVariable [ARR_3('%s',_value,true)];});
                defaultValue = "[]";
                unique = 0;
                condition = "1";
            };
        };
    };


    //Add radios to vehicles
    class All;
    MACRO_VEC_ISOLATION_LR(AllVehicles,All,0,0);
    MACRO_VEC_ISOLATION_LR(Air,AllVehicles,0.1,1);
    class Land;
    class LandVehicle: Land {
        tf_range = 30000;
        class ACE_SelfActions;
    };
    MACRO_VEC_ISOLATION(Car,LandVehicle,0.1);
    MACRO_VEC_ISOLATION_LR_Intercom(Tank,LandVehicle,1,1,1);
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
    class Offroad_01_military_base_F;
    MACRO_VEC_ISOLATION_LR(Offroad_01_armed_base_F,Offroad_01_military_base_F,0.25,1);

    class Boat_F;
    MACRO_VEC_ISOLATION_LR(SDV_01_base_F,Boat_F,0.1,1);
    MACRO_VEC_ISOLATION_LR(Boat_Armed_01_base_F,Boat_F,0.1,1);
    class Boat_Civil_01_base_F;
    MACRO_VEC_LR(C_Boat_Civil_01_police_F,Boat_Civil_01_base_F,1);
    MACRO_VEC_LR(C_Boat_Civil_01_rescue_F,Boat_Civil_01_base_F,1);



    #include "ACEActions.hpp"
};
