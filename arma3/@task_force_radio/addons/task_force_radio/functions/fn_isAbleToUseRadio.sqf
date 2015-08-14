private ["_result"];
<<<<<<< HEAD
_result = TFAR_currentUnit getVariable "tf_unable_to_use_radio";
=======
_result = player getVariable "tf_unable_to_use_radio";
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
if (isNil "_result") then {
	_result = false;
};
_result