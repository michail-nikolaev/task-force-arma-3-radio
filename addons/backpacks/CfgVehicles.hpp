class CfgVehicles {
    class ReammoBox;
    class Item_Base_F;

    class Bag_Base: ReammoBox {
        tf_hasLRradio = 0;
        tf_encryptionCode = "";
        tf_range = 20000;
    };
    class TFAR_Bag_Base: Bag_Base {
        tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
        tf_hasLRradio = 1;
        scope = HIDDEN;
        scopeCurator = HIDDEN;
        #include "\z\tfar\addons\static_radios\edenAttributes.hpp"
    };

    #include "anarc164\CfgVehicles.hpp"
    #include "anarc210\CfgVehicles.hpp"
    #include "anprc155\CfgVehicles.hpp"
    #include "bussole\CfgVehicles.hpp"
    #include "mr3000\CfgVehicles.hpp"
    #include "mr6000l\CfgVehicles.hpp"
    #include "rt1523g\CfgVehicles.hpp"
    #include "enoch\CfgVehicles.hpp"


    class Box_NATO_Support_F;
    class TFAR_NATO_Radio_Crate: Box_NATO_Support_F {
        author = ECSTRING(core,AUTHORS);
        displayName = ECSTRING(core,NATO_crate);
        class TransportItems {};
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {
            MACRO_ADDBACKPACK(TFAR_rt1523g,10);
            MACRO_ADDBACKPACK(TFAR_rt1523g_big,3);
            MACRO_ADDBACKPACK(TFAR_rt1523g_sage,3);
            MACRO_ADDBACKPACK(TFAR_rt1523g_green,3);
            MACRO_ADDBACKPACK(TFAR_rt1523g_black,3);
            MACRO_ADDBACKPACK(TFAR_rt1523g_fabric,3);
            MACRO_ADDBACKPACK(TFAR_rt1523g_bwmod,1);
            MACRO_ADDBACKPACK(TFAR_rt1523g_big_bwmod,1);
            MACRO_ADDBACKPACK(TFAR_rt1523g_big_bwmod_tropen,1);
            MACRO_ADDBACKPACK(TFAR_rt1523g_big_rhs,1);
            MACRO_ADDBACKPACK(TFAR_rt1523g_rhs,1);
        };
    };
    HIDDEN_CLASS(TF_NATO_Radio_Crate : TFAR_NATO_Radio_Crate); //#Deprecated dummy class for backwards compat

    class Box_EAST_Support_F;
    class TFAR_EAST_Radio_Crate: Box_EAST_Support_F {
        author = ECSTRING(core,AUTHORS);
        displayName = ECSTRING(core,EAST_crate);
        class TransportItems {};
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {
            MACRO_ADDBACKPACK(TFAR_mr3000,10);
            MACRO_ADDBACKPACK(TFAR_mr3000_multicam,3);
            MACRO_ADDBACKPACK(TFAR_mr3000_bwmod,1);
            MACRO_ADDBACKPACK(TFAR_mr3000_bwmod_tropen,1);
            MACRO_ADDBACKPACK(TFAR_mr3000_rhs,1);
            MACRO_ADDBACKPACK(TFAR_bussole,3);
        };
    };
    HIDDEN_CLASS(TF_EAST_Radio_Crate : TFAR_EAST_Radio_Crate); //#Deprecated dummy class for backwards compat

    class Box_IND_Support_F;
    class TFAR_IND_Radio_Crate: Box_IND_Support_F {
        author = ECSTRING(core,AUTHORS);
        displayName = ECSTRING(core,IND_crate);
        class TransportItems {};
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {
            MACRO_ADDBACKPACK(TFAR_anprc155,10);
            MACRO_ADDBACKPACK(TFAR_anprc155_coyote,10);
        };
    };
    HIDDEN_CLASS(TF_IND_Radio_Crate : TFAR_IND_Radio_Crate); //#Deprecated dummy class for backwards compat
};
