class CfgVehicles {
    class Item_Base_F;
    #include "anprc148jem/CfgVehicles.hpp"
    #include "anprc152/CfgVehicles.hpp"
    #include "anprc154/CfgVehicles.hpp"
    #include "fadak/CfgVehicles.hpp"
    #include "microdagr/CfgVehicles.hpp"
    #include "pnr1000a/CfgVehicles.hpp"
    #include "rf7800/CfgVehicles.hpp"


    class Box_NATO_Support_F;
    class TF_NATO_Radio_Crate: Box_NATO_Support_F {
        author = "TFAR";
        displayName = "$STR_TFAR_NATO_crate";
        class TransportItems {
            MACRO_ADDITEM(tf_anprc152,40),
            MACRO_ADDITEM(tf_rf7800str,40)
        };
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {};
    };

    class Box_EAST_Support_F;
    class TF_EAST_Radio_Crate: Box_EAST_Support_F {
        author = QUOTE(AUTHORS);
        displayName = "$STR_TFAR_EAST_crate";
        class TransportItems {
            MACRO_ADDITEM(tf_fadak,40),
            MACRO_ADDITEM(tf_pnr1000a,40)
        };
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {};
    };

    class Box_IND_Support_F;
    class TF_IND_Radio_Crate: Box_IND_Support_F {
        author = QUOTE(AUTHORS);
        displayName = "$STR_TFAR_IND_crate";
        class TransportItems {
            MACRO_ADDITEM(tf_anprc148jem,40),
            MACRO_ADDITEM(tf_anprc154,40)
        };
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {};
    };
};
