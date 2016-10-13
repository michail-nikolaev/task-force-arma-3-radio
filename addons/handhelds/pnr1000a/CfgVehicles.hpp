class Item_TFAR_pnr1000a: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName =  "PNR-1000A";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_pnr1000a,1);
    };
};
HIDDEN_CLASS(Item_tf_pnr1000a : Item_TFAR_pnr1000a); //#Deprecated dummy class for backwards compat
