class tf_fadak: ItemRadio
  {
    displayName = "FADAK";
    descriptionShort = "FADAK personal radio 5km";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_fadak";
    picture = "\task_force_radio_items\fadak\fadak_icon.paa";
    tf_prototype = 1;
    tf_range = 5000;
    tf_dialog = "fadak_radio_dialog";
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "tf_fadak";
    tf_additional_channel = 1;
  };
  TF_RADIO_IDS(tf_fadak,FADAK)