#include "script_component.hpp"

/*
    Name: TFAR_fnc_onAdditionalSwTangentPressed
    
    Author(s):
        NKey

    Description:
        Fired when the additional keybinding for SW is pressed.
    
    Parameters:
    
    Returns:
        BOOLEAN
    
    Example:
        call TFAR_fnc_onAdditionalSwTangentPressed;
*/
private["_depth", "_freq"];
if (!(TF_tangent_sw_pressed) and {alive TFAR_currentUnit} and {call TFAR_fnc_haveSWRadio}) then {	
	if (call TFAR_fnc_isAbleToUseRadio) then {
		_depth = TFAR_currentUnit call TFAR_fnc_eyeDepth;
		if ([TFAR_currentUnit, TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside, [TFAR_currentUnit call TFAR_fnc_vehicleIsIsolatedAndInside, _depth] call TFAR_fnc_canSpeak, _depth] call TFAR_fnc_canUseSWRadio) then {
			private "_radio";
			_radio = call TFAR_fnc_activeSwRadio;
			
			if ((_radio call TFAR_fnc_getAdditionalSwChannel) > -1) then {
				_freq = [_radio, (_radio call TFAR_fnc_getAdditionalSwChannel) + 1] call TFAR_fnc_GetChannelFrequency;
				_dis_freq = "";
				if(tf_radio_show_freq)then
				{
					_dis_freq = _freq;
				}else{
					_dis_freq = "==Hidden==";
				};
				["OnBeforeTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, true, true]] call TFAR_fnc_fireEventHandlers;
				[format[localize "STR_additional_transmit",format ["%1<img size='1.5' image='%2'/>", getText (ConfigFile >> "CfgWeapons" >> _radio >> "displayName"), getText(configFile >> "CfgWeapons"  >> _radio >> "picture")], (_radio call TFAR_fnc_getAdditionalSwChannel) + 1, _dis_freq],
				format["TANGENT	PRESSED	%1%2	%3	%4", _dis_freq, _radio call TFAR_fnc_getSwRadioCode, getNumber(configFile >> "CfgWeapons" >> _radio >> "tf_range") * (call TFAR_fnc_getTransmittingDistanceMultiplicator), getText(configFile >> "CfgWeapons" >> _radio >> "tf_subtype")],
				-1
				] call TFAR_fnc_ProcessTangent;
				TF_tangent_sw_pressed = true;
				//						unit, radio, radioType, additional, buttonDown
				["OnTangent", TFAR_currentUnit, [TFAR_currentUnit, _radio, 0, true, true]] call TFAR_fnc_fireEventHandlers;
			};
		} else {
			call TFAR_fnc_inWaterHint;
		};
	} else {
		call TFAR_fnc_unableToUseHint;
	};
};
false