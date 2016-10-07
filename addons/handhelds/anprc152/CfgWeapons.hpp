class tf_anprc152: ItemRadio {
    author = "Raspu";
    displayName = "AN/PRC-152";
    descriptionShort = "AN/PRC-152 personal radio 5km";//#Stringtable
    scope = 2;
    scopeCurator = 2;
    model = QPATHTOF(anprc152\data\tfr_anprc152);
    picture = QPATHTOF(anprc152\ui\152_icon.paa);
    tf_prototype = 1;
    tf_range = 5000;
    tf_dialog = "anprc152_radio_dialog";
    tf_encryptionCode = "tf_west_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "tf_anprc152";
    tf_additional_channel = 1;
};
TF_RADIO_IDS(tf_anprc152,AN/PRC-152)
