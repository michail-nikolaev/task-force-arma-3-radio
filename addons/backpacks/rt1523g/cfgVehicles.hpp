class TFAR_rt1523g: TFAR_Bag_Base {
    scope = PUBLIC;
    scopeCurator = PUBLIC;
    author = "Raspu, Gandi, Nkey";
    displayName = "$STR_TFAR_BP_RT1523G";
    descriptionShort = "$STR_TFAR_BP_RT1523G_Desc";
    picture = QPATHTOF(rt1523g\ui\rt1523g_icon.paa);
    model=QPATHTOF(models\clf_prc117g_ap);
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_prc117g_ap_co.paa)};
    maximumLoad = 50;
    mass = 80;
    tf_encryptionCode = "tf_west_radio_code";
    tf_dialog = "rt1523g_radio_dialog";
    tf_subtype = "digital_lr";
};
HIDDEN_CLASS(tf_rt1523g : TFAR_rt1523g); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_bwmod: TFAR_rt1523g {
    displayName = "$STR_TFAR_BP_RT1523G_BWMOD";
    descriptionShort = "$STR_TFAR_BP_RT1523G_BWMOD_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_prc117g_bwmod_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_bwmod : TFAR_rt1523g_bwmod); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_rhs: TFAR_rt1523g {
    displayName = "$STR_TFAR_BP_RT1523G_RHS";
    descriptionShort = "$STR_TFAR_BP_RT1523G_RHS_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_prc117g_rhs_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_rhs : TFAR_rt1523g_rhs); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_big: TFAR_rt1523g {
    author = "Raspu, Gandi, Nkey";
    displayName = "$STR_TFAR_BP_RT1523G_Big";
    descriptionShort = "$STR_TFAR_BP_RT1523G_Big_Desc";
    maximumLoad = 160;
    mass = 160;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_nato_multi_co.paa)};
    model=QPATHTOF(models\clf_nicecomm2);
};
HIDDEN_CLASS(tf_rt1523g_big : TFAR_rt1523g_big); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_big_bwmod: TFAR_rt1523g_big {
    displayName = "$STR_TFAR_BP_RT1523G_BigBWMOD";
    descriptionShort = "$STR_TFAR_BP_RT1523G_BigBWMOD_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_bwmod_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_big_bwmod : TFAR_rt1523g_big_bwmod); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_big_bwmod_tropen: TFAR_rt1523g_big_bwmod {
    displayName = "$STR_TFAR_BP_RT1523G_BigBWMOD_Tropen";
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\jgbtl14_marcbook_bwmod_tropen_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_big_bwmod_tropen : TFAR_rt1523g_big_bwmod_tropen); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_big_rhs: TFAR_rt1523g_big {
    displayName = "$STR_TFAR_BP_RT1523G_BigRHS";
    descriptionShort = "$STR_TFAR_BP_RT1523G_BigRHS_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\clf_nicecomm2_rhs_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_big_rhs : TFAR_rt1523g_big_rhs); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_sage: TFAR_rt1523g {
    displayName = "$STR_TFAR_BP_RT1523G_Sage";
    descriptionShort = "$STR_TFAR_BP_RT1523G_Sage_Desc";
    maximumLoad = 100;
    mass = 120;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\camo\backpack_sage_co.paa)};
    model = QPATHTOF(models\TFR_BACKPACK);
};
HIDDEN_CLASS(tf_rt1523g_sage : TFAR_rt1523g_sage); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_green: TFAR_rt1523g_sage {
    displayName = "$STR_TFAR_BP_RT1523G_Green";
    descriptionShort = "$STR_TFAR_BP_RT1523G_Green_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\camo\backpack_green_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_green : TFAR_rt1523g_green); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_fabric: TFAR_rt1523g_sage {
    displayName = "$STR_TFAR_BP_RT1523G_Fabric";
    descriptionShort = "$STR_TFAR_BP_RT1523G_Fabric_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\camo\backpack_fabric_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_fabric : TFAR_rt1523g_fabric); //#Deprecated dummy class for backwards compat
class TFAR_rt1523g_black: TFAR_rt1523g_sage {
    displayName = "$STR_TFAR_BP_RT1523G_Black";
    descriptionShort = "$STR_TFAR_BP_RT1523G_Black_Desc";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {QPATHTOF(models\data\camo\backpack_black_co.paa)};
};
HIDDEN_CLASS(tf_rt1523g_black : TFAR_rt1523g_black); //#Deprecated dummy class for backwards compat
