class tf_rf7800str: ItemRadio {
    author = "Raspu";
    displayName = "RF-7800S-TR";
    descriptionShort = "RF-7800S-TR rifleman radio 2km";//#Stringtable
    scope = 2;
    scopeCurator = 2;
    model = QPATHTOF(models\tfr_rf7800);
    picture = QPATHTOF(rf7800str\ui\rf7800str_icon.paa);
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "rf7800str_radio_dialog";
    tf_encryptionCode = "tf_west_radio_code";
    tf_subtype = "digital";
    tf_parent = "tf_rf7800str";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
};
TF_RADIO_IDS(tf_rf7800str,RF-7800S-TR)
