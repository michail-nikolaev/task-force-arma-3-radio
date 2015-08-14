/*
 	Name: TFAR_fnc_processSWStereoKeys
 	
 	Author(s):
		

 	Description:
		Switches the SW stereo setting on the active SW radio.
	
	Parameters:
		0: NUMBER - Stereo number : Range (0,2) (0 - Both, 1 - Left, 2 - Right)
 	
 	Returns:
		BOOLEAN - if handled or not.
 	
 	Example:
		Called via CBA onKey EventHandler
*/
private ["_sw_stereo_number", "_result"];
_sw_stereo_number = _this select 0;
_result = false;

<<<<<<< HEAD
if ((alive TFAR_currentUnit) and {call TFAR_fnc_haveSWRadio}) then {
=======
if ((alive player) and {call TFAR_fnc_haveSWRadio}) then
{
>>>>>>> 0a485c21ade41821aa82f1e93070454dd2f7f086
	private "_radio";
	_radio = call TFAR_fnc_activeSwRadio;
	[_radio, _sw_stereo_number] call TFAR_fnc_setSwStereo;
	[_radio] call TFAR_fnc_ShowRadioVolume;
	_result = true;
};
_result
