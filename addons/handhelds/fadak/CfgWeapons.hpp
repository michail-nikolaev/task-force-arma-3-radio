class TFAR_fadak: ItemRadio {
    displayName = "FADAK";
    descriptionShort = "FADAK personal radio 5km";//#Stringtable
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
    tf_halfDuplexOverride = 0; //0 disables half-duplex override, everything greater than 0 enables it
};
HIDDEN_CLASS(tf_fadak : TFAR_fadak); //#Deprecated dummy class for backwards compat
TF_RADIO_IDS(TFAR_fadak,FADAK)
