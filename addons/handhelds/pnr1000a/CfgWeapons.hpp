class tf_pnr1000a: ItemRadio {
    displayName = "PNR-1000A";
    descriptionShort = "PNR-1000A rifleman radio 2km";//#Stringtable
    scope = 2;
    scopeCurator = 2;
    model = QPATHOF(models\tfr_pnr1000a);
    picture = QPATHOF(pnr1000a\ui\pnr1000a_icon.paa);
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "pnr1000a_radio_dialog";
    tf_encryptionCode = "tf_east_radio_code";
    tf_subtype = "digital";
    tf_parent = "tf_pnr1000a";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
};
TF_RADIO_IDS(tf_rf7800str,RF-7800S-TR)
