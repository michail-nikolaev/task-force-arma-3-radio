#include "script_component.hpp"

/*
    Name: TFAR_fnc_sendPluginConfig

    Author(s):
        Dedmen

    Description:
        Transmitts all Plugin settings to Plugin

    Parameters:

    Returns:
        Nothing

    Example:
        call TFAR_fnc_sendPluginConfig;
*/

["full_duplex",missionNamespace getVariable ["TFAR_fullDuplex",true]] call TFAR_fnc_setPluginSetting;
["addon_version",TFAR_ADDON_VERSION] call TFAR_fnc_setPluginSetting;
["serious_channelName",missionNamespace getVariable ["tf_radio_channel_name",""]] call TFAR_fnc_setPluginSetting;//#TODO wiki entry
["serious_channelPassword",missionNamespace getVariable ["tf_radio_channel_password",""]] call TFAR_fnc_setPluginSetting;
["intercomVolume",missionNamespace getVariable ["TFAR_intercomVolume",0.3]] call TFAR_fnc_setPluginSetting;
["intercomEnabled",missionNamespace getVariable ["TFAR_enableIntercom",true]] call TFAR_fnc_setPluginSetting;
["pluginTimeout",missionNamespace getVariable ["TFAR_pluginTimeout",4]] call TFAR_fnc_setPluginSetting;
//If you add things that player could change in Mission call this PFH or tell players in WIKI
