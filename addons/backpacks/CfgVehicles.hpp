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
        scope = 1;
        scopeCurator = 1;
    };

    #include "anarc164/CfgVehicles.hpp"
    #include "anarc210/CfgVehicles.hpp"
    #include "bussole/CfgVehicles.hpp"
    #include "mr3000/CfgVehicles.hpp"
    #include "mr6000l/CfgVehicles.hpp"
    #include "rt1523g/CfgVehicles.hpp"


    class Box_NATO_Support_F;
    class TF_NATO_Radio_Crate: Box_NATO_Support_F {
    	author = "TFAR";
    	displayName = "$STR_TFAR_NATO_crate";
    	class TransportItems {};
    	class TransportMagazines{};
    	class TransportWeapons{};
    	class TransportBackpacks {
            MACRO_ADDBACKPACK(tf_rt1523g,10),
            MACRO_ADDBACKPACK(tf_rt1523g_big,3),
            MACRO_ADDBACKPACK(tf_rt1523g_sage,3),
            MACRO_ADDBACKPACK(tf_rt1523g_green,3),
            MACRO_ADDBACKPACK(tf_rt1523g_black,3),
            MACRO_ADDBACKPACK(tf_rt1523g_fabric,3),
            MACRO_ADDBACKPACK(tf_rt1523g_bwmod,1),
            MACRO_ADDBACKPACK(tf_rt1523g_bwmod,1),
            MACRO_ADDBACKPACK(tf_rt1523g_big_bwmod,1),
            MACRO_ADDBACKPACK(tf_rt1523g_big_bwmod_tropen,1),
            MACRO_ADDBACKPACK(tf_rt1523g_big_rhs,1),
            MACRO_ADDBACKPACK(tf_rt1523g_rhs,1)
    	};
    };

    class Box_EAST_Support_F;
    class TF_EAST_Radio_Crate: Box_EAST_Support_F {
    	author = QUOTE(AUTHORS);
    	displayName = "$STR_TFAR_EAST_crate";
    	class TransportItems {};
    	class TransportMagazines{};
    	class TransportWeapons{};
    	class TransportBackpacks {
            MACRO_ADDBACKPACK(tf_mr3000,10),
            MACRO_ADDBACKPACK(tf_mr3000_multicam,3),
            MACRO_ADDBACKPACK(tf_mr3000_bwmod1),
            MACRO_ADDBACKPACK(tf_mr3000_bwmod_tropen,1),
            MACRO_ADDBACKPACK(tf_mr3000_rhs,1),
            MACRO_ADDBACKPACK(tf_bussole,3)
    	};
    };

    class Box_IND_Support_F;
    class TF_IND_Radio_Crate: Box_IND_Support_F {
    	author = QUOTE(AUTHORS);
    	displayName = "$STR_TFAR_IND_crate";
    	class TransportItems {};
    	class TransportMagazines{};
    	class TransportWeapons{};
    	class TransportBackpacks {
            MACRO_ADDBACKPACK(tf_anprc155,10),
            MACRO_ADDBACKPACK(tf_anprc155_coyote,10)
    	};
    };
};
