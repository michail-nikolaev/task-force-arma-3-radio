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
	tf_west_radio_code = _logic getVariable "WestEncryption";
	tf_east_radio_code = _logic getVariable "EastEncryption";
	tf_guer_radio_code = _logic getVariable "GuerEncryption";
	TF_defaultWestBackpack = _logic getVariable "WestLRradio";
	TF_defaultEastBackpack = _logic getVariable "EastLRradio";
	TF_defaultGuerBackpack = _logic getVariable "GuerLRradio";
	TF_defaultWestPersonalRadio = _logic getVariable "WestRadio";
	TF_defaultEastPersonalRadio = _logic getVariable "EastRadio";
	TF_defaultGuerPersonalRadio = _logic getVariable "GuerRadio";
};

true