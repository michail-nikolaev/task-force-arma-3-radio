if ((isServer) or (isDedicated)) then
{
	nul = [] execVM "server.sqf";

};
if (!(isDedicated)) then
{
	nul = [] execVM "client.sqf";
//	execVM "mission.sqf";
};
