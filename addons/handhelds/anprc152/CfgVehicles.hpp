class Item_TFAR_anprc152: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName = "AN/PRC-152";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_anprc152,1);
    };
    #include "\z\tfar\addons\static_radios\edenAttributes.hpp"
};
HIDDEN_CLASS(Item_tf_anprc152 : Item_TFAR_anprc152); //#Deprecated dummy class for backwards compat
