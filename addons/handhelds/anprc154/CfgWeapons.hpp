class TFAR_anprc154: ItemRadio {
    author = "Raspu";
    displayName = "$STR_TFAR_Veh_ANPRC154";
    descriptionShort = "$STR_TFAR_Veh_ANPRC154_Desc";
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    model = QPATHTOF(anprc154\data\tfr_anprc154);
    picture = QPATHTOF(anprc154\ui\154_icon.paa);
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "anprc154_radio_dialog";
    tf_encryptionCode = "tf_independent_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "TFAR_anprc154";
    tf_additional_channel = 0;
};
HIDDEN_CLASS(tf_anprc154 : TFAR_anprc154); //#Deprecated dummy class for backwards compat
TF_RADIO_IDS(TFAR_anprc154,AN/PRC-154)
