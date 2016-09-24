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

  

  
  
  

  

  

  #include "vehicles.hpp"
  #include "crates.hpp"
  #include "modules.hpp"

  

  

 

  

  

};

#include "radio_ids.hpp"

class CfgWeapons
{
  class ItemRadio;
  
    
    
};
