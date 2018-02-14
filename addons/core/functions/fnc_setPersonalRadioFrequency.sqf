#include "script_component.hpp"

/*
  Name: TFAR_fnc_setPersonalRadioFrequency

  Author: NKey
    Sets the frequency for the active SW radio to passed frequency

  Arguments:
    Frequency <STRING>

  Return Value:
    None

  Example:
    "65.12" call TFAR_fnc_setPersonalRadioFrequency;

  Public: Yes
*/

if (call TFAR_fnc_haveSWRadio) then {
    [(call TFAR_fnc_activeSwRadio), _this] call TFAR_fnc_setSwFrequency;
};
