class CfgPatches {

	class TFR_Backpack {
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.100000;
		requiredAddons[] = {"task_force_radio_items"};
	};
};

class CfgVehicles {

	/*extern*/ class ReammoBox;
	
	class TFR_Bag_Base: ReammoBox 
	{
		scope = 1;

		class TransportMagazines {
		};

		class TransportWeapons {
		};
		
		isbackpack = 1;
		reversed = 1;
		mapSize = 2;
		vehicleClass = "Backpacks";
		allowedSlots[] = {901};
		model = "\A3\weapons_f\Ammoboxes\bags\Backpack_Small";
		displayName = "$STR_A3_Bag_Base0";
		picture = "\A3\Weapons_F\Ammoboxes\Bags\data\ui\backpack_CA.paa";
		icon = "iconBackpack";
		transportMaxWeapons = 0;
		transportMaxMagazines = 30;

		class DestructionEffects {
		};
		maximumLoad = 110;
		side = 3;
	};
	
	class TFR_BACKPACK_COYOTE: TFR_Bag_Base {
		scope = 2;
		model = "\TFR_Backpack\TFR_BACKPACK";
		displayName = "TFR MANPACK RADIO (Coyote)";
	};
	
	class TFR_BACKPACK_BLACK: TFR_Bag_Base {
		scope = 2;
		model = "\TFR_Backpack\TFR_BACKPACK";
		displayName = "TFR MANPACK RADIO (Black)";
		
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\TFR_Backpack\data\camo\backpack_black_co.paa"};
	};
	
	class TFR_BACKPACK_DPCU: TFR_Bag_Base {
		scope = 2;
		model = "\TFR_Backpack\TFR_BACKPACK";
		displayName = "TFR MANPACK RADIO (DPCU)";
		
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\TFR_Backpack\data\camo\backpack_dpcu_co.paa"};
	};
	
	class TFR_BACKPACK_GREEN: TFR_Bag_Base {
		scope = 2;
		model = "\TFR_Backpack\TFR_BACKPACK";
		displayName = "TFR MANPACK RADIO (Green)";
		
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\TFR_Backpack\data\camo\backpack_green_co.paa"};
	};
	
	class TFR_BACKPACK_MCAM: TFR_Bag_Base {
		scope = 2;
		model = "\TFR_Backpack\TFR_BACKPACK";
		displayName = "TFR MANPACK RADIO (MTP)";
		
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\TFR_Backpack\data\camo\backpack_mcam_co.paa"};
	};
	
	class TFR_BACKPACK_SAGE: TFR_Bag_Base {
		scope = 2;
		model = "\TFR_Backpack\TFR_BACKPACK";
		displayName = "TFR MANPACK RADIO (Sage)";
		
		hiddenSelections[] = {"camo"};
		hiddenSelectionsTextures[] = {"\TFR_Backpack\data\camo\backpack_sage_co.paa"};
	};
	
	class tf_rt1523g: TFR_BACKPACK_SAGE {};
	class tf_anprc155: TFR_BACKPACK_GREEN {};
	class tf_mr3000: TFR_BACKPACK_BLACK {};
	
};