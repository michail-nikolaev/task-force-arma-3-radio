private ["_request", "_result"];
_request = format["KILLED	%1", name _this];
_result = "task_force_radio_pipe" callExtension _request;