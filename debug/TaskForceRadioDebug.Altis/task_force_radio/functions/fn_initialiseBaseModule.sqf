/*
 	Name: TFAR_fnc_initialiseBaseModule
 	
 	Author(s):
		L-H
 	
 	Description:
		Initialises variables based on module settings.
 	
 	Parameters:
 	
 	Returns:
		Nothing
 	
 	Example:
	
 */
private ["_logic", "_activated"];
_logic = [_this,0,objNull,[objNull]] call BIS_fnc_param;
_activated = [_this,2,true,[true]] call BIS_fnc_param;

if (_activated) then
{
	private "_radio";
	tf_west_radio_code = _logic getVariable "WestEncryption";
	tf_east_radio_code = _logic getVariable "EastEncryption";
	tf_guer_radio_code = _logic getVariable "GuerEncryption";
	
	// Begin LR radios
	_radio = _logic getVariable "WestLRradio";
	if (([_radio, "tf_hasLrRadio", 0] call TFAR_fnc_getConfigProperty) == 1) then
	{
		TF_defaultWestBackpack = _radio;
	}
	else
	{
		diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid LR radio", _radio];
	};
	_radio = _logic getVariable "EastLRradio";
	if (([_radio, "tf_hasLrRadio", 0] call TFAR_fnc_getConfigProperty) == 1) then
	{
		TF_defaultEastBackpack = _radio;
	}
	else
	{
		diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid LR radio", _radio];
	};
	_radio = _logic getVariable "GuerLRradio";
	if (([_radio, "tf_hasLrRadio", 0] call TFAR_fnc_getConfigProperty) == 1) then
	{
		TF_defaultGuerBackpack = _radio;
	}
	else
	{
		diag_log format ["TFAR ERROR: %1 is not a valid LR radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid LR radio", _radio];
	};
	// end LR radios
	// Begin Personal radios
	_radio = _logic getVariable "WestRadio";
	if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") == 1) then
	{
		TF_defaultWestPersonalRadio = _radio;
	}
	else
	{
		diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
	};
	_radio = _logic getVariable "EastRadio";
	if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") == 1) then
	{
		TF_defaultEastPersonalRadio = _radio;
	}
	else
	{
		diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
	};
	_radio = _logic getVariable "GuerRadio";
	if (getNumber (ConfigFile >> "CfgWeapons" >> _radio >> "tf_prototype") == 1) then
	{
		TF_defaultGuerPersonalRadio = _radio;
	}
	else
	{
		diag_log format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
		hint format ["TFAR ERROR: %1 is not a valid personal radio", _radio];
	};
	// end personal radios
};

true