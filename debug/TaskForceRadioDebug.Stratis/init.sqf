ADDON_VERSION = "0.8.0";

if ((isServer) or (isDedicated)) then
{
	nul = [] execVM "server.sqf";

};
if (!(isDedicated)) then
{
	nul = [] execVM "client.sqf";
};
