/*
 	Name: TFAR_fnc_getConfigProperty
 	
 	Author: NKey
 	
 	Description:
	Gets a config property (getNumber)
	Only works for CfgVehicles.
 	
 	Parameters: 
 	0: STRING - Item classname
	1: STRING - property
 	
 	Returns:
 	NUMBER - Result (or nil if not found)
 	
 	Example:
	
 */
private ["_result", "_item", "_property"];
_item = _this select 0;
_property = _this select 1;
_result = nil;

if (isNumber (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api")) then
{
	_result = getNumber (ConfigFile >> "CfgVehicles" >> _item >> _property + "_api");
};
if (isNil "_result") then
{
	_result = getNumber (ConfigFile >> "CfgVehicles" >> _item >> _property);
};

_result