class TFAR_pnr1000a: ItemRadio {
    displayName = CSTRING(PNR1000A);
    descriptionShort = CSTRING(PNR1000A_Desc);
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    model = QPATHTOF(pnr1000a\data\tfr_pnr1000a);
    picture = QPATHTOF(pnr1000a\ui\pnr1000a_icon.paa);
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "pnr1000a_radio_dialog";
    tf_encryptionCode = "tf_east_radio_code";
    tf_subtype = "digital";
    tf_parent = "TFAR_pnr1000a";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
};
HIDDEN_CLASS(tf_pnr1000a : TFAR_pnr1000a); //#Deprecated dummy class for backwards compat
TF_RADIO_IDS(TFAR_pnr1000a,PNR-1000A)
