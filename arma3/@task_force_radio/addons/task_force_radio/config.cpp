class CfgPatches
{
	class task_force_radio
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 1.0;
		requiredAddons[] = { "CBA_Main", "task_force_radio_items"};
		author[] = {"[TF]Nkey"};
		authorUrl = "https://github.com/michail-nikolaev/task-force-arma-3-radio";
		version = 0.9.8;
		versionStr = "0.9.8";
		versionAr[] = {0,9,8};
	};
};

#include "\task_force_radio\CfgFunctions.h"
class task_force_radio_settings {

// =================================================
// Server side only
// =================================================
tf_no_auto_long_range_radio = 0;
TF_give_personal_radio_to_regular_soldier = 0;
TF_give_microdagr_to_soldier = 1;
tf_same_sw_frequencies_for_side = 0;
tf_same_lr_frequencies_for_side = 0;
tf_same_dd_frequencies_for_side = 0;
// =================================================
// END: Server side only
// =================================================
// Client side
// =================================================
tf_default_radioVolume = 7;
// =================================================
// END: Client side
// =================================================

};
#include "\task_force_radio\description.h"
#include "\task_force_radio\RscTitles.hpp"

class CfgSounds
{
	class TFAR_rotatorPush
	{
		name = "TFAR - Rotator Switch (Push)";
		sound[] = {"\task_force_radio\sounds\hardPush.wss",0.5,1};
		titles[] = {};
	};
	class TFAR_rotatorClick
	{
		name = "TFAR - Rotator Switch (Click)";
		sound[] = {"\A3\ui_f\data\sound\RscButton\soundEscape.wss",0.5,1};
		titles[] = {};
	};
};