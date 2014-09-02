/*
 	Name: TFAR_fnc_processSWChannelKeys
 	
 	Author(s):
		NKey

 	Description:
		Switches the active SW radio to the passed channel.
	
	Parameters:
		0: NUMBER - Channel : Range (0,7)
 	
 	Returns:
		BOOLEAN - If the event was handled by this function.
 	
 	Example:
		Called by CBA.
*/
private ["_sw_channel_number", "_hintText", "_result"];
_sw_channel_number = _this select 0;
_result = false;

if ((call TFAR_fnc_haveSWRadio) and {alive player}) then {
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	[_radio, _sw_channel_number] call TFAR_fnc_setSwChannel;
	[_radio, false] call TFAR_fnc_ShowRadioInfo;
	if (dialog) then {
		call compile getText(configFile >> "CfgWeapons" >> _radio >> "tf_dialogUpdate");
	};
	_result = true;
};
_result