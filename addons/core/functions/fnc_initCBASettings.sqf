// client Settings
[
    "TFAR_default_radioVolume",
    "SLIDER",
    ELSTRING(settings,default_radioVolume),
    "Task Force Arrowhead Radio",
    [1, 9, 7, 0],
    0
] call CBA_Settings_fnc_init;
[
    "TFAR_volumeModifier_forceSpeech", 
    "CHECKBOX", 
    [ELSTRING(settings,directSpeechModifier), ELSTRING(settings,directSpeechModifier_desc)], 
    "Task Force Arrowhead Radio", 
    false,
    0
] call CBA_Settings_fnc_init;
[
    "TFAR_intercomVolume", 
    "SLIDER",
    ELSTRING(settings,intercomVolume),
    "Task Force Arrowhead Radio", 
    [0.01, 0.6, 0.3, 3],
    0,
    {["intercomVolume", TFAR_intercomVolume] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_pluginTimeout", 
    "SLIDER", 
    ELSTRING(settings,pluginTimeout), 
    "Task Force Arrowhead Radio", 
    [0.5, 10, 4, 3],
    0,
    {["pluginTimeout",TFAR_pluginTimeout] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_tangentReleaseDelay",
    "SLIDER", 
    ELSTRING(settings,tangentReleaseDelay), 
    "Task Force Arrowhead Radio", 
    [0, 500, 0, 0],
    0,
    {["tangentReleaseDelay",TFAR_tangentReleaseDelay] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_PosUpdateMode", 
    "LIST", 
    [ELSTRING(settings,positionUpdateMode), ELSTRING(settings,positionUpdateMode_desc)], 
    "Task Force Arrowhead Radio", 
    [[0, 0.1, 0.2], ["Quality", "Normal", "Performance"], 1],
    0
] call CBA_Settings_fnc_init;
[
    "TFAR_ShowVolumeHUD",
    "CHECKBOX",
    [ELSTRING(settings,hudVolumeIndicator), ELSTRING(settings,hudVolumeIndicator_desc)],
    "Task Force Arrowhead Radio",
    false,
    0,
    {
        if (TFAR_ShowVolumeHUD) then {
            (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutRsc [QGVAR(HUDVolumeIndicatorRsc), "PLAIN", 0, true];
        } else {
            (QGVAR(HUDVolumeIndicatorRsc) call BIS_fnc_rscLayer) cutText ["", "PLAIN"];
        };
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_VolumeHudTransparency", 
    "SLIDER", 
    [ELSTRING(settings,volumeIndicatorTransparency), ELSTRING(settings,volumeIndicatorTransparency_desc)], 
    "Task Force Arrowhead Radio", 
    [0, 1, 0, 3],
    0,
    {call TFAR_fnc_updateSpeakVolumeUI;}
] call CBA_Settings_fnc_init;
[
    "TFAR_oldVolumeHint", 
    "CHECKBOX", 
    [ELSTRING(settings,useOldVolumeHint), ELSTRING(settings,useOldVolumeHint_desc)], 
    "Task Force Arrowhead Radio", 
    false,
    0
] call CBA_Settings_fnc_init;
[
    "TFAR_showTransmittingHint", 
    "CHECKBOX", 
    [ELSTRING(settings,showTransmittingHint), ELSTRING(settings,showTransmittingHint_desc)], 
    "Task Force Arrowhead Radio", 
    true,
    0
] call CBA_Settings_fnc_init;
[
    "TFAR_showChannelChangedHint", 
    "CHECKBOX", 
    [ELSTRING(settings,showChannelChangedHint), ELSTRING(settings,showChannelChangedHint_desc)], 
    "Task Force Arrowhead Radio", 
    true,
    0
] call CBA_Settings_fnc_init;

// server
[
    "TF_terrain_interception_coefficient", 
    "SLIDER", 
    [ELSTRING(settings,TerrainInterceptionCoefficient), ELSTRING(settings,TerrainInterceptionCoefficient_tooltip)], 
    "Task Force Arrowhead Radio", 
    [0, 20, 7, 1],
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_fullDuplex", 
    "CHECKBOX", 
    [ELSTRING(settings,FullDuplex), ELSTRING(settings,FullDuplexDescription)], 
    "Task Force Arrowhead Radio", 
    true,
    1,
    {["full_duplex", _this] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_enableIntercom", 
    "CHECKBOX",
    ELSTRING(settings,enable_vehicle_intercom),
    "Task Force Arrowhead Radio", 
    true,
    1,
    {["intercomEnabled", TFAR_enableIntercom] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_objectInterceptionEnabled", 
    "CHECKBOX",
    ELSTRING(settings,enable_object_interception), 
    "Task Force Arrowhead Radio", 
    true,
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_takingRadio",
    "LIST",
    [ELSTRING(settings,TAKERADIO_HEADER), ELSTRING(settings,TAKERADIO_DESC)],
    "Task Force Arrowhead Radio",
    [[0, 1, 2], [ELSTRING(settings,TAKERADIO_0), ELSTRING(settings,TAKERADIO_1), ELSTRING(settings,TAKERADIO_2)], 2],
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_spectatorCanHearEnemyUnits", 
    "CHECKBOX", 
    [ELSTRING(settings,spectator_hear_emy), ELSTRING(settings,spectator_hear_emy_desc)], 
    "Task Force Arrowhead Radio", 
    true,
    1,
    {["spectatorNotHearEnemies", !TFAR_spectatorCanHearEnemyUnits] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_spectatorCanHearFriendlies", 
    "CHECKBOX", 
    [ELSTRING(settings,spectator_hear), ELSTRING(settings,spectator_hear_desc)], 
    "Task Force Arrowhead Radio", 
    true,
    1,
    {["spectatorCanHearFriendlies", TFAR_spectatorCanHearFriendlies] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_Teamspeak_Channel_Name", 
    "EDITBOX", 
    [ELSTRING(settings,TeamspeakChannel_name), ELSTRING(settings,TeamspeakChannel_name_desc)], 
    "Task Force Arrowhead Radio", 
    "",
    1,
    {["serious_channelName",_this]] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_Teamspeak_Channel_Password", 
    "EDITBOX", 
    [ELSTRING(settings,TeamspeakChannel_password), ELSTRING(settings,TeamspeakChannel_password_desc)], 
    "Task Force Arrowhead Radio", 
    ["", true],
    1,
    {["serious_channelPassword",_this]] call TFAR_fnc_setPluginSetting;}
] call CBA_Settings_fnc_init;
[
    "TFAR_SameSRFrequenciesForSide", 
    "CHECKBOX",
    ELSTRING(settings,same_sw_frequencies_for_side), 
    "Task Force Arrowhead Radio", 
    false,
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_defaultFrequencies_sr_west", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioFrequencies_SR_west), ELSTRING(settings,DefaultRadioFrequencies_SR_west_desc)], 
    "Task Force Arrowhead Radio", 
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            TFAR_defaultFrequencies_sr_west = [_this, TFAR_MAX_CHANNELS, TFAR_MAX_SW_FREQ, TFAR_MIN_SW_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            publicVariable "TFAR_defaultFrequencies_sr_west";
            TRACE_2("TFAR_setting_defaultFrequencies_sr_west changed on Server",CBA_missiontime,_this);
        } else {
            if (isNil "TFAR_defaultFrequencies_sr_west") then {
                TRACE_2("TFAR_setting_defaultFrequencies_sr_west changed on Client, Server has not transfered yet",CBA_missiontime,_this);
                TFAR_defaultFrequencies_sr_west = [_this, TFAR_MAX_CHANNELS, TFAR_MAX_SW_FREQ, TFAR_MIN_SW_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            } else {
                TRACE_2("TFAR_setting_defaultFrequencies_sr_west changed on Client, Server already transfered",CBA_missiontime,_this);
            };
        };
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_defaultFrequencies_sr_east", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioFrequencies_SR_east), ELSTRING(settings,DefaultRadioFrequencies_SR_east_desc)], 
    "Task Force Arrowhead Radio", 
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            TFAR_defaultFrequencies_sr_east = [_this, TFAR_MAX_CHANNELS, TFAR_MAX_SW_FREQ, TFAR_MIN_SW_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            publicVariable "TFAR_defaultFrequencies_sr_east";
            TRACE_2("TFAR_setting_defaultFrequencies_sr_east changed on Server",CBA_missiontime,_this);
        } else {
            if (isNil "TFAR_defaultFrequencies_sr_east") then {
                TRACE_2("TFAR_setting_defaultFrequencies_sr_east changed on Client, Server has not transfered yet",CBA_missiontime,_this);
                TFAR_defaultFrequencies_sr_east = [_this, TFAR_MAX_CHANNELS, TFAR_MAX_SW_FREQ, TFAR_MIN_SW_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            } else {
                TRACE_2("TFAR_setting_defaultFrequencies_sr_east changed on Client, Server already transfered",CBA_missiontime,_this);
            };
        };
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_defaultFrequencies_sr_independent", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioFrequencies_SR_independent), ELSTRING(settings,DefaultRadioFrequencies_SR_independent_desc)],
    "Task Force Arrowhead Radio", 
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            TFAR_defaultFrequencies_sr_independent = [_this, TFAR_MAX_CHANNELS, TFAR_MAX_SW_FREQ, TFAR_MIN_SW_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            publicVariable "TFAR_defaultFrequencies_sr_independent";
            TRACE_2("TFAR_setting_defaultFrequencies_sr_independent changed on Server",CBA_missiontime,_this);
        } else {
            if (isNil "TFAR_defaultFrequencies_sr_independent") then {
                TRACE_2("TFAR_setting_defaultFrequencies_sr_independent changed on Client, Server has not transfered yet",CBA_missiontime,_this);
                TFAR_defaultFrequencies_sr_independent = [_this, TFAR_MAX_CHANNELS, TFAR_MAX_SW_FREQ, TFAR_MIN_SW_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            } else {
                TRACE_2("TFAR_setting_defaultFrequencies_sr_independent changed on Client, Server already transfered",CBA_missiontime,_this);
            };
        };
    }
] call CBA_Settings_fnc_init;

[
    "TFAR_SameLRFrequenciesForSide", 
    "CHECKBOX", 
    ELSTRING(settings,same_lr_frequencies_for_side), 
    "Task Force Arrowhead Radio", 
    false,
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_defaultFrequencies_lr_west", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioFrequencies_LR_west), ELSTRING(settings,DefaultRadioFrequencies_LR_west_desc)],
    "Task Force Arrowhead Radio",
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            TFAR_defaultFrequencies_lr_west = [_this, TFAR_MAX_LR_CHANNELS, TFAR_MAX_ASIP_FREQ, TFAR_MIN_ASIP_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            publicVariable "TFAR_defaultFrequencies_lr_west";
        };
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_defaultFrequencies_lr_east", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioFrequencies_LR_east), ELSTRING(settings,DefaultRadioFrequencies_LR_east_desc)],
    "Task Force Arrowhead Radio", 
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            TFAR_defaultFrequencies_lr_east = [_this, TFAR_MAX_LR_CHANNELS, TFAR_MAX_ASIP_FREQ, TFAR_MIN_ASIP_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            publicVariable "TFAR_defaultFrequencies_lr_east";
        };
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_defaultFrequencies_lr_independent", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioFrequencies_LR_independent), ELSTRING(settings,DefaultRadioFrequencies_LR_independent_desc)],
    "Task Force Arrowhead Radio",
    ["", false, DFUNC(settingForceArray)],
    1,
    {
        if (isServer) then {
            TFAR_defaultFrequencies_lr_independent = [_this, TFAR_MAX_LR_CHANNELS, TFAR_MAX_ASIP_FREQ, TFAR_MIN_ASIP_FREQ, TFAR_FREQ_ROUND_POWER] call DFUNC(parseFrequenciesInput);
            publicVariable "TFAR_defaultFrequencies_lr_independent";
        };
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_giveMicroDagrToSoldier", 
    "CHECKBOX", 
    ELSTRING(settings,give_microdagr_to_soldier), 
    "Task Force Arrowhead Radio", 
    true,
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_givePersonalRadioToRegularSoldier", 
    "CHECKBOX", 
    ELSTRING(settings,give_personal_radio_to_regular_soldier), 
    "Task Force Arrowhead Radio", 
    false,
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_giveLongRangeRadioToGroupLeaders", 
    "CHECKBOX", 
    [ELSTRING(settings,auto_long_range_radio), ELSTRING(settings,auto_long_range_radio_desc)], 
    "Task Force Arrowhead Radio", 
    false,
    1
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Rifleman_West", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioRifleman_west), ELSTRING(settings,DefaultRadioRifleman_west_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_rf7800str",
    1,
    {
        TFAR_DefaultRadio_Rifleman_West = if (_this call DFUNC(isPrototypeRadio)) then {_this} else {"TFAR_rf7800str"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Rifleman_East", 
    "EDITBOX",
    [ELSTRING(settings,DefaultRadioRifleman_east), ELSTRING(settings,DefaultRadioRifleman_east_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_pnr1000a",
    1,
    {
        TFAR_DefaultRadio_Rifleman_East = if (_this call DFUNC(isPrototypeRadio)) then {_this} else {"TFAR_pnr1000a"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Rifleman_Independent", 
    "EDITBOX",
    [ELSTRING(settings,DefaultRadioRifleman_independent), ELSTRING(settings,DefaultRadioRifleman_independent_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_anprc154",
    1,
    {
        TFAR_DefaultRadio_Rifleman_Independent = if (_this call DFUNC(isPrototypeRadio)) then {_this} else {"TFAR_anprc154"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Personal_West", 
    "EDITBOX",
    [ELSTRING(settings,DefaultRadioPersonal_west), ELSTRING(settings,DefaultRadioPersonal_west_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_rf7800str",
    1,
    {
        TFAR_DefaultRadio_Personal_West = if (_this call DFUNC(isPrototypeRadio)) then {_this} else {"TFAR_rf7800str"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Personal_east", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioPersonal_east), ELSTRING(settings,DefaultRadioPersonal_east_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_pnr1000a",
    1,
    {
        TFAR_DefaultRadio_Personal_East = if (_this call DFUNC(isPrototypeRadio)) then {_this} else {"TFAR_pnr1000a"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Personal_Independent", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioPersonal_independent), ELSTRING(settings,DefaultRadioPersonal_independent_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_anprc154",
    1,
    {
        TFAR_DefaultRadio_Personal_Independent = if (_this call DFUNC(isPrototypeRadio)) then {_this} else {"TFAR_anprc154"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Backpack_west", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioBackpack_west), ELSTRING(settings,DefaultRadioBackpack_west_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_rt1523g",
    1,
    {
        TFAR_DefaultRadio_Backpack_west = if (([_this, "tf_subtype"] call DFUNC(getVehicleConfigProperty)) == "digital_lr") then {_this} else {"TFAR_rt1523g"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Backpack_east", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioBackpack_east), ELSTRING(settings,DefaultRadioBackpack_east_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_mr3000",
    1,
    {
        TFAR_DefaultRadio_Backpack_East = if (([_this, "tf_subtype"] call DFUNC(getVehicleConfigProperty)) == "digital_lr") then {_this} else {"TFAR_mr3000"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Backpack_Independent", 
    "EDITBOX", 
    [ELSTRING(settings,DefaultRadioBackpack_independent), ELSTRING(settings,DefaultRadioBackpack_independent_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_anprc155",
    1,
    {
        TFAR_DefaultRadio_Backpack_Independent = if (([_this, "tf_subtype"] call DFUNC(getVehicleConfigProperty)) == "digital_lr") then {_this} else {"TFAR_anprc155"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Airborne_West", 
    "EDITBOX",
    [ELSTRING(settings,DefaultRadioAirborne_west), ELSTRING(settings,DefaultRadioAirborne_west_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_anarc210",
    1,
    {
        TFAR_DefaultRadio_Airborne_West = if (([_this, "tf_subtype"] call DFUNC(getVehicleConfigProperty)) == "airborne") then {_this} else {"TFAR_anarc210"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Airborne_east", 
    "EDITBOX",
    [ELSTRING(settings,DefaultRadioAirborne_east), ELSTRING(settings,DefaultRadioAirborne_independent_east)],
    "Task Force Arrowhead Radio", 
    "TFAR_mr6000l",
    1,
    {
        TFAR_DefaultRadio_Airborne_east = if (([_this, "tf_subtype"] call DFUNC(getVehicleConfigProperty)) == "airborne") then {_this} else {"TFAR_mr6000l"};
    }
] call CBA_Settings_fnc_init;
[
    "TFAR_setting_DefaultRadio_Airborne_Independent", 
    "EDITBOX",
    [ELSTRING(settings,DefaultRadioAirborne_independent), ELSTRING(settings,DefaultRadioAirborne_independent_desc)],
    "Task Force Arrowhead Radio", 
    "TFAR_anarc164",
    1,
    {
        TFAR_DefaultRadio_Airborne_Independent = if (([_this, "tf_subtype"] call DFUNC(getVehicleConfigProperty)) == "airborne") then {_this} else {"TFAR_anarc164"};
    }
] call CBA_Settings_fnc_init;
[
    QGVARMAIN(radioCodesDisabled), 
    "CHECKBOX",
    [ELSTRING(settings,radioCodesDisabled), ELSTRING(settings,radioCodesDisabled_desc)],
    "Task Force Arrowhead Radio", 
    false,
    1
] call CBA_Settings_fnc_init;
[
    "tf_west_radio_code", 
    "EDITBOX",
    [ELSTRING(settings,radioCode_west), ELSTRING(settings,radioCode_west_desc)],
    "Task Force Arrowhead Radio", 
    "_bluefor",
    1
] call CBA_Settings_fnc_init;
[
    "tf_east_radio_code", 
    "EDITBOX",
    [ELSTRING(settings,radioCode_east), ELSTRING(settings,radioCode_east_desc)],
    "Task Force Arrowhead Radio", 
    "_opfor",
    1
] call CBA_Settings_fnc_init;
[
    "tf_independent_radio_code", 
    "EDITBOX",
    [ELSTRING(settings,radioCode_independent), ELSTRING(settings,radioCode_independent_desc)],
    "Task Force Arrowhead Radio", 
    "_independent",
    1
] call CBA_Settings_fnc_init;
