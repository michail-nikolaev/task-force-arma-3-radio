class CfgPatches {
  class ADDON {
    units[] = {
        "tfar_ModuleTaskForceRadioEnforceUsage",
        "tfar_ModuleTaskForceRadio",
        "tfar_ModuleTaskForceRadioFrequencies",
        "TF_NATO_Radio_Crate",
        "TF_EAST_Radio_Crate",
        "TF_IND_Radio_Crate",
        "tf_rt1523g",
        "tf_anprc155",
        "tf_mr3000",
        "tf_anarc164",
        "tf_mr6000l",
        "tf_anarc210",
        "tf_mr3000_multicam",
        "tf_anprc155_coyote",
        "tf_rt1523g_sage",
        "tf_rt1523g_green",
        "tf_rt1523g_fabric",
        "tf_rt1523g_big",
        "tf_rt1523g_black",
        "tf_rt1523g_big_bwmod",
        "tf_mr3000_bwmod",
        "tf_rt1523g_bwmod",
        "tf_mr3000_bwmod_tropen",
        "tf_rt1523g_big_bwmod_tropen",
        "tf_rt1523g_big_rhs",
        "tf_rt1523g_rhs",
        "tf_mr3000_rhs",
        "tf_bussole"
    };
    weapons[] = {};
    requiredVersion = 1.0;
    requiredAddons[] = {"A3_Modules_F", "A3_UI_F", "A3_Structures_F_Items_Electronics", "A3_Weapons_F_ItemHolders"};
    author = "[TF]Nkey";
    Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
    version = 1.0.0;
    versionStr = "1.0.0";
    versionAr[] = {1,0,0};
  };
};

class CfgFactionClasses {
    class TFAR {
        displayName = "TFAR";
        priority = 10;
        side = 7;
    };
    class BLU_G_F {
        backpack_tf_faction_radio = "tf_rt1523g_sage";
    };
};

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

    #include "vehicles.hpp"
    #include "crates.hpp"
    #include "modules.hpp"


};
