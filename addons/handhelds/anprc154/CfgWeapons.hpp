class tf_anprc154: ItemRadio {
    author = "Raspu";
    displayName = "AN/PRC-154";
    descriptionShort = "AN/PRC-154 rifleman radio 2km";//#Stringtable
    scope = 2;
    scopeCurator = 2;
    model = QPATHTOF(anprc154\data\tfr_anprc154);
    picture = QPATHTOF(anprc154\ui\154_icon.paa);
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "anprc154_radio_dialog";
    tf_encryptionCode = "tf_guer_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "tf_anprc154";
    tf_additional_channel = 0;
};
TF_RADIO_IDS(tf_anprc154,AN/PRC-154)
