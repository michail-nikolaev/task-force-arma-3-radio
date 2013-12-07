TF_ADDON_VERSION = "0.8.2";

nul = [] execVM "common.sqf";


if ((isServer) or (isDedicated)) then
{
	nul = [] execVM "server.sqf";

};
if (!(isDedicated)) then
{
	nul = [] execVM "client.sqf";
};
