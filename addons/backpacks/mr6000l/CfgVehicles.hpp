class TFAR_mr6000l: TFAR_Bag_Base {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    displayName = CSTRING(MR6000L);
    descriptionShort = CSTRING(MR6000L_Desc);
    model = QPATHTOF(models\TFR_BACKPACK);
    picture = QPATHTOF(mr6000l\ui\mr6000l_icon.paa);
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "mr6000l_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;";
};
HIDDEN_CLASS(tf_mr6000l : TFAR_mr6000l); //#Deprecated dummy class for backwards compat
