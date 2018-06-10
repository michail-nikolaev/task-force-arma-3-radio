#include "script_component.hpp"

/*
  Name: TFAR_core_fnc_stopRadioUsage

  Author: Dorbedo
    interupt the radio usage

  Arguments:
    0: interupt SR <BOOL> (default: True)
    1: interupt LR <BOOL> (default: True)

  Return Value:
    None

  Example:
    _return = [] call TFAR_core_fnc_stopRadioUsage;

  Public: Yes
*/

params [["_SRRadio", true, [true]], ["_LRRadio", true, [true]]];

If (_SRRadio) then {
    call TFAR_fnc_onSwTangentReleasedHack;
    call TFAR_fnc_onAdditionalSwTangentReleased;
} else {
    call TFAR_fnc_onLRTangentReleasedHack;
    call TFAR_fnc_onAdditionalLRTangentReleased;
};
