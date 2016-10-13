class Item_TFAR_anprc154: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName =  "AN/PRC-154";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_anprc154,1);
    };
};
HIDDEN_CLASS(Item_tf_anprc154 : Item_TFAR_anprc154); //#Deprecated dummy class for backwards compat
