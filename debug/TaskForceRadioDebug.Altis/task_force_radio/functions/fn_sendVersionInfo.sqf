// send information about version
private ["_request","_result"];
_request = format["VERSION	%1	%2	%3", TF_ADDON_VERSION, tf_radio_channel_name, tf_radio_channel_password];
_result = "task_force_radio_pipe" callExtension _request;