TF_FREQ_OFFSET = 2;
TF_FREQ_ROUND_POWER = 10;

TF_MAX_CHANNELS = 8;
TF_MIN_SW_FREQ = 30;
TF_MAX_SW_FREQ = 512;

TF_MAX_LR_CHANNELS = 9;

TF_MIN_ASIP_FREQ = 30;
TF_MAX_ASIP_FREQ = 87;

TF_SW_STEREO_OFFSET = TF_FREQ_OFFSET + 1;
TF_LR_STEREO_OFFSET = TF_FREQ_OFFSET + 1;
TF_MAX_STEREO = 3;

TF_CODE_OFFSET = TF_SW_STEREO_OFFSET + 1;
TF_ADDITIONAL_CHANNEL_OFFSET = TF_CODE_OFFSET + 1;
TF_ADDITIONAL_STEREO_OFFSET = TF_ADDITIONAL_CHANNEL_OFFSET + 1;

tf_getTeamSpeakServerName = {
	diag_log "WARNING: depreciated function call: tf_getTeamSpeakServerName replace with TFAR_fnc_getTeamSpeakServerName";
	call TFAR_fnc_getTeamSpeakServerName
};

tf_getTeamSpeakChannelName = {
	diag_log "WARNING: depreciated function call: tf_getTeamSpeakChannelName replace with TFAR_fnc_getTeamSpeakChannelName";
	call TFAR_fnc_getTeamSpeakChannelName
};

tf_isTeamSpeakPluginEnabled = {
	diag_log "WARNING: depreciated function call: tf_isTeamSpeakPluginEnabled replace with TFAR_fnc_isTeamSpeakPluginEnabled";
	call TFAR_fnc_isTeamSpeakPluginEnabled
};

tf_setLongRangeRadioFrequency = {
	diag_log "WARNING: depreciated function call: tf_setLongRangeRadioFrequency replace with TFAR_fnc_gsetLongRangeRadioFrequency";
	call TFAR_fnc_gsetLongRangeRadioFrequency
};

tf_setPersonalRadioFrequency = {
	diag_log "WARNING: depreciated function call: tf_setPersonalRadioFrequency replace with TFAR_fnc_setPersonalRadioFrequency";
	call TFAR_fnc_setPersonalRadioFrequency
};

generateLrSettings = {
	diag_log "WARNING: depreciated function call: generateLrSettings replace with TFAR_fnc_generateLrSettings";
	call TFAR_fnc_generateLrSettings
};

generateSwSetting = {
	diag_log "WARNING: depreciated function call: generateSwSetting replace with TFAR_fnc_generateSwSettings";
	call TFAR_fnc_generateSwSettings
};