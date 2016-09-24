class tf_anprc155: TFAR_Bag_Base
  {
    author = "Raspu, Gandi, Nkey";
    displayName = "AN/PRC 155";
    descriptionShort = "AN/PRC 155 long range radio 20km";
    picture = "\task_force_radio_items\anprc155\155_icon.paa";
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 160;
    mass = 160;
    model="\task_force_radio_items\models\clf_nicecomm2";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_aff_digital_co.paa"};
    tf_encryptionCode = "tf_guer_radio_code";
    tf_dialog = "anprc155_radio_dialog";
    tf_subtype = "digital_lr";
  };
  class tf_anprc155_coyote: tf_anprc155
  {
    author = "Raspu, Gandi, Nkey";
    displayName = "AN/PRC 155 Coyote";
    descriptionShort = "AN/PRC 155 Coyote long range radio 20km";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_coyote_co.paa"};
  };