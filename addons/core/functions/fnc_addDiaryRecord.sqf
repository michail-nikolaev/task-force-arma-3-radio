#include "script_component.hpp"
/*
  Name: TFAR_fnc_addDiaryRecord

  Author: NKey
    Adds diary help record to briefing.

  Arguments:
    None

  Return Value:
    None

  Example:
    call TFAR_fnc_addDiaryRecord;

  Public: No
*/

player createDiarySubject ["radio", localize LSTRING(subject_name)];
player createDiaryRecord ["radio", [localize LSTRING(radio_diver), localize LSTRING(radio_diver_text)]];
player createDiaryRecord ["radio", [localize LSTRING(radio_control), localize LSTRING(radio_control_text)]];
player createDiaryRecord ["radio", [localize LSTRING(radio_intercept), localize LSTRING(radio_intercept_text)]];
player createDiaryRecord ["radio", [localize LSTRING(radio_vehicle), localize LSTRING(radio_vehicle_text)]];
