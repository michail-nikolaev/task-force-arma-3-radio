class Item_TFAR_rf7800str: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName =  "RF-7800S-TR";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_rf7800str,1);
    };
};
HIDDEN_CLASS(Item_tf_rf7800str : Item_TFAR_rf7800str); //#Deprecated dummy class for backwards compat
