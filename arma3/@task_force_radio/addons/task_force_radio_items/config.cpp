class CfgPatches
{
  class task_force_radio_items
  {
    units[] = {
      "tfar_ModuleTaskForceRadioEnforceUsage",
      "tfar_ModuleTaskForceRadio",
      "tfar_ModuleTaskForceRadioFrequencies",
      "TF_NATO_Radio_Crate",
      "TF_EAST_Radio_Crate",
      "TF_IND_Radio_Crate",
      "tf_rt1523g",
      "tf_anprc155",
      "tf_mr3000",
      "tf_anarc164",
      "tf_mr6000l",
      "tf_anarc210",
      "tf_mr3000_multicam",
      "tf_anprc155_coyote",
      "Item_tf_anprc152",
      "Item_tf_pnr1000a",
      "Item_tf_anprc148jem",
      "Item_tf_fadak",
      "Item_tf_anprc154",
      "Item_tf_rf7800str",
      "Item_tf_microdagr",
      "tf_rt1523g_sage",
      "tf_rt1523g_green",
      "tf_rt1523g_fabric",
      "tf_rt1523g_big",
      "tf_rt1523g_black",
      "tf_rt1523g_big_bwmod",
      "tf_mr3000_bwmod",
      "tf_rt1523g_bwmod",
      "tf_mr3000_bwmod_tropen",
      "tf_rt1523g_big_bwmod_tropen",
      "tf_rt1523g_big_rhs",
      "tf_rt1523g_rhs",
      "tf_mr3000_rhs",
      "tf_microdagr",
	  "tf_bussole"
    };
    weapons[] = {
      "tf_anprc152",
      "tf_anprc148jem",
      "tf_fadak",
      "tf_anprc154",
      "tf_rf7800str",
      "tf_pnr1000a"
    };
    requiredVersion = 1.0;
    requiredAddons[] = {"A3_Modules_F", "A3_UI_F", "A3_Structures_F_Items_Electronics", "A3_Weapons_F_ItemHolders"};
    author = "[TF]Nkey";
    Url = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
    version = 0.9.12;
    versionStr = "0.9.12";
    versionAr[] = {0,9,12};
  };
};

class CfgFactionClasses
{
  class TFAR
  {
    displayName = "TFAR";
    priority = 10;
    side = 7;
  };
  class BLU_G_F
  {
    backpack_tf_faction_radio = "tf_rt1523g_sage";
  };
  // support for BW
  class BWA3_Faction
  {
    backpack_tf_faction_radio = "tf_mr3000_bwmod";
  };
};

class CfgFontFamilies
{
  class tf_font_dots
  {
    fonts[] = {
      "\task_force_radio_items\fonts\dots\dots6",
      "\task_force_radio_items\fonts\dots\dots7",
      "\task_force_radio_items\fonts\dots\dots8",
      "\task_force_radio_items\fonts\dots\dots9",
      "\task_force_radio_items\fonts\dots\dots10",
      "\task_force_radio_items\fonts\dots\dots11",
      "\task_force_radio_items\fonts\dots\dots12",
      "\task_force_radio_items\fonts\dots\dots13",
      "\task_force_radio_items\fonts\dots\dots14",
      "\task_force_radio_items\fonts\dots\dots15",
      "\task_force_radio_items\fonts\dots\dots16",
      "\task_force_radio_items\fonts\dots\dots17",
      "\task_force_radio_items\fonts\dots\dots18",
      "\task_force_radio_items\fonts\dots\dots19",
      "\task_force_radio_items\fonts\dots\dots20",
      "\task_force_radio_items\fonts\dots\dots21",
      "\task_force_radio_items\fonts\dots\dots22",
      "\task_force_radio_items\fonts\dots\dots23",
      "\task_force_radio_items\fonts\dots\dots24",
      "\task_force_radio_items\fonts\dots\dots25",
      "\task_force_radio_items\fonts\dots\dots26",
      "\task_force_radio_items\fonts\dots\dots27",
      "\task_force_radio_items\fonts\dots\dots28",
      "\task_force_radio_items\fonts\dots\dots29",
      "\task_force_radio_items\fonts\dots\dots30",
      "\task_force_radio_items\fonts\dots\dots31",
      "\task_force_radio_items\fonts\dots\dots32",
      "\task_force_radio_items\fonts\dots\dots33",
      "\task_force_radio_items\fonts\dots\dots34",
      "\task_force_radio_items\fonts\dots\dots35",
      "\task_force_radio_items\fonts\dots\dots36"
    };

