class tf_mr6000l: TFAR_Bag_Base {
    displayName = "MR6000L";
    descriptionShort = "MR6000L airborne radio 40km";
    model = QPATHTOF(models\TFR_BACKPACK);
    picture = QPATHTOF(mr6000l\iu\mr6000l_icon.paa);
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "mr6000l_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;";
};
