class tf_anprc154: ItemRadio
  {
    author = "Raspu";
    displayName = "AN/PRC-154";
    descriptionShort = "AN/PRC-154 rifleman radio 2km";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_anprc154";
    picture = "\task_force_radio_items\anprc154\154_icon.paa";
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "anprc154_radio_dialog";
    tf_encryptionCode = "tf_guer_radio_code";
    tf_subtype = "digital";
    tf_parent = "tf_anprc154";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
  };
  TF_RADIO_IDS(tf_anprc154,AN/PRC-154)