    spaceWidth = 0.6;
    spacing = 0.15;
  };
  class tf_font_segments
  {
    fonts[] = {
      "\task_force_radio_items\fonts\segments\segments6",
      "\task_force_radio_items\fonts\segments\segments7",
      "\task_force_radio_items\fonts\segments\segments8",
      "\task_force_radio_items\fonts\segments\segments9",
      "\task_force_radio_items\fonts\segments\segments10",
      "\task_force_radio_items\fonts\segments\segments11",
      "\task_force_radio_items\fonts\segments\segments12",
      "\task_force_radio_items\fonts\segments\segments13",
      "\task_force_radio_items\fonts\segments\segments14",
      "\task_force_radio_items\fonts\segments\segments15",
      "\task_force_radio_items\fonts\segments\segments16",
      "\task_force_radio_items\fonts\segments\segments17",
      "\task_force_radio_items\fonts\segments\segments18",
      "\task_force_radio_items\fonts\segments\segments19",
      "\task_force_radio_items\fonts\segments\segments20",
      "\task_force_radio_items\fonts\segments\segments21",
      "\task_force_radio_items\fonts\segments\segments22",
      "\task_force_radio_items\fonts\segments\segments23",
      "\task_force_radio_items\fonts\segments\segments24",
      "\task_force_radio_items\fonts\segments\segments25",
      "\task_force_radio_items\fonts\segments\segments26",
      "\task_force_radio_items\fonts\segments\segments27",
      "\task_force_radio_items\fonts\segments\segments28",
      "\task_force_radio_items\fonts\segments\segments29",
      "\task_force_radio_items\fonts\segments\segments30",
      "\task_force_radio_items\fonts\segments\segments31",
      "\task_force_radio_items\fonts\segments\segments32",
      "\task_force_radio_items\fonts\segments\segments33",
      "\task_force_radio_items\fonts\segments\segments34",
      "\task_force_radio_items\fonts\segments\segments35",
      "\task_force_radio_items\fonts\segments\segments36"
    };

    spaceWidth = 0.8;
    spacing = 0.3;
  };
};

class CfgVehicles {
  class ReammoBox;
  class Item_Base_F;

  class Bag_Base: ReammoBox
  {
    tf_hasLRradio = 0;
    tf_encryptionCode = "";
    tf_range = 20000;
  };
  class TFAR_Bag_Base: Bag_Base
  {
    tf_dialogUpdate = "call TFAR_fnc_updateLRDialogToChannel;";
    tf_hasLRradio = 1;
    scope = 1;
    scopeCurator = 1;
  };

