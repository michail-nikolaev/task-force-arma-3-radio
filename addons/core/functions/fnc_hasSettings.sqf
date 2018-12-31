#include "script_component.hpp"
/*
  Name: TFAR_fnc_hasSettings

  Author: Dedmen
    Returns whether settings for this Radio have been initialized

  Arguments:
    0: Radio <ARRAY|STRING>

  Return Value:
    settingsExist <bool>

  Example:
    [(call TFAR_fnc_activeLrRadio)] call TFAR_fnc_hasSettings;

  Public: Yes
*/

params [["_radio","",[[],""]]];

private _isLRRadio = _radio isEqualType [];

if (_isLRRadio) exitWith {
    _radio params ["_radio_object", "_radio_id"];

    private _value = _radio_object getVariable _radio_id;
    !isNil "_value"
};

private _value = TFAR_RadioSettingsNamespace getVariable _radio;
!isNil "_value"