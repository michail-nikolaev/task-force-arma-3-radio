#include "script_component.hpp"

class CfgPatches {
  class ADDON {
    units[] = {
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
    requiredVersion = REQUIRED_VERSION;
    requiredAddons[] = {"A3_Modules_F", "A3_UI_F", "A3_Structures_F_Items_Electronics", "A3_Weapons_F_ItemHolders"};
    Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
    author = QUOTE(AUTHORS);
    VERSION_CONFIG;
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

#include "CfgVehicles.hpp"

#include "uiDefines.hpp"

#include "anarc164\ui\anarc164.ext"
#include "anarc210\ui\anarc210.ext"
#include "anprc155\ui\anprc155.ext"
#include "bussole\ui\bussole.ext"
#include "mr3000\ui\mr3000.ext"
#include "mr6000l\ui\mr6000l.ext"
#include "rt1523g\ui\rt1523g.ext"