  class tf_rt1523g: TFAR_Bag_Base
  {
    author = "Raspu, Gandi, Nkey";
    displayName = "RT-1523G (ASIP)";
    descriptionShort = "RT-1523G (ASIP) long range radio 20km";
    picture = "\task_force_radio_items\rt1523g\rt1523g_icon.paa";
    model="\task_force_radio_items\models\clf_prc117g_ap";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_prc117g_ap_co.paa"};
    maximumLoad = 50;
    mass = 80;
    scope = 2;
    scopeCurator = 2;
    tf_encryptionCode = "tf_west_radio_code";
    tf_dialog = "rt1523g_radio_dialog";
    tf_subtype = "digital_lr";
  };
  class tf_rt1523g_bwmod: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) BWMOD";
    descriptionShort = "RT-1523G (ASIP) BWMOD long range radio 20km";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_prc117g_bwmod_co.paa"};
  };
  class tf_rt1523g_rhs: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) RHS";
    descriptionShort = "RT-1523G (ASIP) RHS long range radio 20km";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_prc117g_rhs_co.paa.paa"};
  };
  class tf_rt1523g_big: tf_rt1523g
  {
    author = "Raspu, Gandi, Nkey";
    displayName = "RT-1523G (ASIP) Big";
    descriptionShort = "RT-1523G (ASIP) Big long range radio 20km";
    maximumLoad = 160;
    mass = 160;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_nato_multi_co.paa"};
    model="\task_force_radio_items\models\clf_nicecomm2";
  };
  class tf_rt1523g_big_bwmod: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) Big BWMOD [Flecktarn]";
    descriptionShort = "RT-1523G (ASIP) Big BWMOD long range radio 20km";
    maximumLoad = 160;
    mass = 160;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_bwmod_co.paa"};
    model="\task_force_radio_items\models\clf_nicecomm2";
  };
  class tf_rt1523g_big_bwmod_tropen: tf_rt1523g_big_bwmod {
	displayName = "RT-1523G (ASIP) Big BWMOD [Tropentarn]";
	hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\jgbtl14_marcbook_bwmod_tropen_co.paa"};
  };
  class tf_rt1523g_big_rhs: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) Big RHS";
    descriptionShort = "RT-1523G (ASIP) Big RHS long range radio 20km";
    maximumLoad = 160;
    mass = 160;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_rhs_co.paa"};
    model="\task_force_radio_items\models\clf_nicecomm2";
  };
  class tf_rt1523g_sage: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) Sage";
    descriptionShort = "RT-1523G (ASIP) Sage long range radio 20km";
    maximumLoad = 100;
    mass = 120;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_sage_co.paa"};
    model = "\task_force_radio_items\models\TFR_BACKPACK";
  };
  class tf_rt1523g_green: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) Green";
    descriptionShort = "RT-1523G (ASIP) Green long range radio 20km";
    maximumLoad = 100;
    mass = 120;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_green_co.paa"};
    model = "\task_force_radio_items\models\TFR_BACKPACK";
  };
  class tf_rt1523g_fabric: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) Fabric";
    descriptionShort = "RT-1523G (ASIP) Fabric long range radio 20km";
    maximumLoad = 100;
    mass = 120;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_fabric_co.paa"};
    model = "\task_force_radio_items\models\TFR_BACKPACK";
  };
  class tf_rt1523g_black: tf_rt1523g
  {
    displayName = "RT-1523G (ASIP) Black";
    descriptionShort = "RT-1523G (ASIP) Black long range radio 20km";
    maximumLoad = 100;
    mass = 120;
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_black_co.paa"};
    model = "\task_force_radio_items\models\TFR_BACKPACK";
  };

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

  class tf_mr3000: TFAR_Bag_Base
  {
    author = "Raspu, Gandi, Nkey";
    displayName = "MR3000";
    descriptionShort = "MR3000 long range radio 20km";
    picture = "\task_force_radio_items\mr3000\mr3000_icon.paa";
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 160;
    mass = 160;
    model = "\task_force_radio_items\models\clf_nicecomm2_prc117g";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_csat_multi_co.paa"};
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "mr3000_radio_dialog";
    tf_subtype = "digital_lr";
  };
  class tf_mr3000_multicam: tf_mr3000
  {
    author = "Raspu, Gandi, Nkey";
    displayName = "MR3000 Multicam";
    descriptionShort = "MR3000 Multicam long range radio 20km";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_co.paa"};
  };
  class tf_mr3000_bwmod: tf_mr3000
  {
    displayName = "MR3000 BWMOD [Flecktarn]";
    descriptionShort = "MR3000 BWMOD long range radio 20km";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_bwmod_co.paa"};
  };
  class tf_mr3000_bwmod_tropen: tf_mr3000_bwmod {
	displayName = "MR3000 BWMOD [Tropentarn]";
	hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\jgbtl14_marcbook_bwmod_tropen_co.paa"};
  };
  class tf_mr3000_rhs: tf_mr3000
  {
    displayName = "MR3000 RHS";
    descriptionShort = "MR3000 RHS long range radio 20km";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\clf_nicecomm2_rhs_digital_co.paa"};
  };

  class tf_bussole: TFAR_Bag_Base
  {
    author = "Raspu";
    displayName = "Assault Pack Bussole";
    descriptionShort = "Bussole long range radio 20km";
    picture = "\task_force_radio_items\bussole\bussole_icon.paa";
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 30;
    mass = 120;
    model="\task_force_radio_items\models\tf_bussole";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {""};
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "bussole_radio_dialog";
    tf_subtype = "digital_lr";
  };
  
  class tf_anarc210: TFAR_Bag_Base
  {
    displayName = "AN/ARC-210";
    descriptionShort = "AN/ARC-210 airborne radio 40km";
    picture = "\task_force_radio_items\anarc210\anarc210_icon.paa";
    model = "\task_force_radio_items\models\TFR_BACKPACK";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_mcam_co.paa"};
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_west_radio_code";
    tf_dialog = "anarc210_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""CH%1""] call TFAR_fnc_updateLRDialogToChannel;";
  };

  class tf_anarc164: TFAR_Bag_Base
  {
    displayName = "AN/ARC-164";
    descriptionShort = "AN/ARC-164 airborne radio 40km";
    picture = "\task_force_radio_items\anarc164\anarc164_icon.paa";
    model = "\task_force_radio_items\models\TFR_BACKPACK";
    hiddenSelections[] = {"camo"};
    hiddenSelectionsTextures[] = {"\task_force_radio_items\models\data\camo\backpack_dpcu_co.paa"};
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_guer_radio_code";
    tf_dialog = "anarc164_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""%1""] call TFAR_fnc_updateLRDialogToChannel;";
  };

  class tf_mr6000l: TFAR_Bag_Base
  {
    displayName = "MR6000L";
    descriptionShort = "MR6000L airborne radio 40km";
    model = "\task_force_radio_items\models\TFR_BACKPACK";
    picture = "\task_force_radio_items\mr6000l\mr6000l_icon.paa";
    scope = 2;
    scopeCurator = 2;
    maximumLoad = 20;
    mass = 160;
    tf_range = 40000;
    tf_encryptionCode = "tf_east_radio_code";
    tf_dialog = "mr6000l_radio_dialog";
    tf_subtype = "airborne";
    tf_dialogUpdate = "[""PRE %1""] call TFAR_fnc_updateLRDialogToChannel;";
  };

  #include "vehicles.hpp"
  #include "crates.hpp"
  #include "modules.hpp"

  class Item_tf_anprc152: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName = "AN/PRC-152";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_anprc152
      {
        name="tf_anprc152";
        count=1;
      };
    };
  };

  class Item_tf_anprc148jem: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName = "AN/PRC-148 JEM";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_anprc148jem
      {
        name="tf_anprc148jem";
        count=1;
      };
    };
  };

  class Item_tf_fadak: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName = "FADAK";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_fadak
      {
        name="tf_fadak";
        count=1;
      };
    };
  };

  class Item_tf_anprc154: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName =  "AN/PRC-154";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_anprc154
      {
        name="tf_anprc154";
        count=1;
      };
    };
  };

  class Item_tf_rf7800str: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName =  "RF-7800S-TR";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_rf7800str
      {
        name="tf_rf7800str";
        count=1;
      };
    };
  };

  class Item_tf_pnr1000a: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName =  "PNR-1000A";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_pnr1000a
      {
        name="tf_pnr1000a";
        count=1;
      };
    };
  };

  class Item_tf_microdagr: Item_Base_F
  {
    scope = 2;
    scopeCurator = 2;
    displayName =  "MicroDAGR Radio Programmer";
    author = "Nkey";
    vehicleClass = "Items";
    class TransportItems
    {
      class tf_microdagr
      {
        name="tf_microdagr";
        count=1;
      };
    };
  };
};

