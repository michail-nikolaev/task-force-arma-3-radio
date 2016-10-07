class tf_anprc148jem: ItemRadio {
    author = "Raspu";
    displayName = "AN/PRC-148 JEM";
    descriptionShort = "AN/PRC-148 JEM personal radio 5km";//#Stringtable
    scope = 2;
    scopeCurator = 2;
    model = QPATHTOF(anprc148jem\data\tfr_anprc148);
    picture = QPATHTOF(anprc148jem\ui\148_icon.paa);
    tf_prototype = 1;
    tf_range = 5000;
    tf_dialog = "anprc148jem_radio_dialog";
    tf_encryptionCode = "tf_guer_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "tf_anprc148jem";
    tf_additional_channel = 1;
};
TF_RADIO_IDS(tf_anprc148jem,AN/PRC-148 JEM)
