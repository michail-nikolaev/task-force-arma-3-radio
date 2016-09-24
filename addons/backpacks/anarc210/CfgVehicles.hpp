class tf_anarc210: TFAR_Bag_Base {
    displayName = "AN/ARC-210";
    descriptionShort = "AN/ARC-210 airborne radio 40km";//#Stringtable
    picture = QPATHOF(anarc210\ui\anarc210_icon.paa);
    model = QPATHOF(models\TFR_BACKPACK)
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHOF(models\data\camo\backpack_mcam_co.paa)};
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_west_radio_code";
    tf_dialog = "anarc210_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;";
};
