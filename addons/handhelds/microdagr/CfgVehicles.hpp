class Item_TFAR_microdagr: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName = CSTRING(MicroDagr);
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_microdagr,1);
    };
};
HIDDEN_CLASS(Item_tf_microdagr : Item_TFAR_microdagr); //#Deprecated dummy class for backwards compat
