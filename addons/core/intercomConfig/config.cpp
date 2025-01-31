#include "..\script_component.hpp"



class CfgPatches {
    class TFAR_IntercomDummy {//Shut up Mikero... If i wanna use a config without CfgPatches please let me do that!!!
        name = "TFAR - Intercom";
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {};
        author = ECSTRING(core,AUTHORS);
    };
};

#define Intercom_Condition(chan) [ARR_3(_target,_player,chan)] call FUNC(canSetIntercomChannel)
#define Intercom_Statement(chan) [ARR_3(_target,_player,chan)] call FUNC(setIntercomChannel)
//INFO! First 20 channels should be reserved for TFAR use.

#define IntercomMacro class ACE_SelfActions : ACE_SelfActions { \
    class TFAR_IntercomChannel { \
        displayName = CSTRING(Intercom_ACESelfAction_Name); \
        condition = "true"; \
        statement = ""; \
        icon = ""; \
        class TFAR_IntercomChannel_disabled { \
            displayName = "Disabled"; \
            condition = QUOTE(Intercom_Condition(-1)); \
            statement = QUOTE(Intercom_Statement(-1)); \
        }; \
        class TFAR_IntercomChannel_1 { \
            displayName = CSTRING(Intercom_ACESelfAction_Channel1); \
            condition = QUOTE(Intercom_Condition(0)); \
            statement = QUOTE(Intercom_Statement(0)); \
        }; \
        class TFAR_IntercomChannel_2 { \
            displayName = CSTRING(Intercom_ACESelfAction_Channel2); \
            condition = QUOTE(Intercom_Condition(1)); \
            statement = QUOTE(Intercom_Statement(1)); \
        }; \
        class TFAR_IntercomChannel_Misc_1 { \
            displayName = "Misc channel 1"; \
            condition = QUOTE(Intercom_Condition(2)); \
            statement = QUOTE(Intercom_Statement(2)); \
        }; \
        class TFAR_IntercomChannel_Misc_2 { \
            displayName = "Misc channel 2"; \
            condition = QUOTE(Intercom_Condition(3)); \
            statement = QUOTE(Intercom_Statement(3)); \
        }; \
        class TFAR_IntercomChannel_Misc_3 { \
            displayName = "Misc channel 3"; \
            condition = QUOTE(Intercom_Condition(4)); \
            statement = QUOTE(Intercom_Statement(4)); \
        }; \
    }; \
};

class CfgVehicles {
/*    class All;
    class AllVehicles : All {
        class ACE_SelfActions;
    };

    class Air : AllVehicles {
        TFAR_hasIntercom = 1;
        IntercomMacro
    };
*/
    class AllVehicles;
    class Air : AllVehicles {class ACE_SelfActions;};
    class Helicopter: Air {
        TFAR_hasIntercom = 1;
        IntercomMacro
    };

    class Plane: Air {
        TFAR_hasIntercom = 1;
        IntercomMacro
    };

    class LandVehicle;
    class Car: LandVehicle {
        class ACE_SelfActions;
    };
    class Car_F: Car {};
    /*class Tank : LandVehicle {
        TFAR_hasIntercom = 1;
        IntercomMacro
    };*/
    class Wheeled_Apc_F : Car_F {
        TFAR_hasIntercom = 1;
        IntercomMacro
    };
    /*class MRAP_01_base_F : Car_F {
        TFAR_hasIntercom = 0;
        IntercomMacro
    };
    class MRAP_02_base_F : Car_F {
        TFAR_hasIntercom = 0;
        IntercomMacro
    };
    class MRAP_03_base_F : Car_F {
        TFAR_hasIntercom = 0;
        IntercomMacro
    };*/
};