#include "radio_ids.hpp"

class CfgWeapons
{
  class ItemRadio;
  class ItemWatch;

  class tf_microdagr: ItemWatch
  {
    author = "Raspu, Nkey";
    displayName = "MicroDAGR Radio Programmer";
    descriptionShort = "Provides ability to program rifleman radios in the field";
    picture = "\task_force_radio_items\microdagr\microdagr_icon.paa";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_microdagr";
  };

  class tf_anprc152: ItemRadio
  {
    author = "Raspu";
    displayName = "AN/PRC-152";
    descriptionShort = "AN/PRC-152 personal radio 5km";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_anprc152";
    picture = "\task_force_radio_items\anprc152\152_icon.paa";
    tf_prototype = 1;
    tf_range = 5000;
    tf_dialog = "anprc152_radio_dialog";
    tf_encryptionCode = "tf_west_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "tf_anprc152";
    tf_additional_channel = 1;
  };

  class tf_anprc148jem: ItemRadio
  {
    author = "Raspu";
    displayName = "AN/PRC-148 JEM";
    descriptionShort = "AN/PRC-148 JEM personal radio 5km";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_anprc148";
    picture = "\task_force_radio_items\anprc148jem\148_icon.paa";
    tf_prototype = 1;
    tf_range = 5000;
    tf_dialog = "anprc148jem_radio_dialog";
    tf_encryptionCode = "tf_guer_radio_code";
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
    tf_subtype = "digital";
    tf_parent = "tf_anprc148jem";
    tf_additional_channel = 1;
  };

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

  class tf_pnr1000a: ItemRadio
  {
    displayName = "PNR-1000A";
    descriptionShort = "PNR-1000A rifleman radio 2km";
    scope = 2;
    scopeCurator = 2;
    model = "\task_force_radio_items\models\tfr_pnr1000a";
    picture = "\task_force_radio_items\pnr1000a\pnr1000a_icon.paa";
    tf_prototype = 1;
    tf_range = 2000;
    tf_dialog = "pnr1000a_radio_dialog";
    tf_encryptionCode = "tf_east_radio_code";
    tf_subtype = "digital";
    tf_parent = "tf_pnr1000a";
    tf_additional_channel = 0;
    tf_dialogUpdate = "call TFAR_fnc_updateSWDialogToChannel;";
  };

  TF_RADIO_IDS(tf_anprc152,AN/PRC-152)
    TF_RADIO_IDS(tf_anprc148jem,AN/PRC-148 JEM)
    TF_RADIO_IDS(tf_fadak,FADAK)
    TF_RADIO_IDS(tf_anprc154,AN/PRC-154)
    TF_RADIO_IDS(tf_rf7800str,RF-7800S-TR)
    TF_RADIO_IDS(tf_pnr1000a,PNR-1000A)
};
