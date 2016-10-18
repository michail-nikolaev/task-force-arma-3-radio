#include "script_component.hpp"

class CfgPatches {
  class ADDON {
      units[] = {
        "TFAR_NATO_Radio_Crate",
        "TFAR_EAST_Radio_Crate",
        "TFAR_IND_Radio_Crate",
        "TFAR_rt1523g",
        "TFAR_anprc155",
        "TFAR_mr3000",
        "TFAR_anarc164",
        "TFAR_mr6000l",
        "TFAR_anarc210",
        "TFAR_mr3000_multicam",
        "TFAR_anprc155_coyote",
        "TFAR_rt1523g_sage",
        "TFAR_rt1523g_green",
        "TFAR_rt1523g_fabric",
        "TFAR_rt1523g_big",
        "TFAR_rt1523g_black",
        "TFAR_rt1523g_big_bwmod",
        "TFAR_mr3000_bwmod",
        "TFAR_rt1523g_bwmod",
        "TFAR_mr3000_bwmod_tropen",
        "TFAR_rt1523g_big_bwmod_tropen",
        "TFAR_rt1523g_big_rhs",
        "TFAR_rt1523g_rhs",
        "TFAR_mr3000_rhs",
        "TFAR_bussole"
    };
    weapons[] = {};
    requiredVersion = REQUIRED_VERSION;
    requiredAddons[] = {
        "A3_Modules_F",
        "A3_UI_F",
        "A3_Structures_F_Items_Electronics",
        "A3_Weapons_F_ItemHolders",
        "tfar_core"
    };
    Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
  };
};

class CfgFactionClasses {
    class TFAR {
        displayName = "TFAR";
        priority = 10;
        side = 7;
    };
    class BLU_G_F {
        backpack_tf_faction_radio = "TFAR_rt1523g_sage";
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
