#include "script_component.hpp"

/*
 * Name: TFAR_fnc_setSwRadioCode
 *
 * Author: Garth de Wet (L-H)
 * Allows setting of the encryption code for individual radios.
 *
 * Arguments:
 * 0: Radio classname <STRING>
 * 0: Encryption code <STRING>
 *
 * Return Value:
 * None
 *
 * Example:
 * [call TFAR_fnc_activeSwRadio, "NewEncryptionCode"] call TFAR_fnc_setSwRadioCode;
 *
 * Public: Yes
 */

params ["_radio_id", "_code_to_set"];

private _settings = _radio_id call TFAR_fnc_getSwSettings;
_settings set [TFAR_CODE_OFFSET, _code_to_set];
[_radio_id, _settings] call TFAR_fnc_setSwSettings;
