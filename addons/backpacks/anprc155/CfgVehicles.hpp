class TFAR_anprc155: TFAR_Bag_Base {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    author = "Raspu, Gandi, Nkey";
    displayName = "AN/PRC-155";
    descriptionShort = "AN/PRC-155 long range radio 20km";//#Stringtable
    picture = QPATHTOF(anprc155\ui\155_icon.paa);
    maximumLoad = 160;
    mass = 160;
    model=QPATHTOF(models\clf_nicecomm2);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_aff_digital_co.paa)};
    tf_encryptionCode = "tf_independent_radio_code";
    tf_dialog = "anprc155_radio_dialog";
    tf_subtype = "digital_lr";
    tf_halfDuplexOverride = 0; //0 disables half-duplex override, everything greater than 0 enables it
};
HIDDEN_CLASS(tf_anprc155 : TFAR_anprc155); //#Deprecated dummy class for backwards compat
class TFAR_anprc155_coyote: TFAR_anprc155 {
    author = "Raspu, Gandi, Nkey";
    displayName = "AN/PRC-155 Coyote";
    descriptionShort = "AN/PRC-155 Coyote long range radio 20km";//#Stringtable
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_coyote_co.paa)};
};
HIDDEN_CLASS(tf_anprc155_coyote : TFAR_anprc155_coyote); //#Deprecated dummy class for backwards compat
