class Item_TFAR_pnr1000a: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName =  "$STR_TFAR_Veh_PNR1000A";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_pnr1000a,1);
    };
    #include "\z\tfar\addons\static_radios\edenAttributes.hpp"
};
HIDDEN_CLASS(Item_tf_pnr1000a : Item_TFAR_pnr1000a); //#Deprecated dummy class for backwards compat
