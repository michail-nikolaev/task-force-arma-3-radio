class TFAR_mr3000: TFAR_Bag_Base {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    author = "Raspu, Gandi, Nkey";
    displayName = "MR3000";
    descriptionShort = "$STR_TFAR_BP_MR3000_Desc";
    picture = QPATHTOF(mr3000\ui\mr3000_icon.paa);
    maximumLoad = 160;
    mass = 160;
    model = QPATHTOF(models\clf_nicecomm2_prc117g);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_csat_multi_co.paa)};
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "mr3000_radio_dialog";
    tf_subtype = "digital_lr";
};
HIDDEN_CLASS(tf_mr3000 : TFAR_mr3000); //#Deprecated dummy class for backwards compat
class TFAR_mr3000_multicam: TFAR_mr3000 {
    author = "Raspu, Gandi, Nkey";
    displayName = "$STR_TFAR_BP_MR3000_Multicam";
    descriptionShort = "$STR_TFAR_BP_MR3000_Multicam_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_co.paa)};
};
HIDDEN_CLASS(tf_mr3000_multicam : TFAR_mr3000_multicam); //#Deprecated dummy class for backwards compat
class TFAR_mr3000_bwmod: TFAR_mr3000 {
    displayName = "$STR_TFAR_BP_MR3000_BWMOD";
    descriptionShort = "$STR_TFAR_BP_MR3000_BWMOD_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_bwmod_co.paa)};
	tf_encryptionCode = "tf_west_radio_code";
};
HIDDEN_CLASS(tf_mr3000_bwmod : TFAR_mr3000_bwmod); //#Deprecated dummy class for backwards compat
class TFAR_mr3000_bwmod_tropen: TFAR_mr3000_bwmod {
    displayName = "$STR_TFAR_BP_MR3000_BWMOD_Tropen";
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\jgbtl14_marcbook_bwmod_tropen_co.paa)};
};
HIDDEN_CLASS(tf_mr3000_bwmod_tropen : TFAR_mr3000_bwmod_tropen); //#Deprecated dummy class for backwards compat
class TFAR_mr3000_rhs: TFAR_mr3000 {
    displayName = "MR3000 RHS";
    descriptionShort = "$STR_TFAR_BP_MR3000_RHS_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_rhs_digital_co.paa)};
};
HIDDEN_CLASS(tf_mr3000_rhs : TFAR_mr3000_rhs); //#Deprecated dummy class for backwards compat
