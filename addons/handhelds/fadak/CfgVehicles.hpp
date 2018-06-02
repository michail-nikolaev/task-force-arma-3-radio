class Item_TFAR_fadak: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName = "FADAK";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_fadak,1);
    };
    #include "\z\tfar\addons\static_radios\edenAttributes.hpp"
};
HIDDEN_CLASS(Item_tf_fadak : Item_TFAR_fadak); //#Deprecated dummy class for backwards compat
