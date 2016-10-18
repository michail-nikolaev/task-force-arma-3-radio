class TFAR_anarc164: TFAR_Bag_Base {
    displayName = "AN/ARC-164";
    descriptionShort = "AN/ARC-164 airborne radio 40km";//#Stringtable
    picture = QPATHTOF(anarc164\ui\anarc164_icon.paa);
    model = QPATHTOF(models\TFR_BACKPACK);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\camo\backpack_dpcu_co.paa)};
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_guer_radio_code";
    tf_dialog = "anarc164_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""%1""] call TFAR_fnc_updateLRDialogToChannel;";
};
HIDDEN_CLASS(tf_anarc164 : TFAR_anarc164); //#Deprecated dummy class for backwards compat
