#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        units[] = {
            "TF_NATO_Radio_Crate",
            "TF_EAST_Radio_Crate",
            "TF_IND_Radio_Crate",
            "Item_tf_anprc152",
            "Item_tf_pnr1000a",
            "Item_tf_anprc148jem",
            "Item_tf_fadak",
            "Item_tf_anprc154",
            "Item_tf_rf7800str",
            "Item_tf_microdagr",
            "tf_microdagr"
        };
        weapons[] = {
            "tf_anprc152",
            "tf_anprc148jem",
            "tf_fadak",
            "tf_anprc154",
            "tf_rf7800str",
            "tf_pnr1000a"
        };
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"A3_Modules_F", "A3_UI_F", "A3_Structures_F_Items_Electronics", "A3_Weapons_F_ItemHolders"};
        Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
        author = QUOTE(AUTHORS);
        VERSION_CONFIG;
    };
};

#include "CfgVehicles.hpp"

#include "radio_ids.hpp"

class CfgWeapons {
    class ItemRadio;
    #include "anprc148jem/CfgWeapons.hpp"
    #include "anprc152/CfgWeapons.hpp"
    #include "anprc154/CfgWeapons.hpp"
    #include "fadak/CfgWeapons.hpp"
    #include "microdagr/CfgWeapons.hpp"
    #include "pnr1000a/CfgWeapons.hpp"
    #include "rf7800/CfgWeapons.hpp"
};
