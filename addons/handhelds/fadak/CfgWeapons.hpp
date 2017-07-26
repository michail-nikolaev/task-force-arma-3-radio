class TFAR_fadak: ItemRadio {
    displayName = "FADAK";
    descriptionShort = "$STR_TFAR_Veh_FADAK_Desc";
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    model = QPATHTOF(fadak\data\tfr_fadak);
    picture = QPATHTOF(fadak\ui\fadak_icon.paa);
    tf_prototype = 1;
    tf_range = 5000;
    tf_dialog = "fadak_radio_dialog";
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "TFAR_fadak";
    tf_additional_channel = 1;
};
HIDDEN_CLASS(tf_fadak : TFAR_fadak); //#Deprecated dummy class for backwards compat
TF_RADIO_IDS(TFAR_fadak,FADAK)
