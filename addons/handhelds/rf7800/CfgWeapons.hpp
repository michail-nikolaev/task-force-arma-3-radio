class TFAR_rf7800str: ItemRadio {
    author = "Raspu";
    displayName = CSTRING(RF7800STR);
    descriptionShort = CSTRING(RF7800STR_Desc);
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    model = QPATHTOF(rf7800\data\tfr_rf7800);
    picture = QPATHTOF(rf7800\ui\rf7800str_icon.paa);
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "rf7800str_radio_dialog";
    tf_encryptionCode = "tf_west_radio_code";
    tf_subtype = "digital";
    tf_parent = "TFAR_rf7800str";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
};
HIDDEN_CLASS(tf_rf7800str : TFAR_rf7800str); //#Deprecated dummy class for backwards compat
TF_RADIO_IDS(TFAR_rf7800str,RF-7800S-TR)
