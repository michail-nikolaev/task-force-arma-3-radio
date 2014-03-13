private "_result";
_result = getNumber (configFile >> "CfgWeapons" >> _this >> "tf_radio");
if (isNil "_result") then
{
	_result = 0;
};

(_result == 1)