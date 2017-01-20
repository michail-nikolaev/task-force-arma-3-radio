#include "script_component.hpp"

if (!(alive TFAR_currentUnit) or {isNil "TF_sw_dialog_radio"} or {dialog}) exitWith {};

private _dialog_to_open = getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialog");
createDialog _dialog_to_open;
TFAR_currentUnit playAction "Gear";
call compile getText(configFile >> "CfgWeapons" >> TF_sw_dialog_radio >> "tf_dialogUpdate");
["OnRadioOpen", [player, TF_sw_dialog_radio, false, _dialog_to_open, true]] call TFAR_fnc_fireEventHandlers;

true
