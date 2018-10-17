#include "script_component.hpp"

/*
  Name: TFAR_fnc_sendPluginConfig

  Author: Dedmen
    transmitts all pluginsettings to plugin

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_sendPluginConfig;

  Public: Yes
*/

["full_duplex",missionNamespace getVariable ["TFAR_fullDuplex",true]] call TFAR_fnc_setPluginSetting;
["addon_version",TFAR_ADDON_VERSION] call TFAR_fnc_setPluginSetting;
["serious_channelPassword",missionNamespace getVariable ["TFAR_Teamspeak_Channel_Password","123"]] call TFAR_fnc_setPluginSetting;
["serious_channelName",missionNamespace getVariable ["TFAR_Teamspeak_Channel_Name","TaskForceRadio"]] call TFAR_fnc_setPluginSetting;//#TODO wiki entry
["intercomVolume",missionNamespace getVariable ["TFAR_intercomVolume",0.3]] call TFAR_fnc_setPluginSetting;
["intercomDucking",missionNamespace getVariable ["TFAR_intercomDucking",0.2]] call TFAR_fnc_setPluginSetting;
["intercomEnabled",missionNamespace getVariable ["TFAR_enableIntercom",true]] call TFAR_fnc_setPluginSetting;
["pluginTimeout",missionNamespace getVariable ["TFAR_pluginTimeout",4]] call TFAR_fnc_setPluginSetting;
["spectatorNotHearEnemies",!(missionNamespace getVariable ["TFAR_spectatorCanHearEnemyUnits",false])] call TFAR_fnc_setPluginSetting;
["spectatorCanHearFriendlies",missionNamespace getVariable ["TFAR_spectatorCanHearFriendlies",true]] call TFAR_fnc_setPluginSetting;
["tangentReleaseDelay",missionNamespace getVariable ["TFAR_tangentReleaseDelay",0]] call TFAR_fnc_setPluginSetting;
["headsetLowered",missionNamespace getVariable [QGVAR(isHeadsetLowered),false]] call TFAR_fnc_setPluginSetting;
["moveWhileTabbedOut", missionNamespace getVariable ["TFAR_moveWhileTabbedOut", false]] call TFAR_fnc_setPluginSetting;
["minimumPluginVersion", 299] call TFAR_fnc_setPluginSetting;

//If you add things that player could change in Mission call this PFH or tell players in WIKI
