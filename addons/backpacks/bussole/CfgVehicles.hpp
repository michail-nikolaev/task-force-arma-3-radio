class TFAR_bussole: TFAR_Bag_Base {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    author = "Raspu";
    displayName = "Assault Pack Bussole";//#Stringtable
    descriptionShort = "Bussole long range radio 20km";//#Stringtable
    picture = QPATHTOF(bussole\ui\bussole_icon.paa);
    maximumLoad = 30;
    mass = 120;
    model=QPATHTOF(models\tf_bussole);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {""};
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "bussole_radio_dialog";
    tf_subtype = "digital_lr";
    tf_halfDuplexOverride = 0; //0 disables half-duplex override, everything greater than 0 enables it
};
HIDDEN_CLASS(tf_bussole : TFAR_bussole); //#Deprecated dummy class for backwards compat
