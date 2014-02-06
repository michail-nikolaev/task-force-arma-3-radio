/*
 	Name: TFAR_fnc_getConfigProperty
 	
 	Author(s):
		NKey
		L-H
 	
 	Description:
	Gets a config property (getNumber/getText)
	Only works for CfgVehicles.
 	
 	Parameters: 
 	0: STRING - Item classname
	1: STRING - property
 	
 	Returns:
 	NUMBER - Result
	or
	TEXT
 	
 	Example:
	
 */
private ["_result", "_item", "_property"];
_item = _this select 0;
_property = _this select 1;
_result = nil;
if (isNil "_item" or {_item == ""}) exitWith {0};
if (isNumber (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api")) then
{
	_result = getNumber (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api");
}
else
{
	if (isNumber (ConfigFile >> "CfgVehicles" >> _item >> _property)) then
	{
		_result = getNumber (ConfigFile >> "CfgVehicles" >> _item >> _property);
	}
	else
	{
		if (isText (configFile >> "CfgVehicles" >> _item >> _property + "_api")) then
		{
			_result = getText (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api");
		}
		else
		{
			_result = getText (ConfigFile >> "CfgVehicles" >> _item >> _property);
		};
	};
};

_result