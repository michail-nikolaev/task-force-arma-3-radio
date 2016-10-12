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
            "Item_tf_microdagr"
        };
        weapons[] = {
            "tf_anprc152",
            "tf_anprc148jem",
            "tf_fadak",
            "tf_anprc154",
            "tf_rf7800str",
            "tf_pnr1000a",
            "tf_microdagr"
        };
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

class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

#include "radio_ids.hpp"

class CfgWeapons {
    class ItemRadio;
    #include "anprc148jem\CfgWeapons.hpp"
    #include "anprc152\CfgWeapons.hpp"
    #include "anprc154\CfgWeapons.hpp"
    #include "fadak\CfgWeapons.hpp"
    #include "microdagr\CfgWeapons.hpp"
    #include "pnr1000a\CfgWeapons.hpp"
    #include "rf7800\CfgWeapons.hpp"
};

#include "CfgVehicles.hpp"
#include "uiDefines.hpp"
//This is here because uiDefines is #included from a script
//having classes in there would cause errors
class RscBackPicture;
class RscEditLCD;
class HiddenButton;
class HiddenRotator;
class HiddenFlip;
#include "anprc148jem\ui\anprc148jem.ext"
#include "anprc152\ui\anprc152.ext"
#include "anprc154\ui\anprc154.ext"
#include "diver_radio\ui\diver_radio.ext"
#include "fadak\ui\fadak.ext"
#include "pnr1000a\ui\pnr1000a.ext"
#include "rf7800\ui\rf7800str.ext"
