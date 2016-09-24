class tf_rf7800str: ItemRadio
  {
    author = "Raspu";
    displayName = "RF-7800S-TR";
    descriptionShort = "RF-7800S-TR rifleman radio 2km";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_rf7800";
    picture = "\task_force_radio_items\rf7800str\rf7800str_icon.paa";
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "rf7800str_radio_dialog";
    tf_encryptionCode = "tf_west_radio_code";
    tf_subtype = "digital";
    tf_parent = "tf_rf7800str";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
  };
  TF_RADIO_IDS(tf_rf7800str,RF-7800S-TR)