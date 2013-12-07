TF_ADDON_VERSION = "0.8.2";

nul = [] execVM "\task_force_radio\common.sqf";

if ((isServer) or (isDedicated)) then
{
	nul = [] execVM "\task_force_radio\server.sqf";

};
if (!(isDedicated)) then
{
	nul = [] execVM "\task_force_radio\client.sqf";
};
