private ["_result"];
_result = currentUnit getVariable "tf_unable_to_use_radio";
if (isNil "_result") then {
	_result = false;
};
_result