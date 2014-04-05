class All;
class AllVehicles:All
{
	tf_hasLRradio = 0;
	tf_isolatedAmount = 0;
};
class LandVehicle;
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
class Wheeled_Apc:Car
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.6;
};
class Car_F;
class MRAP_01_base_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.51;
};
class MRAP_02_base_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.51;
};
class MRAP_03_base_F: Car_F
{
	tf_hasLRradio = 1;
	tf_isolatedAmount = 0.51;
};
class Truck_F;
class Truck_01_base_F:Truck_F
{
	tf_hasLRradio = 1;
};
class Truck_02_base_F:Truck_F
{
	tf_hasLRradio = 1;
};
class Offroad_01_base_f;
class Offroad_01_armed_base_F:Offroad_01_base_f
{
	tf_hasLRradio = 1;
};
class Boat_F;
class SDV_01_base_F: Boat_F
{
	tf_hasLRradio = 1;
};
class Boat_Armed_01_base_F:Boat_F
{
	tf_hasLRradio = 1;
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

// 3d-party
class rc_hmmwv_base: Car_F
{
	tf_hasLRradio = 1;
};