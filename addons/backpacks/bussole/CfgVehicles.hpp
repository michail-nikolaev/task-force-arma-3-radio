class tf_bussole: TFAR_Bag_Base {
    author = "Raspu";
    displayName = "Assault Pack Bussole";//#Stringtable
    descriptionShort = "Bussole long range radio 20km";//#Stringtable
    picture = QPATHTOF(bussole\ui\bussole_icon.paa);
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 30;
    mass = 120;
    model=QPATHTOF(models\tf_bussole);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {""};
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "bussole_radio_dialog";
    tf_subtype = "digital_lr";
};
