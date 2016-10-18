class Item_TFAR_anprc148jem: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName = "AN/PRC-148 JEM";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_anprc148jem,1);
    };
};
HIDDEN_CLASS(Item_tf_anprc148jem : Item_TFAR_anprc148jem); //#Deprecated dummy class for backwards compat
