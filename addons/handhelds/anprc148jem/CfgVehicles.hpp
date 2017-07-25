class Item_TFAR_anprc148jem: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName = "$STR_TFAR_Veh_ANPRC148JEM";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_anprc148jem,1);
    };
    #include "\z\tfar\addons\static_radios\edenAttributes.hpp"
};
HIDDEN_CLASS(Item_tf_anprc148jem : Item_TFAR_anprc148jem); //#Deprecated dummy class for backwards compat
