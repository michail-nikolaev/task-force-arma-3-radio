#include "script_component.hpp"

/*
    Name: TFAR_fnc_onSwTangentPressed
    
    Author(s):
        NKey

    Description:
        Fired when the keybinding for SW is pressed.
    
    Parameters:
    
    Returns:
        BOOLEAN
    
    Example:
        call TFAR_fnc_onSwTangentPressed;
*/
private["_depth", "_radio"];
if (time - TF_last_lr_tangent_press > 0.5) then {
	if (!(TF_tangent_sw_pressed) and {alive TFAR_currentUnit} and {call TFAR_fnc_haveSWRadio}) then {	
		if (call TFAR_fnc_isAbleToUseRadio) then {
			_radio = call TFAR_fnc_activeSwRadio;
			if (!([_radio] call TFAR_fnc_RadioOn)) exitWith{};
			_depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
			if ([TFAR_currentUnit, TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside, [TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside, _depth] call TFAR_fnc_canSpeak, _depth] call TFAR_fnc_canUseSWRadio) then {
				["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, false, true]] call TFAR_fnc_fireEventHandlers;
				_dis_freq = "";
				if(tf_radio_show_freq)then
				{
					_dis_freq = call TFAR_fnc_currentSWFrequency;
				}else{
					_dis_freq = "==Hidden==";
				};
				[format[localize "STR_transmit",format ["%1<img size='1.5' image='%2'/>", getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName"),
					getText(configFile >> "CfgWeapons"  >> _radio >> "picture")],(_radio call TFAR_fnc_getSwChannel) + 1, _dis_freq],
				format["TANGENT	PRESSED	%1%2	%3	%4", _dis_freq, _radio call TFAR_fnc_getSwRadioCode, getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range") * (call TFAR_fnc_getTransmittingDistanceMultiplicator), getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")],
				-1
				] call TFAR_fnc_ProcessTangent;
				TF_tangent_sw_pressed = true;
				//						unit, radio, radioType, additional, buttonDown
				["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, false, true]] call TFAR_fnc_fireEventHandlers;
			} else {
				call TFAR_fnc_inWaterHint;
			};
		} else {
			call TFAR_fnc_unableToUseHint;
		};
	};
};
true
