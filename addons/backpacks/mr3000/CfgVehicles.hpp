class tf_mr3000: TFAR_Bag_Base {
    author = "Raspu, Gandi, Nkey";
    displayName = "MR3000";
    descriptionShort = "MR3000 long range radio 20km";//#Stringtable
    picture = QPATHOF(mr3000\ui\mr3000_icon.paa);
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 160;
    mass = 160;
    model = QPATHOF(models\clf_nicecomm2_prc117g);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHOF(models\data\clf_nicecomm2_csat_multi_co.paa)};
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "mr3000_radio_dialog";
    tf_subtype = "digital_lr";
};
class tf_mr3000_multicam: tf_mr3000 {
    author = "Raspu, Gandi, Nkey";
    displayName = "MR3000 Multicam";
    descriptionShort = "MR3000 Multicam long range radio 20km";//#Stringtable
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHOF(models\data\clf_nicecomm2_co.paa)};
};
class tf_mr3000_bwmod: tf_mr3000 {
    displayName = "MR3000 BWMOD [Flecktarn]";
    descriptionShort = "MR3000 BWMOD long range radio 20km";//#Stringtable
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHOF(models\data\clf_nicecomm2_bwmod_co.paa)};
};
class tf_mr3000_bwmod_tropen: tf_mr3000_bwmod {
    displayName = "MR3000 BWMOD [Tropentarn]";//#Stringtable
    hiddenSelectionsTextures[] = {QPATHOF(models\data\jgbtl14_marcbook_bwmod_tropen_co.paa)};
};
class tf_mr3000_rhs: tf_mr3000 {
    displayName = "MR3000 RHS";
    descriptionShort = "MR3000 RHS long range radio 20km";//#Stringtable
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHOF(models\data\clf_nicecomm2_rhs_digital_co.paa)};
};
