class CfgVehicles {
    class Item_Base_F;
    #include "anprc148jem\CfgVehicles.hpp"
    #include "anprc152\CfgVehicles.hpp"
    #include "anprc154\CfgVehicles.hpp"
    #include "fadak\CfgVehicles.hpp"
    #include "microdagr\CfgVehicles.hpp"
    #include "pnr1000a\CfgVehicles.hpp"
    #include "rf7800\CfgVehicles.hpp"


    class Box_NATO_Support_F;
    class TFAR_NATO_Radio_Crate: Box_NATO_Support_F {
        author = "TFAR";
        displayName = "$STR_TFAR_NATO_crate";
        class TransportItems {
            MACRO_ADDITEM(TFAR_anprc152,40);
            MACRO_ADDITEM(TFAR_rf7800str,40);
            MACRO_ADDITEM(TFAR_microdagr,5);
        };
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {};
    };
    HIDDEN_CLASS(TF_NATO_Radio_Crate : TFAR_NATO_Radio_Crate); //#Deprecated dummy class for backwards compat

    class Box_EAST_Support_F;
    class TFAR_EAST_Radio_Crate: Box_EAST_Support_F {
        author = QUOTE(AUTHORS);
        displayName = "$STR_TFAR_EAST_crate";
        class TransportItems {
            MACRO_ADDITEM(TFAR_fadak,40);
            MACRO_ADDITEM(TFAR_pnr1000a,40);
            MACRO_ADDITEM(TFAR_microdagr,5);
        };
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {};
    };
    HIDDEN_CLASS(TF_EAST_Radio_Crate : TFAR_EAST_Radio_Crate); //#Deprecated dummy class for backwards compat

    class Box_IND_Support_F;
    class TFAR_IND_Radio_Crate: Box_IND_Support_F {
        author = QUOTE(AUTHORS);
        displayName = "$STR_TFAR_IND_crate";
        class TransportItems {
            MACRO_ADDITEM(TFAR_anprc148jem,40);
            MACRO_ADDITEM(TFAR_anprc154,40);
            MACRO_ADDITEM(TFAR_microdagr,5);
        };
        class TransportMagazines{};
        class TransportWeapons{};
        class TransportBackpacks {};
    };
    HIDDEN_CLASS(TF_IND_Radio_Crate : TFAR_IND_Radio_Crate); //#Deprecated dummy class for backwards compat
};
