class Item_TFAR_rf7800str: Item_Base_F {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName =  "$STR_TFAR_Veh_RF7800STR";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems {
        MACRO_ADDITEM(TFAR_rf7800str,1);
    };
    #include "\z\tfar\addons\static_radios\edenAttributes.hpp"
};
HIDDEN_CLASS(Item_tf_rf7800str : Item_TFAR_rf7800str); //#Deprecated dummy class for backwards compat
