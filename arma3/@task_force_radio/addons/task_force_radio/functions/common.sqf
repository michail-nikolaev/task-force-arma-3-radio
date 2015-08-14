TF_FREQ_OFFSET = 2;
TF_FREQ_ROUND_POWER = 10;

TF_MAX_CHANNELS = 8;
TF_MIN_SW_FREQ = 30;
TF_MAX_SW_FREQ = 512;

TF_MAX_LR_CHANNELS = 9;

TF_MIN_ASIP_FREQ = 30;
TF_MAX_ASIP_FREQ = 87;

<<<<<<< HEAD
TF_MIN_DD_FREQ = 32;
TF_MAX_DD_FREQ = 41;

=======
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
TF_SW_STEREO_OFFSET = TF_FREQ_OFFSET + 1;
TF_LR_STEREO_OFFSET = TF_FREQ_OFFSET + 1;
TF_MAX_STEREO = 3;

TF_CODE_OFFSET = TF_SW_STEREO_OFFSET + 1;
TF_ADDITIONAL_CHANNEL_OFFSET = TF_CODE_OFFSET + 1;
TF_ADDITIONAL_STEREO_OFFSET = TF_ADDITIONAL_CHANNEL_OFFSET + 1;

<<<<<<< HEAD
TF_LR_SPEAKER_OFFSET = 7;
TF_SW_SPEAKER_OFFSET = 8;

tf_getTeamSpeakServerName = {
=======
tf_getTeamSpeakServerName = 
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: tf_getTeamSpeakServerName replace with TFAR_fnc_getTeamSpeakServerName";
	call TFAR_fnc_getTeamSpeakServerName
};

<<<<<<< HEAD
tf_getTeamSpeakChannelName = {
=======
tf_getTeamSpeakChannelName = 
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: tf_getTeamSpeakChannelName replace with TFAR_fnc_getTeamSpeakChannelName";
	call TFAR_fnc_getTeamSpeakChannelName
};

<<<<<<< HEAD
tf_isTeamSpeakPluginEnabled = {
=======
tf_isTeamSpeakPluginEnabled = 
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: tf_isTeamSpeakPluginEnabled replace with TFAR_fnc_isTeamSpeakPluginEnabled";
	call TFAR_fnc_isTeamSpeakPluginEnabled
};

<<<<<<< HEAD
tf_setLongRangeRadioFrequency = {
=======
tf_setLongRangeRadioFrequency = 
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: tf_setLongRangeRadioFrequency replace with TFAR_fnc_gsetLongRangeRadioFrequency";
	call TFAR_fnc_gsetLongRangeRadioFrequency
};

<<<<<<< HEAD
tf_setPersonalRadioFrequency = {
=======
tf_setPersonalRadioFrequency = 
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: tf_setPersonalRadioFrequency replace with TFAR_fnc_setPersonalRadioFrequency";
	call TFAR_fnc_setPersonalRadioFrequency
};

<<<<<<< HEAD
generateLrSettings = {
=======
generateLrSettings =
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: generateLrSettings replace with TFAR_fnc_generateLrSettings";
	call TFAR_fnc_generateLrSettings
};

<<<<<<< HEAD
generateSwSetting = {
=======
generateSwSetting =
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	diag_log "WARNING: depreciated function call: generateSwSetting replace with TFAR_fnc_generateSwSettings";
	call TFAR_fnc_generateSwSettings
};