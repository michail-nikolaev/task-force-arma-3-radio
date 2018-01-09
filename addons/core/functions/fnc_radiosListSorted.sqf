#include "script_component.hpp"

/*
  Name: TFAR_fnc_radiosListSorted

  Author: JonBons, NKey, Garth de Wet (L-H)
    Sorts the SW radio list alphabetically.

  Arguments:
    Unit <OBJECT>

  Return Value:
    Radio list sorted. <ARRAY>

  Example:
    _radios = TFAR_currentUnit call TFAR_fnc_radiosListSorted;

  Public: Yes
 */

(_this call TFAR_fnc_radiosList) call BIS_fnc_sortAlphabetically
