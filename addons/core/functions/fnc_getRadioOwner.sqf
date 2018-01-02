#include "script_component.hpp"

/*
 * Name: TFAR_fnc_getRadioOwner
 *
 * Author: Garth de Wet (L-H)
 * Gets the owner of a SR radio.
 *
 * Arguments:
 * 0: radio classname <STRING>
 *
 * Return Value:
 * UID of owner of radio <STRING>
 *
 * Example:
 * _owner = (call TFAR_fnc_activeSwRadio) call TFAR_fnc_getRadioOwner;
 *
 * Public: Yes
 */
params[["_radio", "", [""]]];

(_radio call TFAR_fnc_getSwSettings) param [RADIO_OWNER, ""]
