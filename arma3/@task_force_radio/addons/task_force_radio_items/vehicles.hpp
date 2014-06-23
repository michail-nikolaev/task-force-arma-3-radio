class All;
class AllVehicles:All
{
	tf_hasLRradio = 0;
	tf_isolatedAmount = 0;
};
class Land;
class LandVehicle: Land
{
	tf_range = 30000;
};
class Tank:LandVehicle
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 1;
};
class Air:AllVehicles
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.1;
};
class Helicopter;
class ParachuteBase:Helicopter
{
	tf_hasLRradio = 0;
	tf_isolatedAmount = 0;
};
class Helicopter_Base_F;
class Helicopter_Base_H;
class Heli_Light_02_base_F:Helicopter_Base_H
{
	tf_isolatedAmount = 0.7;
};
class Heli_Attack_02_base_F:Helicopter_Base_F
{
	tf_isolatedAmount = 0.7;
};
class Heli_Attack_01_base_F:Helicopter_Base_F
{
	tf_isolatedAmount = 0.7;
};
class Heli_Transport_01_base_F:Helicopter_Base_H
{
	tf_isolatedAmount = 0.3;
};
class Heli_Transport_02_base_F:Helicopter_Base_H
{
	tf_isolatedAmount = 0.8;
};
class Car:LandVehicle
{
	tf_isolatedAmount = 0.1;
};
class Car_F;
class Wheeled_Apc_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.6;
};
class MRAP_01_base_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.7;
};
class MRAP_02_base_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.7;
};
class MRAP_03_base_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.7;
};
class Truck_F;
class Truck_01_base_F:Truck_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.4;
};
class Truck_02_base_F:Truck_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.4;
};
class Truck_03_base_F: Truck_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.4;
};
class Offroad_01_base_f;
class Offroad_01_armed_base_F:Offroad_01_base_f
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.25;
};
class Boat_F;
class SDV_01_base_F: Boat_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.1;
};
class Boat_Armed_01_base_F:Boat_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.1;
};
class Boat_Civil_01_base_F;
class C_Boat_Civil_01_police_F:Boat_Civil_01_base_F
{
	tf_hasLRradio = 1;
};
class C_Boat_Civil_01_rescue_F:Boat_Civil_01_base_F
{
	tf_hasLRradio = 1;
};

// ---------------------------------------------------------
// Default 3d-party Mod Support
// ---------------------------------------------------------
class rc_hmmwv_base: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.3;
};

class Plane;
// C-130J Port Release - http://forums.bistudio.com/showthread.php?173431-C-130J-Port-Release
class C130J_Base: Plane
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.8;
};

// HAFM - ArmA 2 HMMWVs import - http://forums.bistudio.com/showthread.php?172647-HAFM-ArmA-2-HMMWVs-import
class HMMWV_Base: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.3;
};
// HAFM - ArmA 2 UK Wheeled - http://forums.bistudio.com/showthread.php?176138-HAFM-ArmA-2-UK-Wheeled-Import
class BAF_Offroad_D: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.1;
};
class BAF_Jackal2_BASE_D: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0;
};
// HAFM UAZ Cars - http://forums.bistudio.com/showthread.php?175914-HAFM-UAZ-Cars
class UAZ_Base:Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0;	
};
class UAZ_Unarmed:UAZ_Base
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.15;	
};
// HAFM -  ArmA 2 US Helicopters Import to A3 - http://forums.bistudio.com/showthread.php?173822-ArmA-2-US-Helicopters-Import-to-A3
class CH_47F_base: Helicopter
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.4;
};
class AH64_Base: Helicopter
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.85;
};
class AH1_Base: Helicopter
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.85;
};