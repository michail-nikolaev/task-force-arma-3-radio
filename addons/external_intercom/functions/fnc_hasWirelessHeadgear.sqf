#include "script_component.hpp"

/*
  Name: TFAR_external_intercom_fnc_hasWirelessHeadgear

  Author: Arend(Saborknight)
    Checks if player is wearing a wireless capable headgear

  Arguments:
    0: Player unit <OBJECT>

  Return Value:
    None

  Example:
    [_player] call TFAR_external_intercom_fnc_hasWirelessHeadgear;

  Public: Yes
*/
params ["_player"];

getNumber (configFile >> "CfgWeapons" >> (headgear _player) >> "TFAR_ExternalIntercomWirelessCapable") > 0 || {(headgear _player) in TFAR_externalIntercomWirelessHeadgear};
